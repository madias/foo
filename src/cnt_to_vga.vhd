library ieee;
use ieee.std_logic_1164.all;
use work.textmode_vga_pkg.all;

entity cnt_to_vga is
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
end entity cnt_to_vga;

configuration counter_value_to_vga_display of cnt_to_vga is
	for four_commands
	--for first_light
	end for;
end counter_value_to_vga_display;
