library ieee;
use ieee.std_logic_1164.all;
use work.textmode_vga_pkg.all;

package cnt_to_vga_pkg is
	component cnt_to_vga is
		generic
  		(
    		RESET_VALUE		: std_logic
  		);
  		port
  		(
			sys_clk			: in std_logic;
			sys_res_n 		: in std_logic;
			next_cmd_flag	: in std_logic;
			cmd				: out std_logic_vector(COMMAND_SIZE - 1 downto 0);
			cmd_data 		: out std_logic_vector(3*COLOR_SIZE + CHAR_SIZE - 1 downto 0);
    		vga_res_n		: out std_logic
  		);
	end component cnt_to_vga;
end package cnt_to_vga_pkg;
