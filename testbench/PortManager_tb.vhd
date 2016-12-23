----------------------------------------------------------------------------------
-- Engineer: MattM
-- Website: AtmosphericTechnology.com
-- Email/Contact: atmospherictechnology@gmail.com
-- 
-- Create Date:	12:48:34 12/20/2016
-- Design Name: TIS-100_CommPortController
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
--		procedure 
--			rxLeftData <= dataVal;
--			commStart <= '1';
--			wait for clkPeriod * reqWaitTime;
--			rxLeftReq <= '1';
--			wait for 
--			commStart <= '0';
	begin
		-- Hold reset for 5 cycles
		rst <= '1';
		wait for clkPeriod * 5;
		rst <= '0';
		wait for clkPeriod;
		
		-- Start applying stimulus and testing results
		commType <= "00"; -- COMM_RX
		rxPort <= "010"; -- left
		rxLeftData <= "01101000110";
		commStart <= '1';
		rxLeftReq <= '1';
		wait for clkPeriod;
		
		rxLeftReq <= '0';
		commStart <= '0';
		wait for clkPeriod;
		
		rxLeftData <= "00010010100";
		commStart <= '1';
		rxLeftReq <= '1';
		wait for clkPeriod;
		
		rxRightData <= "01100101011";
		rxPort <= "011";
		rxRightReq <= '1';
		wait for clkPeriod;
		
		commStart <= '0';
		rxRightReq <= '0';
		wait for clkPeriod;
		
		rxPort <= "111"; -- last
		commStart <= '1';
		wait for clkPeriod;
		
		rxRightData <= "00111100010";
		commStart <= '0';
		rxRightReq <= '1';
		wait for clkPeriod;
		
		rxRightReq <= '0';
		wait;
	end process;

END;