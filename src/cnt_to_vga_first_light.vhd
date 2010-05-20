library ieee;
use ieee.std_logic_1164.all;
use work.textmode_vga_pkg.all;

architecture first_light of cnt_to_vga is

constant VGA_READY : std_logic := '1';
constant NO_DATA   : std_logic_vector(3*COLOR_SIZE + CHAR_SIZE - 1 downto 0) := (others => '0');
constant INIT_CMDs : integer := 3;

-- for testing.
constant BLUELLOW : std_logic_vector := "00000000000000000000000001111111";
--										"xxxxxxxxrrrrrrrrggggggggbbbbbbbb";

signal cmd_next 	 : std_logic_vector(COMMAND_SIZE - 1 downto 0);
signal cmd_data_next : std_logic_vector(3*COLOR_SIZE + CHAR_SIZE - 1 downto 0);

signal cmd_sync		 : std_logic_vector(COMMAND_SIZE - 1 downto 0);
signal cmd_data_sync : std_logic_vector(3*COLOR_SIZE + CHAR_SIZE - 1 downto 0);

begin

	cmd <= cmd_sync;
	cmd_data <= cmd_data_sync;

	process(sys_clk,next_cmd_flag,cmd_sync,cmd_data_sync)
	begin
		if next_cmd_flag = VGA_READY then
			--cmd_sync      <= COMMAND_NOP;
			cmd_sync      <= COMMAND_SET_BACKGROUND;
			--cmd_data_sync <= NO_DATA;
			cmd_data_sync <= BLUELLOW;
		end if;
	end process;
	
	vga_res_n <= sys_res_n;

end architecture first_light;
