----------------------------------------------------------------------------------
-- Engineer: MattM
-- Website: AtmosphericTechnology.com
-- Email/Contact: atmospherictechnology@gmail.com
-- 
-- Create Date: 12:48:34 12/20/2016
-- Design Name: TIS-100_PortManager
-- Module Name:	PortManager - Behavioral 
-- Project Name: TIS-100_Evaluation_Kit
-- Tool versions: ISE 14.7
-- Description: 
-- 	
-- Dependencies: 
-- 	
-- Revision: 
-- 	Revision 0.9 - Prerelease version
-- Additional Comments:
-- 	The behaviour of the port is that it always follows a standard loop:
-- 		Start -> Rx -> Tx -> Completed
-- 		Therefore to transmit, the Manager should do the receive without receiving anything.
-- 		The current implementation just takes a shortcut and just pauses for a cycle.
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library unisim;
--use unisim.vcomponents.all;

-----------------------------------------------
-- PortManager
-- Description: 
-----------------------------------------------
entity PortManager is
	port (clk : in std_logic;
		rst : in std_logic;
		clkEnable : in std_logic;
		
		commStart : in std_logic; -- Start the transfer
		commPause : out std_logic; -- Pause the main core
		commType : in std_logic_vector (1 downto 0); -- Type of transfer
		rxPort : in std_logic_vector (2 downto 0); -- Port to receive from
		txPort : in std_logic_vector (2 downto 0); -- Port to transmit to
		dataIn : in std_logic_vector (10 downto 0); -- Data from core to transmit
		dataOut : out std_logic_vector (10 downto 0); -- Data received to send to the core
		debugLast : out std_logic_vector (2 downto 0); -- Debug port for last
		
		-- Rx Port I/O's
		rxLeftOpen : out std_logic;
		rxRightOpen : out std_logic;
		rxUpOpen : out std_logic;
		rxDownOpen : out std_logic;
		rxLeftReq : in std_logic;
		rxRightReq : in std_logic;
		rxUpReq : in std_logic;
		rxDownReq : in std_logic;
		rxLeftData : in std_logic_vector (10 downto 0);
		rxRightData : in std_logic_vector (10 downto 0);
		rxUpData : in std_logic_vector (10 downto 0);
		rxDownData : in std_logic_vector (10 downto 0);
		
		-- Tx Port I/O's
		txLeftOpen : in std_logic;
		txRightOpen : in std_logic;
		txUpOpen : in std_logic;
		txDownOpen : in std_logic;
		txLeftReq : out std_logic;
		txRightReq : out std_logic;
		txUpReq : out std_logic;
		txDownReq : out std_logic;
		txLeftData : out std_logic_vector (10 downto 0);
		txRightData : out std_logic_vector (10 downto 0);
		txUpData : out std_logic_vector (10 downto 0);
		txDownData : out std_logic_vector (10 downto 0));
end PortManager;

architecture Behavioral of PortManager is
	-- Internal signals
	signal rxOpen : std_logic := '0';
	signal rxReq : std_logic := '0';
	signal rxReady : std_logic := '0'; -- Rx transfer is ready this cycle
	signal rxData : std_logic_vector (10 downto 0) := (others => '0'); -- Data received from chosen port
	
	signal txOpen : std_logic := '0';
	signal txReq : std_logic := '0';
	signal txReady : std_logic := '0'; -- Tx transfer is ready this cycle
	signal txData : std_logic_vector (10 downto 0) := (others => '0'); -- Data to transfer to chosen port

	signal last : std_logic_vector (2 downto 0) := "111"; -- storage for the last register. stores the port of the last succesful transfer.
	
	signal dataOutInt : std_logic_vector (10 downto 0) := (others => '0'); -- synchronous version of dataOut. Allows holding the value
	
	-- Stores which port was actually used for the transfer
	-- Needed for any and last to store correctly
	signal rxPortEquiv : std_logic_vector (2 downto 0) := (others => '0');
	signal txPortEquiv : std_logic_vector (2 downto 0) := (others => '0');
	
	type stateType is (S_IDLE, S_RX_TRANSFER, S_TX_TRANSFER);
	signal state, nextState : stateType := S_IDLE;
