library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture beh of event_counter is
  signal sense_old, sense_old_next : std_logic;
  signal cnt_int, cnt_next : std_logic_vector(CNT_WIDTH - 1 downto 0);
begin
  cnt <= cnt_int;

  process(sys_clk, sys_res_n)
  begin
    if sys_res_n = '0' then
      cnt_int <= (others => '0');
      sense_old <= RESET_VALUE;
    elsif rising_edge(sys_clk) then
      cnt_int <= cnt_next;
      sense_old <= sense_old_next;
    end if;
  end process;
  
  process(cnt_int, sense, sense_old)
  begin
    sense_old_next <= sense;
    cnt_next <= cnt_int;

    if sense_old /= sense and sense = '0' then
      cnt_next <= std_logic_vector(unsigned(cnt_int) + 1);
    end if;
  end process;
end architecture beh;
