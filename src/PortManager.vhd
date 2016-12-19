----------------------------------------------------------------------------------
-- Engineer: MattM
-- Website: AtmosphericTechnology.com
-- Email/Contact: atmospherictechnology@gmail.com
-- 
-- Create Date:	 13:42:36 10/04/2016 
-- Project Name: TIS-100_CPU
-- Module Name:	 PortManager - Behavioral 
-- Tool versions: ISE 14.7
-- Description: 
-- 	The PortManager manages all the ext. communications and protocol
-- 	details.
--
-- Revision: 
-- Revision 0.9 - Prerelease version
-- Additional Comments: 
-- 	More details of communication protocol to come
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library unisim;
--use unisim.vcomponents.all;

-- TODO: After recently checking the timing for the ports, It is different to what was originally thought
--			They don't have to idle if the reading is coming from a port that is already ready.
--			If that port executes at the same time, then it needs to delay 1 cycle.
--			reading happens on the first cycle (if rxReq is ready) and the write always happens on the second cycle (it will delay 1 if there is no rx).

entity PortManager is
	port (clk : in std_logic;
		rst : in std_logic;
		commStart : in std_logic;
		commPause : out std_logic;
		commType : in std_logic_vector (1 downto 0);
		rxPort : in std_logic_vector (2 downto 0);
		txPort : in std_logic_vector (2 downto 0);
		dataIn : in signed (10 downto 0);
		dataOut : out signed (10 downto 0);
		last : out std_logic_vector (2 downto 0);
		
		rxLeftOpen : out std_logic;
		rxRightOpen : out std_logic;
		rxUpOpen : out std_logic;
		rxDownOpen : out std_logic;
		rxLeftReq : in std_logic;
		rxRightReq : in std_logic;
		rxUpReq : in std_logic;
		rxDownReq : in std_logic;
		rxLeftData : in signed (10 downto 0);
		rxRightData : in signed (10 downto 0);
		rxUpData : in signed (10 downto 0);
		rxDownData : in signed (10 downto 0);
		
		txLeftOpen : in std_logic;
		txRightOpen : in std_logic;
		txUpOpen : in std_logic;
		txDownOpen : in std_logic;
		txLeftReq : out std_logic;
		txRightReq : out std_logic;
		txUpReq : out std_logic;
		txDownReq : out std_logic;
		txLeftData : out signed (10 downto 0);
		txRightData : out signed (10 downto 0);
		txUpData : out signed (10 downto 0);
		txDownData : out signed (10 downto 0));

end PortManager;

architecture Behavioral of PortManager is
	signal rxOpen : std_logic := '0';
	signal rxReq : std_logic := '0';
	signal rxComplete : std_logic := '0';
	signal rxData : signed (10 downto 0) := "00000000000";
	signal rxDataReg : signed (10 downto 0) := "00000000000"; -- Internal register for rxData
	signal rxDataNext : signed (10 downto 0) := "00000000000"; -- Holds next value for rxData, it the output
	signal rxDataLoad : std_logic := '0'; -- Enabled when new data should be loaded (into the register)
	signal txOpen : std_logic := '0';
	signal txReq : std_logic := '0';
	signal txComplete : std_logic := '0';
	signal txData : signed (10 downto 0) := "00000000000";
	
	-- lastInt = internal storage for last
	signal lastInt : std_logic_vector (2 downto 0) := (others => '1'); -- set the 'last' register to an invalid port.
	signal nextLast : std_logic_vector (2 downto 0) := lastInt;

	type stateType is (S_IDLE, S_RX_TRANSFER, S_TX_TRANSFER);
	signal state, nextState : stateType := S_IDLE;