begin

	dataOut <= dataOutInt;
	debugLast <= last;

	-------------------------------------
	-- transferStatusBitProc
	-- Description: Handles all the status bits related
	-- 	to the communication protocols. handles 
	-- 	which port "any" and "last" relate too and which port to direct
	-- 	the different signals.
	-------------------------------------
	transferStatusBitProc: process(txData, rxPort, txPort, rxOpen, rxReq, rxLeftReq, rxLeftData, rxRightReq, rxRightData, rxUpReq, rxUpData, rxDownReq, rxDownData, last, txOpen, txLeftOpen, txReq, txRightOpen, txUpOpen, txDownOpen) is
	begin
		-- Set initial values for the signals
		rxLeftOpen <= '0';
		rxRightOpen <= '0';
		rxUpOpen <= '0';
		rxDownOpen <= '0';
		rxReq <= '0';
		rxReady <= '0';
		rxData <= (others => '0');
		rxPortEquiv <= rxPort;
		
		txOpen <= '0';
		txLeftReq <= '0';
		txRightReq <= '0';
		txUpReq <= '0';
		txDownReq <= '0';
		txReady <= '0';
		txLeftData <= txData;
		txRightData <= txData;
		txUpData <= txData;
		txDownData <= txData;
		txPortEquiv <= txPort;
		
		-- Route the chosen rx ports signals.
		case rxPort is
			when "010" => -- left
				rxLeftOpen <= rxOpen;
				rxReq <= rxLeftReq;
				rxData <= rxLeftData;
			when "011" => -- right
				rxRightOpen <= rxOpen;
				rxReq <= rxRightReq;
				rxData <= rxRightData;
			when "100" => -- up
				rxUpOpen <= rxOpen;
				rxReq <= rxUpReq;
				rxData <= rxUpData;
			when "101" => -- down
				rxDownOpen <= rxOpen;
				rxReq <= rxDownReq;
				rxData <= rxDownData;
			when "110" => -- any
				-- Choose the port based on the precedence (left > right > up > down)
				-- Rx does not make itself known until the tx does.
				if (rxLeftReq = '1') then
					rxLeftOpen <= rxOpen;
					rxReq <= rxLeftReq;
					rxData <= rxLeftData;
					rxPortEquiv <= "010";
				elsif (rxRightReq = '1') then
					rxRightOpen <= rxOpen;
					rxReq <= rxRightReq;
					rxData <= rxRightData;
					rxPortEquiv <= "011";
				elsif (rxUpReq = '1') then
					rxUpOpen <= rxOpen;
					rxReq <= rxUpReq;
					rxData <= rxUpData;
					rxPortEquiv <= "100";
				elsif (rxDownReq = '1') then
					rxDownOpen <= rxOpen;
					rxReq <= rxDownReq;
					rxData <= rxDownData;
					rxPortEquiv <= "101";
				end if;
			when "111" => -- last
				rxPortEquiv <= last;
				case last is
					when "010" => -- left
						rxLeftOpen <= rxOpen;
						rxReq <= rxLeftReq;
						rxData <= rxLeftData;
					when "011" => -- right
						rxRightOpen <= rxOpen;
						rxReq <= rxRightReq;
						rxData <= rxRightData;
					when "100" => -- up
						rxUpOpen <= rxOpen;
						rxReq <= rxUpReq;
						rxData <= rxUpData;
					when "101" => -- down
						rxDownOpen <= rxOpen;
						rxReq <= rxDownReq;
						rxData <= rxDownData;
					when others =>
						-- No transfer has happened yet, lock up the PortManager
						null;
				end case;
			when others =>
				null;
		end case;
		
		-- Route the chosen tx ports signals.
		case txPort is
			when "010" => -- left
				txOpen <= txLeftOpen;
				txLeftReq <= txReq;
			when "011" => -- right
				txOpen <= txRightOpen;
				txRightReq <= txReq;
			when "100" => -- up
				txOpen <= txUpOpen;
				txUpReq <= txReq;
			when "101" => -- down
				txOpen <= txDownOpen;
				txDownReq <= txReq;
			when "110" => -- any
				-- Tx makes itself known to all ports first then
				-- Chooses the port based on its priority.
				txLeftReq <= txReq;
				txRightReq <= txReq;
				txUpReq <= txReq;
				txDownReq <= txReq;
				
				if (txLeftOpen = '1') then
					txLeftReq <= txReq;
					txRightReq <= '0';
					txUpReq <= '0';
					txDownReq <= '0';
					txOpen <= txLeftOpen;
					txPortEquiv <= "010";
				elsif (txRightOpen = '1') then
					txLeftReq <= '0';
					txRightReq <= txReq;
					txUpReq <= '0';
					txDownReq <= '0';
					txOpen <= txRightOpen;
					txPortEquiv <= "011";
				elsif (txUpOpen = '1') then
					txLeftReq <= '0';
					txRightReq <= '0';
					txUpReq <= txReq;
					txDownReq <= '0';
					txOpen <= txUpOpen;
					txPortEquiv <= "100";
				elsif (txDownOpen = '1') then
					txLeftReq <= '0';
					txRightReq <= '0';
					txUpReq <= '0';
					txDownReq <= txReq;
					txOpen <= txDownOpen;
					txPortEquiv <= "101";
				end if;
			when "111" => -- last
				txPortEquiv <= last;
				case last is
					when "010" => -- left
						txOpen <= txLeftOpen;
						txLeftReq <= txReq;
					when "011" => -- right
						txOpen <= txRightOpen;
						txRightReq <= txReq;
					when "100" => -- up
						txOpen <= txUpOpen;
						txUpReq <= txReq;
					when "101" => -- down
						txOpen <= txDownOpen;
						txDownReq <= txReq;
					when others =>
						-- No transfer has happened yet, lock up the PortManager
						null;
				end case;
			when others =>
				null;
		end case;
		
		-- Signal if the transfer is ready to occur on this cycle
		if ((rxOpen and rxReq) = '1') then
			rxReady <= '1';
		end if;
		if ((txOpen and txReq) = '1') then
			txReady <= '1';
		end if;
	end process;
	
	---------------------------------------
	-- fsmClkedProc
	-- Description: Handles synchronous reset and changing of
	-- 	states for the communication state machine.
	---------------------------------------
	fsmClkdProc: process(clk, rst) is
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				state <= S_IDLE;
				last <= "111";
			else
				state <= nextState;
				
				if (state = S_IDLE) then
					if (commStart = '1') then
						if ((commType = "00") or (commType = "10")) then -- Rx or RxTx
							if (rxReady = '1') then
								dataOutInt <= rxData;
								last <= rxPortEquiv;
							end if;
						end if;
					end if;
				elsif (state = S_RX_TRANSFER) then
					if (rxReady = '1') then
						dataOutInt <= rxData;
						last <= rxPortEquiv;
					end if;
				elsif (state = S_TX_TRANSFER) then
					if (txReady = '1') then
						last <= txPortEquiv;
					end if;
				end if;
			end if;
		end if;
	end process;

	fsmNextStateProc: process(state, commStart, commType, rxReady, txReady) is
	begin
		nextState <= state;
		
		case state is
			when S_IDLE =>
				if (commStart = '1') then
					if (commType = "00") then -- Rx
						if (rxReady = '0') then
							nextState <= S_RX_TRANSFER;
						end if;
					elsif (commType = "01") then -- Tx
						nextState <= S_TX_TRANSFER;
					elsif (commType = "10") then -- RxTx
						if (rxReady = '0') then
							nextState <= S_RX_TRANSFER;
						else
							nextState <= S_TX_TRANSFER;
						end if;
					end if;
				end if;
			when S_RX_TRANSFER =>
				if (rxReady = '1') then
					if (commType = "10") then
						nextState <= S_TX_TRANSFER;
					else
						nextState <= S_IDLE;
					end if;
				end if;
			when S_TX_TRANSFER =>
				if (txReady = '1') then
					nextState <= S_IDLE;
				end if;
			when others =>
				nextState <= S_IDLE;
		end case;
	end process;
	
	---------------------------------------
	-- fsmOutputProc
	-- Description: 
	---------------------------------------
	fsmOutputProc: process(state, commStart, rxReady, commType, dataIn, dataOutInt, txReady) is
	begin
		rxOpen <= '0';
		txReq <= '0';
		txData <= (others => '0');
		commPause <= '0';
		
		case state is
			when S_IDLE =>
				if (commStart = '1') then
					commPause <= '1';
					
					if (commType = "00") then -- Rx
						rxOpen <= '1';
						
						if (rxReady = '1') then
							commPause <= '0';
						end if;
					elsif (commType = "10") then -- RxTx
						rxOpen <= '1';
					end if;
				end if;
			when S_RX_TRANSFER =>
				rxOpen <= '1';
				commPause <= '1';
				
				if ((rxReady = '1') and (commType = "00")) then -- Rx
					commPause <= '0';
				end if;
			when S_TX_TRANSFER =>
				txReq <= '1';
				commPause <= '1';
				
				-- Select the correct source for txData
				if (commType = "01") then -- Tx
					txData <= dataIn;
				elsif (commType = "10") then -- RxTx
					txData <= dataOutInt;
				end if;
				
				if (txReady = '1') then
					commPause <= '0';
				end if;
			when others =>
				null;
		end case;
	end process;
end Behavioral;