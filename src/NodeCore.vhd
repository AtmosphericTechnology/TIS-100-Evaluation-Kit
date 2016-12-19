----------------------------------------------------------------------------------
-- Engineer: MattM
-- Website: AtmosphericTechnology.com
-- Email/Contact: atmospherictechnology@gmail.com
-- 
-- Create Date:	 16:44:04 10/13/2016 
-- Project Name: TIS-100_CPU
-- Module Name:	 NodeCore - Behavioral 
-- Tool versions: ISE 14.7
--
-- Description: 
-- 	The internal logic of the T-21 Basic Execution Node.
-- 	This is where all the main logic for the node is stored.
--
-- Revision: 
-- Revision 0.9 - Prerelease version
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library unisim;
--use unisim.vcomponents.all;

-- TODO: Add a clock enable (disable registers when need be)

-- Array format: [MSB, ..., LSB]

-- TODO: Clamp the values to (-999 - 999) and prevent overflows wrapping around

-- TODO: Convert to sync resets

-- TODO: Add any and last support

-- TODO: Fix comm port timing (rx is on 1st cycle, tx is on 2nd cycle)

-- TODO: Add support for moving from comm port to comm port.

entity NodeCore is
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
end NodeCore;

architecture Behavioral of NodeCore is
	signal dataPipeIn : signed (10 downto 0) := (others => '0');
	signal dataPipeOut : signed (10 downto 0) := (others => '0');
	
	signal jmpStatusBits : std_logic_vector (1 downto 0) := "00"; -- [Equal to 0, Greater than 0]
	signal jmpEnable : std_logic := '0';
	
	signal pc : unsigned (3 downto 0) := (others => '0');
	signal acc : signed (10 downto 0) := (others => '0');
	signal bak : signed (10 downto 0) := (others => '0');
	signal last : std_logic_vector (2 downto 0);
	
	-- Instruction Fields (Aliases)
	alias opcode : std_logic_vector (3 downto 0) is instrIn(15 downto 12);
	alias src : std_logic_vector (2 downto 0) is instrIn(11 downto 9);
	alias dest : std_logic_vector (2 downto 0) is instrIn(8 downto 6);
	alias jmpFlags : std_logic_vector (2 downto 0) is instrIn(11 downto 9); -- [Equal to, Greater than, Less than]
	alias jroType : std_logic is instrIn(8); -- 0: Int, 1: Register
	alias jroSrc : std_logic_vector (2 downto 0) is instrIn(11 downto 9);
	alias jroOffset : std_logic_vector (4 downto 0) is instrIn(4 downto 0);
	alias jmpDest : std_logic_vector (3 downto 0) is instrIn(3 downto 0);
	alias constDest : std_logic_vector (2 downto 0) is instrIn(13 downto 11);
	alias const : std_logic_vector (10 downto 0) is instrIn(10 downto 0);
	
