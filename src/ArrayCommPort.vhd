----------------------------------------------------------------------------------
-- Engineer: MattM
-- Website: AtmosphericTechnology.com
-- Email/Contact: atmospherictechnology@gmail.com
-- 
-- Create Date:	14:03:37 12/15/2016 
-- Project Name: TIS-100_CPU
-- Module Name:	ArrayCommPort - Behavioral 
-- Tool versions: ISE 14.7
-- Description:
-- 	A (VERY) basic interface between the internal array and external ports (i.e. device pins).
-- 
-- Revision: 
-- Revision 0.9 - Prerelease version
--
-- Additional Comments: 
-- 	This is currently only partially done and will be replaced with a serial implementation
-- 	(Possibly SPI or I2C)
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library unisim;
--use unisim.vcomponents.all;

-- TODO: implement tx and interface

entity ArrayCommPort is
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
end ArrayCommPort;

architecture Behavioral of ArrayCommPort is
	
begin
	
	rxOpen <= '1';
	
	dataOutProc: process(clk) is
	begin
		if rising_edge(clk) then
			if (rxReq = '1') then
				dataOut <= rxData;
			end if;
		end if;
	end process;
	
end Behavioral;