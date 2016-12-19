----------------------------------------------------------------------------------
-- Engineer: MattM
-- Website: AtmosphericTechnology.com
-- Email/Contact: atmospherictechnology@gmail.com
--
-- Create Date:	14:00:01 12/15/2016 
-- Project Name: TIS-100_CPU
-- Module Name:	TIS100TopLevel - Behavioral 
-- Tool versions: ISE 14.7
--
-- Description:
--	The toplevel module for the TIS-100 CPU Array.
--
-- Revision:
-- Revision 0.9 - Prerelease version.
-- Additional Comments: 
-- 	List of things todo in submodules.
-- 	Assign the pins using the relevent method provided by your synthesis tools.
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library unisim;
--use unisim.vcomponents.all;

entity TIS100TopLevel is
	port (clk : in std_logic;
		rst : in std_logic;
		clkStepButton : in std_logic;
		node1Out : out signed (10 downto 0));
end TIS100TopLevel;

architecture Behavioral of TIS100TopLevel is
	component NodeArray is
		port (clk : in std_logic;
			rst : in std_logic;
			node1Out : out signed (10 downto 0));
	end component;
	
	signal clkEnable : std_logic := '0';
begin
	
	clkEnableProc: process(clk) is
		variable prevButtonVal : std_logic := '0';
	begin
		if rising_edge(clk) then
			clkEnable <= '0';
			if ((clkStepButton = '1') and (prevButtonVal = '0')) then
				clkEnable <= '1';
			end if;
			prevButtonVal := clkStepButton;
		end if;
	end process;
	
	Inst_NodeArray: NodeArray
		port map (clk => clkEnable,
			rst => rst,
			node1Out => node1Out);
	
end Behavioral;