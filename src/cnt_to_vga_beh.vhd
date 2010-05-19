library ieee;
use ieee.std_logic_1164.all;
use work.textmode_vga_pkg.all;

architecture beh of cnt_to_vga is

constant VGA_READY : std_logic := '1';
constant NO_DATA   : std_logic_vector(3*COLOR_SIZE + CHAR_SIZE - 1 downto 0) := (others => '0');
constant INIT_CMDs : integer := 3;

signal cmd_next 	 : std_logic_vector(COMMAND_SIZE - 1 downto 0);
signal cmd_data_next : std_logic_vector(3*COLOR_SIZE + CHAR_SIZE - 1 downto 0);

signal cmd_cnt		 : integer :=0;
Signal cmd_cnt_next	 : integer :=0;

signal cmd_sync		 : std_logic_vector(COMMAND_SIZE - 1 downto 0);
signal cmd_data_sync : std_logic_vector(3*COLOR_SIZE + CHAR_SIZE - 1 downto 0);

begin

	cmd <= cmd_sync;
	cmd_data <= cmd_data_sync;

	process(next_cmd_flag,cmd_sync,cmd_data_sync,cmd_cnt,cmd_cnt_next,cmd_next,cmd_data_next)
	begin

		if next_cmd_flag = VGA_READY then
	  		cmd_sync <= cmd_next;
	 		cmd_data_sync <= cmd_data_next;
		end if;

		if cmd_cnt < INIT_CMDs then
		   cmd_cnt <= cmd_cnt_next;
		else
		   cmd_cnt <= 0;
		end if;

	end process;

	process(cmd_cnt,cmd_cnt_next,cmd_next,cmd_data_next)
	begin
		if cmd_cnt < INIT_CMDs then
			if cmd_cnt = 0 then
				cmd_next <= COMMAND_NOP;
				cmd_data_next <= NO_DATA;
			elsif cmd_cnt = 1 then
				cmd_next <= COMMAND_NOP;
				cmd_data_next <= NO_DATA;
			elsif cmd_cnt = 2 then
				cmd_next <= COMMAND_NOP;
				cmd_data_next <= NO_DATA;
			elsif cmd_cnt = 3 then
				cmd_next <= COMMAND_NOP;
				cmd_data_next <= NO_DATA;
			end if;
			cmd_cnt_next <= cmd_cnt + 1;
		elsif cmd_cnt >= INIT_CMDs then
			cmd_cnt_next <= 0;
		end if;
	end process;

	vga_res_n <= sys_res_n;

end architecture beh;
