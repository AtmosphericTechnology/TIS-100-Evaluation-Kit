----------------------------------------------------------------------------------
-- Engineer: MattM
-- Website: AtmosphericTechnology.com
-- Email/Contact: atmospherictechnology@gmail.com
-- 
-- Create Date:	12:48:34 12/20/2016
-- Design Name: TIS-100_PortManager
-- Module Name:	PortManager_tb - Behavioral 
-- Project Name: TIS-100_Evaluation_Kit
-- Tool versions: ISE 14.7
-- Description: 
-- 	
-- Dependencies: 
-- 	
-- Revision: 
-- 	Revision 0.9 - Prerelease version
-- Additional Comments:
-- 	
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Import utilities to aid simulation
library work;
use work.simUtilitiesPkg.all;

entity PortManager_tb is
end PortManager_tb;

architecture Behavior of PortManager_tb is

	-- Component Declaration for the Unit Under Test (UUT)
	component PortManager is
		port (clk : in std_logic;
			rst : in std_logic;
			clkEnable : in std_logic;
			commStart : in std_logic;
			commPause : out std_logic;
			commType : in std_logic_vector (1 downto 0);
			rxPort : in std_logic_vector (2 downto 0);
			txPort : in std_logic_vector (2 downto 0);
			dataIn : in std_logic_vector (10 downto 0);
			dataOut : out std_logic_vector (10 downto 0);
			debugLast : out std_logic_vector (2 downto 0);
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
	end component;

	-- Inputs
	signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	signal clkEnable : std_logic := '0';
	signal commStart : std_logic := '0';
	signal commType : std_logic_vector (1 downto 0) := (others => '0');
	signal rxPort : std_logic_vector (2 downto 0) := (others => '0');
	signal txPort : std_logic_vector (2 downto 0) := (others => '0');
	signal dataIn : std_logic_vector (10 downto 0) := (others => '0');
	signal rxLeftReq : std_logic := '0';
	signal rxRightReq : std_logic := '0';
	signal rxUpReq : std_logic := '0';
	signal rxDownReq : std_logic := '0';
	signal rxLeftData : std_logic_vector (10 downto 0) := (others => '0');
	signal rxRightData : std_logic_vector (10 downto 0) := (others => '0');
	signal rxUpData : std_logic_vector (10 downto 0) := (others => '0');
	signal rxDownData : std_logic_vector (10 downto 0) := (others => '0');
	signal txLeftOpen : std_logic := '0';
	signal txRightOpen : std_logic := '0';
	signal txUpOpen : std_logic := '0';
	signal txDownOpen : std_logic := '0';

	-- Outputs
	signal commPause : std_logic;
	signal dataOut : std_logic_vector (10 downto 0);
	signal debugLast : std_logic_vector (2 downto 0);
	signal rxLeftOpen : std_logic;
	signal rxRightOpen : std_logic;
	signal rxUpOpen : std_logic;
	signal rxDownOpen : std_logic;
	signal txLeftReq : std_logic;
	signal txRightReq : std_logic;
	signal txUpReq : std_logic;
	signal txDownReq : std_logic;
	signal txLeftData : std_logic_vector (10 downto 0);
	signal txRightData : std_logic_vector (10 downto 0);
	signal txUpData : std_logic_vector (10 downto 0);
	signal txDownData : std_logic_vector (10 downto 0);
	
	-- stimProvider I/O
--	signal commStart2 : std_logic := '0';
--	signal commPause2 : std_logic;
--	signal commType2 : std_logic_vector (1 downto 0) := (others => '0');
--	signal rxPort2 : std_logic_vector (2 downto 0) := (others => '0');
--	signal txPort2 : std_logic_vector (2 downto 0) := (others => '0');
--	signal dataIn2 : std_logic_vector (10 downto 0) := (others => '0');
--	signal dataOut2 : std_logic_vector (10 downto 0);
--	signal debugLast2 : std_logic_vector (2 downto 0);

	-- Clock period definitions
	constant clkPeriod : time := 10 ns;
begin

	-- Instantiate the Unit Under Test (UUT)
	uut: PortManager
		port map (clk => clk,
			rst => rst,
			clkEnable => clkEnable,
			commStart => commStart,
			commPause => commPause,
			commType => commType,
			rxPort => rxPort,
			txPort => txPort,
			dataIn => dataIn,
			dataOut => dataOut,
			debugLast => debugLast,
			rxLeftOpen => rxLeftOpen,
			rxRightOpen => rxRightOpen,
			rxUpOpen => rxUpOpen,
			rxDownOpen => rxDownOpen,
			rxLeftReq => rxLeftReq,
			rxRightReq => rxRightReq,
			rxUpReq => rxUpReq,
			rxDownReq => rxDownReq,
			rxLeftData => rxLeftData,
			rxRightData => rxRightData,
			rxUpData => rxUpData,
			rxDownData => rxDownData,
			txLeftOpen => txLeftOpen,
			txRightOpen => txRightOpen,
			txUpOpen => txUpOpen,
			txDownOpen => txDownOpen,
			txLeftReq => txLeftReq,
			txRightReq => txRightReq,
			txUpReq => txUpReq,
			txDownReq => txDownReq,
			txLeftData => txLeftData,
			txRightData => txRightData,
			txUpData => txUpData,
			txDownData => txDownData);
	
--	stimProvider: PortManager
--		port map (clk => clk,
--			rst => rst,
--			clkEnable => clkEnable,
--			commStart => commStart2,
--			commPause => commPause2,
--			commType => commType2,
--			rxPort => rxPort2,
--			txPort => txPort2,
--			dataIn => dataIn2,
--			dataOut => dataOut2,
--			debugLast => debugLast2,
--			txLeftOpen => rxLeftOpen,
--			txRightOpen => rxRightOpen,
--			txUpOpen => rxUpOpen,
--			txDownOpen => rxDownOpen,
--			txLeftReq => rxLeftReq,
--			txRightReq => rxRightReq,
--			txUpReq => rxUpReq,
--			txDownReq => rxDownReq,
--			txLeftData => rxLeftData,
--			txRightData => rxRightData,
--			txUpData => rxUpData,
--			txDownData => rxDownData,
--			rxLeftOpen => txLeftOpen,
--			rxRightOpen => txRightOpen,
--			rxUpOpen => txUpOpen,
--			rxDownOpen => txDownOpen,
--			rxLeftReq => txLeftReq,
--			rxRightReq => txRightReq,
--			rxUpReq => txUpReq,
--			rxDownReq => txDownReq,
--			rxLeftData => txLeftData,
--			rxRightData => txRightData,
--			rxUpData => txUpData,
--			rxDownData => txDownData);

	-- Clock process definitions
	clkProc: process is
	begin
		clk <= '0';
		wait for clkPeriod/2;
		
		clk <= '1';
		wait for clkPeriod/2;
	end process;

	-- Stimulus process
	stimProc: process
		-- Seed values to pass into the RNG
		variable seed1 : positive := 17623475;
		variable seed2 : positive := 7861234;
		
		----------------------------------
		-- intToPort
		-- Description: Converts passed in integer to a std_logic_vector
		-- 	corresponding to that port
		----------------------------------
		function intToPort(selPort : integer range 1 to 6) return std_logic_vector is
		begin
			case selPort is
				when 1 =>
					return "010"; -- Left
				when 2 =>
					return "011"; -- Right
				when 3 =>
					return "100"; -- Up
				when 4 =>
					return "101"; -- Down
				when 5 =>
					return "110"; -- Any
				when 6 =>
					return "111"; -- Last
			end case;
		end intToPort;
		
		----------------------------------
		-- portToInt
		-- Description: Converts passed in std_logic_vector to corresponding integer
		----------------------------------
		function portToInt(selPort : std_logic_vector (2 downto 0)) return integer is
		begin
			case selPort is
				when "010" => -- Left
					return 1;
				when "011" => -- Right
					return 2;
				when "100" => -- Up
					return 3;
				when "101" => -- Down
					return 4;
				when "110" => -- Any
					return 5;
				when "111" => -- Last
					return 6;
			end case;
		end portToInt;
		
		impure function randInt(upper, lower : real) return integer is
			variable tempOut : integer range -999 to 999;
		begin
			randInt(seed1, seed2, upper, lower, tempOut);
			return tempOut;
		end randInt;
		
		----------------------------------
		-- randData
		-- Description: Return a random std_logic_vector (10 downto 0)
		----------------------------------
		impure function randData return std_logic_vector is
			variable tempOut : integer range -999 to 999;
		begin
			randInt(seed1, seed2, -999.0, 999.0, tempOut);
			return intToVector(tempOut, 11);
		end randData;
		
		----------------------------------
		-- getData
		-- Description: Returns data from tx port
		----------------------------------
		impure function getData(selPort : integer range 1 to 4) return std_logic_vector is
		begin
			case selPort is
				when 1 => -- Left
					return txLeftData;
				when 2 => -- Right
					return txRightData;
				when 3 => -- Up
					return txUpData;
				when 4 => -- Down
					return txDownData;
			end case;
		end getData;
		
		----------------------------------
		-- getOpen
		-- Description: Returns value of open from a given rx port
		----------------------------------
		impure function getOpen(selPort : integer range 1 to 4) return std_logic is
		begin
			case selPort is
				when 1 => -- Left
					return rxLeftOpen;
				when 2 => -- Right
					return rxRightOpen;
				when 3 => -- Up
					return rxUpOpen;
				when 4 => -- Down
					return rxDownOpen;
			end case;
		end getOpen;
		
		----------------------------------
		-- getReq
		-- Description: Returns value of req from a given tx port
		----------------------------------
		impure function getReq(selPort : integer range 1 to 4) return std_logic is
		begin
			case selPort is
				when 1 => --  Left
					return txLeftReq;
				when 2 => -- Right
					return txRightReq;
				when 3 => -- Up
					return txUpReq;
				when 4 => -- Down
					return txDownReq;
			end case;
		end getReq;
		
		----------------------------------
		-- setRxPort
		-- Description: Set the value of rxPort
		----------------------------------
		procedure setRxPort(selPort : in integer range 1 to 6) is
		begin
			rxPort <= intToPort(selPort);
		end setRxPort;
		
		----------------------------------
		-- setTxPort
		-- Description: Set the value of txPort
		----------------------------------
		procedure setTxPort(selPort : in integer range 1 to 6) is
		begin
			txPort <= intToPort(selPort);
		end setTxPort;
		
		----------------------------------
		-- setData
		-- Description: Set the data going into an rx port to the
		-- 	given value
		----------------------------------
		procedure setData(selPort : in integer range 1 to 4; dataVal : in std_logic_vector (10 downto 0)) is
		begin
			case selPort is
				when 1 => -- Left
					rxLeftData <= dataVal;
				when 2 => -- Right
					rxRightData <= dataVal;
				when 3 => -- Up
					rxUpData <= dataVal;
				when 4 => -- Down
					rxDownData <= dataVal;
			end case;
		end setData;
		
		----------------------------------
		-- setOpen
		-- Description: Set open for a given tx port
		----------------------------------
		procedure setOpen(selPort : in integer range 1 to 4; openVal : in std_logic) is
		begin
			case selPort is
				when 1 => -- Left
					txLeftOpen <= openVal;
				when 2 => -- Right
					txRightOpen <= openVal;
				when 3 => -- Up
					txUpOpen <= openVal;
				when 4 => -- Down
					txDownOpen <= openVal;
			end case;
		end setOpen;
		
		----------------------------------
		-- setReq
		-- Description: Set the req for a given rx port
		----------------------------------
		procedure setReq(selPort : in integer range 1 to 4; reqVal : in std_logic) is
		begin
			case selPort is
				when 1 => -- Left
					rxLeftReq <= reqVal;
				when 2 => -- Right
					rxRightReq <= reqVal;
				when 3 => -- Up
					rxUpReq <= reqVal;
				when 4 => -- Down
					rxDownReq <= reqVal;
			end case;
		end setReq;
		
		----------------------------------
		-- setupComms
		-- Description: Sets the commType, Rx and Tx Ports
		-- 	and starts the transaction
		----------------------------------
		procedure setupComms(commTypeIn : in std_logic_vector (1 downto 0); receivePort, transmitPort : in integer range 1 to 6) is
		begin
			commType <= commTypeIn;
			setRxPort(receivePort);
			setTxPort(transmitPort);
			commStart <= '1', '0' after clkPeriod; -- hold start high for 1 cycle then low again
		end setupComms;
		
		----------------------------------
		-- delayCycle
		-- Description: Wait for 1 clk cycle
		----------------------------------
		procedure delayCycle is
		begin
			wait until falling_edge(clk);
		end delayCycle;
		
		----------------------------------
		-- delayCycles
		-- Description: Wait for a given number of cycles
		----------------------------------
		procedure delayCycles(numCycles : in integer) is
		begin
			if (numCycles > 0) then
				for i in 1 to numCycles loop
					wait until falling_edge(clk);
				end loop;
			end if;
		end delayCycles;
		
		----------------------------------
		-- stimulateReceiveAny
		-- Description: Set different rx ports at different times
		-- 	to test the order of precedence of the "Any" pseudo-port
		----------------------------------
		procedure stimulateReceiveAny(targetPort : in integer range 1 to 4; testData : in std_logic_vector (10 downto 0)) is
			variable randData : integer range -999 to 999; -- storage to generate random data
		begin
			wait for 1 ns; -- Offset from the clk edge
			-- If there are ports lower in priority than the target port
			-- Loop through and set them first
			if (targetPort < 4) then
				for i in 4 downto (targetPort + 1) loop
					randInt(seed1, seed2, -999.0, 999.0, randData);
					setData(i, intToVector(randData, 11));
					setReq(i, '1');
					wait for 1 ns; -- Wait to allow offset
				end loop;
			end if;
			
			-- Set the target port
			setData(targetPort, testData);
			setReq(targetPort, '1');
		end stimulateReceiveAny;
		
		----------------------------------
		-- stimulateTransmitAny
		-- Description: Same as stimulateReceiveAny but for tx ports
		----------------------------------
		procedure stimulateTransmitAny(targetPort : in integer range 1 to 4) is
		begin
			wait for 1 ns; -- Offset from clk edge
			-- If there are ports of lower priority than target port
			-- Loop through and set them first
			if (targetPort < 4) then
				for i in 4 downto (targetPort + 1) loop
					setOpen(i, '1');
					wait for 1 ns;
				end loop;
			end if;
			setOpen(targetPort, '1'); -- Set the target port
		end stimulateTransmitAny;
		
		----------------------------------
		-- resetReceiveAny
		-- Description: Reset all rx ports to default state
		----------------------------------
		procedure resetReceiveAny is
		begin
			-- Loop through ports and reset them
			for i in 1 to 4 loop
				setData(i, "00000000000");
				setReq(i, '0');
			end loop;
		end resetReceiveAny;
		
		----------------------------------
		-- resetTransmitAny
		-- Description: Same as resetReceiveAny but for tx ports
		----------------------------------
		procedure resetTransmitAny is
		begin
			-- Loop through ports and reset them
			for i in 1 to 4 loop
				setOpen(i, '0');
			end loop;
		end resetTransmitAny;
		
		----------------------------------
		-- receiveData
		-- Description: Set rx port flags to receive data, wait a cycle
		-- 	then reset the port. Also handles the pseudo-ports
		----------------------------------
		procedure receiveData(selPort : in integer range 1 to 6; testData : in std_logic_vector (10 downto 0)) is
			variable lastPort : integer range 1 to 4; -- Current last port as an int
			variable targetPort : integer range 1 to 4; -- Port targeted by "Any"
		begin
			if (selPort /= 5) then -- Physical comm port or Last
				if (selPort = 6) then -- Last
					-- Convert the vector form of last port to int
					-- then set port flags
					lastPort := portToInt(debugLast);
					report "receiveData lastPort: " & integer'image(lastPort) & LF & LF; -- Print out the port for debuging
					
					setData(lastPort, testData);
					setReq(lastPort, '1');
				else -- Physical comm port
					setData(selPort, testData);
					setReq(selPort, '1');
				end if;
			else -- Any
				-- Chose a random port, print it, then call stimulateReceiveAny on it
				randInt(seed1, seed2, 1.0, 4.0, targetPort);
				report "receiveData targetPort: " & integer'image(targetPort) & LF & LF;
				
				stimulateReceiveAny(targetPort, testData);
			end if;
			delayCycle; -- Step to execute
			
			-- Reset all rx ports to default state
			resetReceiveAny;
		end receiveData;
		
		----------------------------------
		-- transmitData
		-- Description: Same as receiveData but for transmitting
		----------------------------------
		procedure transmitData(selPort : in integer range 1 to 6) is
			variable lastPort : integer range 1 to 4; -- Current last port as an int
			variable targetPort : integer range 1 to 4; -- Port targeted by "Any"
		begin
			if (selPort /= 5) then -- Physical comm port or Last
				if (selPort = 5) then -- Last
					lastPort := portToInt(debugLast); -- convert vector form to int
					report "transmitData lastPort: " & integer'image(lastPort) & LF & LF;
					
					setOpen(lastPort, '1');
				else -- Physical comm port
					setOpen(selPort, '1');
				end if;
			else -- Any
				-- Choose a random port to target
				randInt(seed1, seed2, 1.0, 4.0, targetPort);
				report "transmitData targetPort: " & integer'image(targetPort) & LF & LF;
				
				stimulateTransmitAny(targetPort);
			end if;
			delayCycle; -- Step to execute
			
			-- Reset all tx ports to deault state
			resetTransmitAny;
		end transmitData;
		
		----------------------------------
		-- testReceivePort
		-- Description: Apply stimulus to test the PortManager
		-- 	when receiving data
		----------------------------------
		procedure testReceivePort(receivePort : in integer range 1 to 6; testData : in std_logic_vector (10 downto 0); receiveDelay : in natural) is
		begin
			-- Setup the comm's settings
			setupComms("00", receivePort, 1);
			delayCycles(receiveDelay); -- Delay speciefied time
			
			receiveData(receivePort, testData);
		end testReceivePort;
		
		----------------------------------
		-- testTransmitPort
		-- Descritpion: Apply stimulus to test the PortManager
		-- 	when transmitting data
		----------------------------------
		procedure testTransmitPort(transmitPort : in integer range 1 to 6; testData : in std_logic_vector (10 downto 0); transmitDelay : in natural) is
		begin
			-- Setup comm's then wait the required cycle
			setupComms("01", 1, transmitPort);
			delayCycle;
			
			-- Delay for specified time
			delayCycles(transmitDelay);
			
			-- Set the data to send then transmit it
			dataIn <= testData;
			transmitData(transmitPort);
		end testTransmitPort;
		
		----------------------------------
		-- testReceiveTransmitPort
		-- Description: Apply stimulus to test the PortManager
		-- 	when receiving data then re-transmitting it
		----------------------------------
		procedure testReceiveTransmitPort(receivePort, transmitPort : in integer range 1 to 6; testData : in std_logic_vector (10 downto 0); receiveDelay, transmitDelay : in natural) is
		begin
			-- Setup comms then delay the specified time
			setupComms("10", receivePort, transmitPort);
			delayCycles(receiveDelay);
			
			-- Receive data then delay specified time before transmitting
			receiveData(receivePort, testData);
			delayCycles(transmitDelay);
			
			-- Transmit the received data
			transmitData(transmitPort);
		end testReceiveTransmitPort;
		
		----------------------------------
		-- testReceivePort (w/o specified delay)
		-- Description: Macro to specify testReceivePort without a delay
		----------------------------------
		procedure testReceivePort(receivePort : in integer range 1 to 6; testData : in std_logic_vector (10 downto 0)) is
		begin
			testReceivePort(receivePort, testData, 0);
		end testReceivePort;
		
		----------------------------------
		-- testTransmitPort (w/o specified delay)
		-- Description: Macro to specify testTransmitPort without a delay
		----------------------------------
		procedure testTransmitPort(transmitPort : in integer range 1 to 6; testData : in std_logic_vector (10 downto 0)) is
		begin
			testTransmitPort(transmitPort, testData, 0);
		end testTransmitPort;
		
		----------------------------------
		-- testReceiveTransmitPort (w/o specified delay)
		-- Description: Macro to specify testReceiveTransmitPort without a delay
		----------------------------------
		procedure testReceiveTransmitPort(receivePort, transmitPort : in integer range 1 to 6; testData : in std_logic_vector (10 downto 0)) is
		begin
			testReceiveTransmitPort(receivePort, transmitPort, testData, 0, 0);
		end testReceiveTransmitPort;
	begin
		-- Hold reset for 100 ns
		rst <= '1';
		wait for 100 ns;
		
		rst <= '0';
		wait until falling_edge(clk); -- sync to clk edge
		wait until falling_edge(clk); -- wait 1 cycle
		
		-- Start applying stimulus and testing results
		-- Testing receive with physical ports
		testReceivePort(1, randData);
		testReceivePort(2, randData);
		testReceivePort(3, randData);
		testReceivePort(4, randData);
		-- Test with random delays
		for i in 1 to 10 loop
			testReceivePort(randInt(1.0, 4.0), randData, randInt(1.0, 2.0));
		end loop;
		
		-- Test receiving from "Last"
		-- Test multiple times
		for i in 1 to 10 loop
			-- Set to random port
			testReceivePort(randInt(1.0, 4.0), randData);
			-- Test "Last" with random delays
			testReceivePort(6, randData, randInt(0.0, 2.0));
		end loop;
		
		-- Test receiving from "Any"
		-- Test multiple times
		for i in 1 to 10 loop
			-- Test "Any" with random delays
			testReceivePort(5, randData, randInt(0.0, 2.0));
		end loop;
		
		-- Test transmitting from physical ports
		testTransmitPort(1, randData);
		testTransmitPort(2, randData);
		testTransmitPort(3, randData);
		testTransmitPort(4, randData);
		-- Test with random delays
		for i in 1 to 10 loop
			testTransmitPort(randInt(1.0, 4.0), randData, randInt(1.0, 2.0));
		end loop;
		
		-- Test receiving from "Last"
		-- Test multiple times
		for i in 1 to 10 loop
			-- Set to random port
			testTransmitPort(randInt(1.0, 4.0), randData);
			-- Test "Last" with random delays
			testTransmitPort(6, randData, randInt(0.0, 2.0));
		end loop;
		
		-- Test receiving from "Any"
		-- Test multiple times
		for i in 1 to 10 loop
			-- Test "Any" with random delays
			testTransmitPort(5, randData, randInt(0.0, 2.0));
		end loop;
		
		-- Test receiving and transmitting from physical ports
		for i in 1 to 10 loop
			testReceiveTransmitPort(randInt(1.0, 4.0), randInt(1.0, 4.0), randData, 0, 0);
		end loop;
		
		-- Test receiving and transmitting from physical ports with random delays
		for i in 1 to 10 loop
			testReceiveTransmitPort(randInt(1.0, 4.0), randInt(1.0, 4.0), randData, randInt(1.0, 2.0), randInt(0.0, 2.0));
		end loop;
		
		-- Test receiving and transmitting with random ports and random delays
		for i in 1 to 30 loop
			testReceiveTransmitPort(randInt(1.0, 6.0), randInt(1.0, 6.0), randData, randInt(0.0, 2.0), randInt(0.0, 2.0));
		end loop;
		
		-- Wait till finish
		wait;
	end process;
end;