begin

	dataOut <= rxDataNext; -- rxDataNext holds the current value for rxData. Needed because of the "sample and hold" style functionality
	last <= lastInt;

	-- TODO: Look into maybe using a variable instead of doing it this way
	rxDataFFProc: process (clk, rxDataReg, rxDataLoad, rxData, rxDataNext) is
	begin
		rxDataNext <= rxDataReg;
		if rxDataLoad = '1' then
			rxDataNext <= rxData;
		end if;
		
		if rising_edge(clk) then
			rxDataReg <= rxDataNext;
		end if;
	end process;

	-- TODO: Change the ports to be busses
	
	-- put the selected port's data and status bits into the signals
	rxTxDataStatusBitsProc: process (rxPort, rxOpen, txData, rxLeftReq, rxLeftData, rxRightReq, rxRightData, rxUpReq, rxUpData, rxDownReq, rxDownData, txLeftOpen, txReq, txRightOpen, txUpOpen, txDownOpen, txPort, rxReq, txOpen, lastInt) is
		variable rxPortEffective : std_logic_vector (2 downto 0) := "111"; --  The effective port of rx (needed for last)
		variable txPortEffective : std_logic_vector (2 downto 0) := "111"; --  The effective port of tx (needed for last)
	begin
		-- TODO: Break out some of the sections into their own processes, make it look neater
		rxLeftOpen <= '0';
		rxRightOpen <= '0';
		rxUpOpen <= '0';
		rxDownOpen <= '0';
		rxReq <= '0';
		rxData <= "00000000000";
		
		txLeftReq <= '0';
		txRightReq <= '0';
		txUpReq <= '0';
		txDownReq <= '0';
		txLeftData <= txData;
		txRightData <= txData;
		txUpData <= txData;
		txDownData <= txData;
		txOpen <= '0';
		
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
			when "111" => -- last
				case lastInt is
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
					when others => -- no comm yet, lock up the PortManager
						null;
				end case;
			when others =>
				null;
		end case;
		
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
			when "111" => -- last
				case lastInt is
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
					when others => -- no comm yet, lock up the PortManager
						null;
				end case;
			when others =>
				null;
		end case;
		
		if (rxOpen and rxReq) = '1' then
			rxComplete <= '1';
		else
			rxComplete <= '0';
		end if;
		
		if (txOpen and txReq) = '1' then
			txComplete <= '1';
		else
			txComplete <= '0';
		end if;
	end process;
	
	clkdProc: process(clk, rst) is
		-- TODO: latch the txData and rxData so they hold their value.
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				state <= S_IDLE;
				lastInt <= "111";
			else
				state <= nextState;
				lastInt <= nextLast;
				
				if state = S_IDLE then
					if nextState /= S_IDLE then
						if commType = "01" then -- tx
							txData <= dataIn;
						end if;
					end if;
				elsif nextState = S_IDLE then
					-- been too long, cant remember what should go here.
				end if;
			end if;
		end if;
	end process;

	-- TODO: rx needs to happen on the first cycle, not the second cycle
	outputProc: process(state, commStart, rxComplete, txComplete, commType, lastInt, rxPort, txPort) is
	begin
		rxOpen <= '0';
		txReq <= '0';
		rxDataLoad <= '0';
		commPause <= '0';
		nextLast <= lastInt;
		case state is
			when S_IDLE =>
				if commStart = '1' then
					commPause <= '1';
				end if;
			when S_RX_TRANSFER =>
				rxOpen <= '1';
				commPause <= '1';
				rxDataLoad <= '1';
				nextLast <= rxPort; -- TODO: add support for last.
				if (rxComplete = '1') and (commType = "00") then
					commPause <= '0';
				end if;
			when S_TX_TRANSFER =>
				txReq <= '1';
				nextLast <= txPort;
				if (txComplete = '0') then
					commPause <= '1';
				else
					commPause <= '0';
				end if;
			when others =>
				null;
		end case;
	end process;

	nextStateProc: process(state, commStart, rxComplete, txComplete, commType) is
	begin
		nextState <= state;
		case state is
			when S_IDLE =>
				if (commStart = '1') then
					if (commType = "00") OR (commType = "10") then -- rx or both 
						nextState <= S_RX_TRANSFER;
					elsif (commType = "01") then
						nextState <= S_TX_TRANSFER;
					end if;
				end if;
			when S_RX_TRANSFER =>
				if (rxComplete = '1') then
					if (commType = "10") then
						nextState <= S_TX_TRANSFER;
					else
						nextState <= S_IDLE;
					end if;
				end if;
			when S_TX_TRANSFER =>
				if (txComplete = '1') then
					nextState <= S_IDLE;
				end if;
			when others =>
				nextState <= S_IDLE;
		end case;
	end process;

end Behavioral;

