----------------------------------------------------------------------------------
-- Engineer: MattM
-- Website: AtmosphericTechnology.com
-- Email/Contact: atmospherictechnology@gmail.com
-- 
-- Create Date:    15:48:29 11/30/2016 
-- Project Name: TIS-100_CPU
-- Module Name:    T21Node - Behavioral 
-- Tool versions: ISE 14.7
--
-- Description: 
-- 	The top level of the T-21 Basic Execution Node.
-- 	It provides all the interfaces and internal submodules for its implemention.
--
-- Revision: 
-- Revision 0.9 - Prerelease version
-- Additional Comments: 
-- 	To change the program to be executed, edit "prgRom" with the compiled source.
-- 	Refer to the "Language Reference Manual" details.
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library unisim;
--use unisim.vcomponents.all;

entity T21Node is
	port (clk : in std_logic;
		rst : in std_logic;
		
--		spiClk : in std_logic;
--		spiSS : in std_logic;
--		spiMosi : in std_logic;
--		spiMiso : out std_logic;
		
		debugAddress : out std_logic_vector (3 downto 0);
		debugACC : out signed (10 downto 0);
		debugBAK : out signed (10 downto 0);
		debugLast : out std_logic_vector (2 downto 0);
		
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
end T21Node;

architecture Behavioral of T21Node is
	component NodeCore is
		port (clk : in std_logic;
			rst : in std_logic;
			address : out std_logic_vector (3 downto 0);
			instrIn : in std_logic_vector (15 downto 0);
			debugACC : out signed (10 downto 0);
			debugBAK : out signed (10 downto 0);
			debugLAST : out std_logic_vector (2 downto 0);
			
			commStart : out std_logic;
			commPause : in std_logic;
			commType : out std_logic_vector (1 downto 0);
			rxPort : out std_logic_vector (2 downto 0);
			txPort : out std_logic_vector (2 downto 0);
			rxData : in signed (10 downto 0);
			txData : out signed (10 downto 0));
	end component;
	
	component PortManager is
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
	
--	component spi_slave is
--		generic (N : positive;
--			CPOL : std_logic;
--			CPHA : std_logic;
--			PREFETCH : positive);
--		port (clk_i : in std_logic;
--			spi_ssel_i : in std_logic;
--			spi_sck_i : in std_logic;
--			spi_mosi_i : in std_logic;
--			spi_miso_o : out std_logic;
--			di_req_o : out std_logic;
--			di_i : in std_logic_vector (7 downto 0);
--			wren_i : in std_logic;
--			wr_ack_o : out std_logic;
--			do_valid_o : out std_logic;
--			do_o : out std_logic_vector (7 downto 0));
--	end component;

	type prgRomType is array (0 to 14) of std_logic_vector (15 downto 0);
	
	signal prgRom : prgRomType := (x"0000",
								x"0000",
								x"0000",
								x"0000",
								x"0000",
								x"0000",
								x"0000",
								x"0000",
								x"0000",
								x"0000",
								x"0000",
								x"0000",
								x"0000",
								x"0000",
								x"0000");
	
	signal address : std_logic_vector (3 downto 0) := "0000";
	signal instruction : std_logic_vector (15 downto 0) := (others => '0');
	signal commStart : std_logic := '0';
	signal commPause : std_logic := '0';
	signal commType : std_logic_vector (1 downto 0) := "00";
	signal rxPort : std_logic_vector (2 downto 0) := "000";
	signal txPort : std_logic_vector (2 downto 0) := "000";
	signal rxData : signed (10 downto 0) := (others => '0');
	signal txData : signed (10 downto 0) := (others => '0');
	
	signal spiDataIn : std_logic_vector (7 downto 0) := (others => '0');
	signal spiDataOut : std_logic_vector (7 downto 0) := (others => '0');
	signal spiLoadReq : std_logic := '0';
	signal spiWriteEnable : std_logic := '0';
	signal spiDataReady : std_logic := '0';
begin

	debugAddress <= address;
	
	instruction <= prgRom(to_integer(unsigned(address)));
	
	Inst_NodeCore: NodeCore
		port map (clk => clk,
			rst => rst,
			address => address,
			debugACC => debugACC,
			debugBAK => debugBAK,
			debugLAST => debugLAST,
			instrIn => instruction,
			commStart => commStart,
			commPause => commPause,
			commType => commType,
			rxPort => rxPort,
			txPort => txPort,
			rxData => rxData,
			txData => txData);

	Inst_PortManager: PortManager
		port map (clk => clk,
			rst => rst,
			commStart => commStart,
			commPause => commPause,
			commType => commType,
			rxPort => rxPort,
			txPort => txPort,
			dataIn => txData,
			dataOut => rxData,
			--last => last,
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
		
--	Inst_SpiSlave: spi_slave
--		generic map (N => 8,
--			CPOL => '0',
--			CPHA => '0',
--			PREFETCH => 3)
--		port map (clk_i => clk,
--			spi_ssel_i => spiSS,
--			spi_sck_i => spiClk,
--			spi_mosi_i => spiMosi,
--			spi_miso_o => spiMiso,
--			di_req_o => spiLoadReq,
--			di_i => spiDataIn,
--			wren_i => spiWriteEnable,
--			wr_ack_o => open,
--			do_valid_o => spiDataReady,
--			do_o => spiDataOut);
			
--	Inst_SpiCommandParser: SpiCommandParser
--		port map (test => test);

end Behavioral;