library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package simUtilitiesPkg is
	
	function intToVector(intIn : integer; size : natural) return std_logic_vector;
	
	procedure randInt(seed1, seed2 : inout positive; upper : in real; intOut : out integer);
	
	procedure randInt(seed1 , seed2 : inout positive; lower, upper : in real; intOut : out integer);
	
end simUtilitiesPkg;

package body simUtilitiesPkg is
	
	function intToVector(intIn : integer; size : natural) return std_logic_vector is
		variable tempOut : signed ((size - 1) downto 0);
	begin
		tempOut := to_signed(intIn, size);
		return std_logic_vector(tempOut);
	end intToVector;
	
	procedure randInt(seed1, seed2 : inout positive; upper : in real; intOut : out integer) is
		variable tempOut : real;
	begin
		uniform(seed1, seed2, tempOut);
		intOut := integer(tempOut * upper);
	end randInt;
	
	procedure randInt(seed1 , seed2 : inout positive; lower, upper : in real; intOut : out integer) is
		variable tempOut : real;
	begin
		uniform(seed1, seed2, tempOut);
		intOut := integer((tempOut * (upper - lower)) + lower);
	end randInt;
	
end simUtilitiesPkg;