begin

	debugACC <= acc;
	debugBAK <= bak;
	debugLAST <= last;

	address <= std_logic_vector(pc);
	
	portManagerProc: process(src, dest, dataPipeOut) is
	begin
		rxPort <= src;
		txPort <= dest;
		txData <= dataPipeOut;
	end process;
	
	-- TODO: Add in support for special comm ports
	commTypeProc: process(opcode, src, dest, jroType, constDest) is
	begin
		commType <= "00";
		if opcode(3) = '0' then
			case opcode(2 downto 0) is
				when "000" => -- ADD
					if (src /= "000") and (src /= "001") then -- src is a comm port
						commType <= "00"; -- Not really needed, already init'd to this
					end if;
				when "001" => -- MOV
					if (src /= "000") and (src /= "001") then
						if (dest /= "000") and (dest /= "001") then
							commType <= "10"; -- rx tx
						else
							commType <= "00"; -- rx
						end if;
					else
						if (dest /= "000") and (dest /= "001") then
							commType <= "01"; -- tx
						end if;
					end if;
				when "010" => -- SUB
					if (src /= "000") and (src /= "001") then -- src is a comm port
						commType <= "00"; -- Not really needed, already init'd to this
					end if;
				when "111" => -- JRO
					if jroType = '1' then
						if (jroSrc /= "000") and (jroSrc /= "001") then -- src is a comm port
							commType <= "00"; -- Not really needed, already init'd to this
						end if;
					end if;
				when others =>
					null;
			end case;
		else
			case opcode(2) is
				when '0' => -- ADD (Large Int)
					if (constDest /= "000") and (constDest /= "001") then
						commType <= "01";
					end if;
				when '1' => -- MOV (Large Int)
					if (constDest /= "000") and (constDest /= "001") then
						commType <= "01";
					end if;
				when others =>
					null;
			end case;
		end if;
	end process;
	
	dataPipeInProc: process(opcode, jroType, jroOffset, src, acc, rxData, const) is
	begin
		if opcode(3) = '0' then -- Normal operations
			if opcode = "0111" and jroType = '0' then -- JRO with Constant as Offset
				dataPipeIn <= resize(signed(jroOffset), dataPipeIn'length);
			else -- Any other op or JRO with Register value as Offset
				case src is -- bak as a source is implicit to the opcode. no need to have its own value
					when "000" => -- nil
						dataPipeIn <= (others => '0');
					when "001" => -- acc
						dataPipeIn <= acc;
					when "010" => -- left
						dataPipeIn <= rxData;
					when "011" => -- right
						dataPipeIn <= rxData;
					when "100" => -- up
						dataPipeIn <= rxData;
					when "101" => -- down
						dataPipeIn <= rxData;
					when "110" => -- any
						dataPipeIn <= rxData;
					when "111" => -- last
						dataPipeIn <= rxData;
					when others =>
						dataPipeIn <= (others => '0'); -- maybe make left right etc be others
				end case;
			end if;
		else -- Large int operations
			dataPipeIn <= signed(const);
		end if;
	end process;
	
	dataPipeProc: process(opcode, acc, dataPipeIn, jmpDest, pc) is
	begin
		if opcode(3) = '0' then -- Normal operations
			case opcode(2 downto 0) is
				when "000" => -- add
					dataPipeOut <= acc + dataPipeIn;
				when "001" => -- mov
					dataPipeOut <= dataPipeIn;
				when "010" => -- neg
					dataPipeOut <= -acc;
				when "011" => -- sub
					dataPipeOut <= acc - dataPipeIn;
				when "100" => -- sav
					dataPipeOut <= dataPipeIn;
				when "101" => -- swp
					dataPipeOut <= dataPipeIn;
				when "110" => -- jmp
					dataPipeOut <= signed(resize(unsigned(jmpDest), dataPipeOut'length)); -- TODO: Make sure the sign is correct and no sign extension fails are created
				when "111" => -- jro
					dataPipeOut <= signed(pc) + dataPipeIn;
				when others =>
					dataPipeOut <= dataPipeIn; -- may as well just pipe it straight through
			end case;
		else -- Large int operations
			case opcode(2) is
				when '0' => -- add (large integer)
					dataPipeOut <= acc + dataPipeIn;
				when '1' => -- mov (large integer)
					dataPipeOut <= dataPipeIn;
				when others =>
					dataPipeOut <= dataPipeIn;
			end case;
		end if;
	end process;
	
	jmpStatusBitsProc: process(acc) is
	begin
		if acc = "0000000000" then
			jmpStatusBits(1) <= '1';
		else
			jmpStatusBits(1) <= '0';
		end if;
		
		if acc > "00000000000" then
			jmpStatusBits(0) <= '1';
		else
			jmpStatusBits(0) <= '0';
		end if;
	end process;
	
	jmpEnableProc: process(opcode, jmpStatusBits, jmpFlags) is
	begin
		jmpEnable <= '0';
		
		if opcode = "0111" then
			jmpEnable <= '1';
		elsif opcode = "0110" then
			if jmpStatusBits(1) = '1' then -- Equal to 0
				if jmpFlags(2) = '1' then
					jmpEnable <= '1';
				end if;
			elsif jmpStatusBits(0) = '1' then -- Greater than 0
				if jmpFlags(1) = '1' then
					jmpEnable <= '1';
				end if;
			else -- Less than 0
				if jmpFlags(0) = '1' then
					jmpEnable <= '1';
				end if;
			end if;
		end if;
	end process;

	startEnableProc: process(commPause, opcode, src, dest, jroSrc, jroType, constDest) is
	begin
		commStart <= '0';
		if opcode(3) = '0' then
			case opcode(2 downto 0) is
				when "000" => -- ADD
					if (src = "010") or (src = "011") or (src = "100") or (src = "101") or (src = "110") or (src = "111") then
						commStart <= '1';
					end if;
				when "001" => -- MOV
					if (src = "010") or (src = "011") or (src = "100") or (src = "101") or (src = "110") or (src = "111") then
						commStart <= '1';
					end if;
					
					if (dest = "010") or (dest = "011") or (dest = "100") or (dest = "101") or (dest = "110") or (dest = "111") then
						commStart <= '1';
					end if;
				when "011" => -- SUB
					if (src = "010") or (src = "011") or (src = "100") or (src = "101") or (src = "110") or (src = "111") then
						commStart <= '1';
					end if;
				when "111" => -- JRO
					if (jroType = '1') then
						if (jroSrc = "010") or (jroSrc = "011") or (jroSrc = "100") or (jroSrc = "101") or (jroSrc = "110") or (jroSrc = "111") then
							commStart <= '1';
						end if;
					end if;
				when others =>
					null; -- Start is already init'd to 0
			end case;
		else
			if opcode(2) = '1' then
				if (constDest = "010") or (constDest = "011") or (constDest = "100") or (constDest = "101") or (constDest = "110") or (constDest = "111") then
					commStart <= '1';
				end if;
			end if;
		end if;
	end process;

	clkProc: process(clk, rst, commPause, opcode, dataPipeOut, dest, acc, bak, jmpEnable) is
		variable tempPC : signed (4 downto 0);
	begin
		if rising_edge(clk) then
			if rst = '1' then
				pc <= (others => '0');
				acc <= (others => '0');
				bak <= (others => '0');
				--start <= '0';
			elsif commPause = '0' then
				if pc = "1110" then -- when it reaches instruction 15 (doesn't exist), loop back to 0
					pc <= "0000";
				else
					pc <= pc + 1;
				end if;
				
				if opcode(3) = '0' then -- Normal operations
					case opcode(2 downto 0) is -- most of the cases are probably unneeded. May be possible to change later.
						when "000" => -- add
							acc <= dataPipeOut;
						when "001" => -- mov
							-- if dest is acc, mov into acc
							if dest = "001" then
								acc <= dataPipeOut;
							end if;
						when "010" => -- neg
							acc <= dataPipeOut;
						when "011" => -- sub
							acc <= dataPipeOut;
						when "100" => -- sav
							bak <= acc;
						when "101" => -- swp
							bak <= acc;
							acc <= bak;
						when "110" => -- jmp
							if jmpEnable = '1' then
								-- TODO: Make sure all the signed and unsigned addition and conversion all works right, might be some sign errors etc.
								pc <= unsigned(resize(dataPipeOut, pc'length)); -- If successful, pc is dataPipeOut
							else
								null;
							end if;
						when "111" => -- jro
							pc <= unsigned(resize(dataPipeOut, pc'length));
						when others =>
							null;
					end case;
				else -- Large int operations
					case opcode(2) is -- Probably don't need this case.
						when '0' => -- add (large integer)
							acc <= dataPipeOut;
						when '1' => -- mov (large integer)
							acc <= dataPipeOut; -- not quite right. depends on the dest
						when others =>
							null;
					end case;
				end if;
				
			--elsif blocking = '1' then
			--	start <= '0';
			end if;
		end if;
	end process;
end Behavioral;

