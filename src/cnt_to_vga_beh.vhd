library ieee;
use ieee.std_logic_1164.all;
use work.textmode_vga_pkg.all;	-- weiss nicht ob das good is either.

architecture beh of cnt_to_vga is
constant VGA_READY : std_logic := '1';
-- constant COMMAND_NOP : std_logic_vector(COMMAND_SIZE - 1 downto 0) := x"00"; --schwerer pfusch!!!
constant NO_DATA : std_logic_vector(3*COLOR_SIZE + CHAR_SIZE - 1 downto 0) := (others => '0');

begin
 
	process(sys_clk, next_cmd_flag)
	begin
		if next_cmd_flag = VGA_READY then
	  		cmd <= COMMAND_NOP;
	 		cmd_data <= NO_DATA;
		end if;
	end process;

	vga_res_n <= sys_res_n;

end architecture beh;
