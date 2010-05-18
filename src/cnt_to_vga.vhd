library ieee;
use ieee.std_logic_1164.all;

entity cnt_to_vga is
  generic
  (
    RESET_VALUE		: std_logic;
	COMMAND_SIZE	: integer;
	COLOR_SIZE		: integer;
	CHAR_SIZE		: integer
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
