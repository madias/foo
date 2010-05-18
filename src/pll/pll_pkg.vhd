library ieee;
use ieee.std_logic_1164.all;

library altera_mf;
use altera_mf.all;

package pll_pkg is
	component pll_vga is
	port
	(
		inclk0	: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC 
	);
	end component pll_vga;
end package pll_pkg;

