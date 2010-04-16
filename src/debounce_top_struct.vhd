library ieee;
use ieee.std_logic_1164.all;
use work.debounce_pkg.all;
use work.sync_pkg.all;
use work.event_counter_pkg.all;

architecture struct of debounce_top is
  constant CLK_FREQ : integer := 33330000;
  constant TIMEOUT : time := 1 ms;
  constant RES_N_DEFAULT_VALUE : std_logic := '1';
  constant SYNC_STAGES : integer := 2;
  constant BTN_A_RESET_VALUE : std_logic := '1';
  constant EVENT_CNT_WIDTH : integer := 8;

  signal sys_res_n_sync, btn_a_sync : std_logic;
  signal event_cnt : std_logic_vector(EVENT_CNT_WIDTH - 1 downto 0);

  function to_segs(value : in std_logic_vector(3 downto 0)) return std_logic_vector is
  begin
    case value is
      when x"0" => return "1000000";
      when x"1" => return "1111001";
      when x"2" => return "0100100";
      when x"3" => return "0110000";
      when x"4" => return "0011001";
      when x"5" => return "0010010";
      when x"6" => return "0000010";
      when x"7" => return "1111000";
      when x"8" => return "0000000";
      when x"9" => return "0010000";
      when x"A" => return "0001000";
      when x"B" => return "0000011";
      when x"C" => return "1000110";
      when x"D" => return "0100001";
      when x"E" => return "0000110";
      when x"F" => return "0001110";
      when others => return "1111111";
    end case;
  end function;  
begin
  sys_res_n_debounce_inst : debounce
    generic map
    (
      CLK_FREQ => CLK_FREQ,
      TIMEOUT => TIMEOUT,
      RESET_VALUE => RES_N_DEFAULT_VALUE,
      SYNC_STAGES => SYNC_STAGES
    )
    port map
    (
      sys_clk => sys_clk,
      sys_res_n => '1',
      data_in => sys_res_n,
      data_out => sys_res_n_sync
    );

    btn_a_debounce_inst : debounce
    generic map
    (
      CLK_FREQ => CLK_FREQ,
      TIMEOUT => TIMEOUT,
      RESET_VALUE => BTN_A_RESET_VALUE,
      SYNC_STAGES => SYNC_STAGES
    )
    port map
    (
      sys_clk => sys_clk,
      sys_res_n => sys_res_n_sync,
      data_in => btn_a,
      data_out => btn_a_sync
    );

  event_cnt_inst : event_counter
    generic map
    (
      CNT_WIDTH => EVENT_CNT_WIDTH,
      RESET_VALUE => BTN_A_RESET_VALUE
    )
    port map
    (
      sys_clk => sys_clk,
      sys_res_n => sys_res_n_sync,
      sense => btn_a_sync,
      cnt => event_cnt
    );

  seg_a <= to_segs(event_cnt(3 downto 0));
  seg_b <= to_segs(event_cnt(7 downto 4));

end architecture struct;
