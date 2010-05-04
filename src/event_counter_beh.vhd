library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture beh of event_counter is
  signal sense_a_old, sense_a_old_next : std_logic;
  signal sense_b_old, sense_b_old_next : std_logic;
  signal cnt_int, cnt_next : std_logic_vector(CNT_WIDTH - 1 downto 0);
begin
  cnt <= cnt_int;

  process(sys_clk, sys_res_n)
  begin
    if sys_res_n = '0' then
      cnt_int <= (others => '0');
      sense_a_old <= RESET_VALUE;
      sense_b_old <= RESET_VALUE;
    elsif rising_edge(sys_clk) then
      cnt_int <= cnt_next;
      sense_a_old <= sense_a_old_next;
      sense_b_old <= sense_b_old_next;
    end if;
  end process;
  
  process(cnt_int, sense_a, sense_a_old, sense_b, sense_b_old)
  begin
    sense_a_old_next <= sense_a;
    sense_b_old_next <= sense_b;

    cnt_next <= cnt_int;

    if sense_a_old /= sense_a and sense_a = '0' then
      cnt_next <= std_logic_vector(unsigned(cnt_int) + 1);
    end if;

    if sense_b_old /= sense_b and sense_b = '0' then
	  -- if unsigned(cnt_int) = 0 then
      --	cnt_next <= std_logic_vector(unsigned(cnt_int) + 1);
	  -- else
	  --	cnt_next <= std_logic_vector(unsigned(cnt_int) - 1);
	  -- end if;
	  cnt_next <= std_logic_vector(unsigned(cnt_int) - 1);
    end if;

  end process;
end architecture beh;
