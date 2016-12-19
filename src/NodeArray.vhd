----------------------------------------------------------------------------------
-- Engineer: MattM
-- Website: AtmosphericTechnology.com
-- Email/Contact: atmospherictechnology@gmail.com
-- 
-- Create Date:	 18:03:56 11/20/2016 
-- Project Name: TIS-100_CPU
-- Module Name:	 NodeArray - Behavioral 
-- Tool versions: ISE 14.7
--
-- Description: 
-- 	An array of different T-XX nodes connected together.
-- 	Provides multiple selectable interfaces to control the array.
--
-- Revision: 
-- 	Revision 0.9 - Prerelease version
-- Additional Comments: 
-- 	N/A
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library unisim;
--use unisim.vcomponents.all;

entity NodeArray is
	Port (clk : in std_logic;
		rst : in std_logic;
		node1Out : out signed (10 downto 0));
end NodeArray;

architecture Behavioral of NodeArray is
--	component NodeArrayController is
--		port (clk : in std_logic;
--			rst : in std_logic;
--			uartClk : in std_logic;
--			uartTx : out std_logic;
--			txStart : in std_logic;
--			uartDone : out std_logic;
--			nodeAcc : in signed (10 downto 0);
--			nodeClk : out std_logic);
--	end component;
	
	component ArrayCommPort is
		port (clk : in std_logic;
			rst : in std_logic;
			dataIn : in signed (10 downto 0);
			dataOut : out signed (10 downto 0);
			rxData : in signed (10 downto 0);
			rxOpen : out std_logic;
			rxReq : in std_logic;
			txData : out signed (10 downto 0);
			txOpen : in std_logic;
			txReq : out std_logic);
	end component;
	
	component T21Node is
		port (clk : in std_logic;
			rst : in std_logic;
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
			debugAddress : out std_logic_vector (3 downto 0);
			debugACC : out signed (10 downto 0);
			debugBAK : out signed (10 downto 0);
			debugLAST : out std_logic_vector (2 downto 0);
			rxLeftOpen : out std_logic;
			rxRightOpen : out std_logic;
			rxUpOpen : out std_logic;
			rxDownOpen : out std_logic;
			txLeftReq : out std_logic;
			txRightReq : out std_logic;
			txUpReq : out std_logic;
			txDownReq : out std_logic;
			txLeftData : out signed (10 downto 0);
			txRightData : out signed (10 downto 0);
			txUpData : out signed (10 downto 0);
			txDownData : out signed (10 downto 0));
	end component;
	
	signal nodeClk : std_logic := '0';
	signal nodeAcc : signed (10 downto 0) := (others => '0');
	signal debugAddress : std_logic_vector (3 downto 0) := "0000";
	
	signal node1DataDown : signed (10 downto 0) := (others => '0');
	signal node1OpenDown : std_logic := '0';
	signal node1ReqDown : std_logic := '0';
begin
	
	Inst_ArrayCommPort: ArrayCommPort
		port map (clk => clk,
			rst => rst,
			dataIn => (others => '0'),
			dataOut => node1Out,
			rxData => node1DataDown,
			rxOpen => node1OpenDown,
			rxReq => node1ReqDown,
			txData => open,
			txOpen => '0',
			txReq => open);
	
--	Inst_NodeArrayController: NodeArrayController port map (
--		clk => '0',
--		rst => rst,
--		uartClk => uartClk,
--		uartTx => uartTx,
--		txStart => '1',
--		uartDone => uartDone,
--		nodeClk => nodeClk,
--		nodeAcc => nodeAcc);
	
	Inst_T21Node: T21Node
		port map (clk => clk,
			rst => rst,
			debugAddress => debugAddress,
			debugACC => nodeAcc,
			debugBAK => open,
			debugLAST => open,
			rxLeftOpen => open,
			rxRightOpen => open,
			rxUpOpen => open,
			rxDownOpen => open,
			rxLeftReq => '0',
			rxRightReq => '0',
			rxUpReq => '0',
			rxDownReq => '0',
			rxLeftData => (others => '0'),
			rxRightData => (others => '0'),
			rxUpData => (others => '0'),
			rxDownData => (others => '0'),
			txLeftOpen => '0',
			txRightOpen => '0',
			txUpOpen => '0',
			txDownOpen => node1OpenDown,
			txLeftReq => open,
			txRightReq => open,
			txUpReq => open,
			txDownReq => node1ReqDown,
			txLeftData => open,
			txRightData => open,
			txUpData => open,
			txDownData => node1DataDown);
	
end Behavioral;