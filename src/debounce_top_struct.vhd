library ieee;
use ieee.std_logic_1164.all;
use work.debounce_pkg.all;
use work.sync_pkg.all;
use work.event_counter_pkg.all;
use work.textmode_vga_component_pkg.all;
use work.textmode_vga_pkg.all;
use work.textmode_vga_platform_dependent_pkg.all;
use work.pll_pkg.all;
use work.cnt_to_vga_pkg.all;


architecture struct of debounce_top is
  constant VGA_CLK_FREQ : integer := 25175000;
  constant BLINK_INTERVAL_MS : integer := 500;
  constant CLK_FREQ : integer := 33330000;
  constant TIMEOUT : time := 1 ms;
  constant RES_N_DEFAULT_VALUE : std_logic := '1';
  constant SYNC_STAGES : integer := 2;
  constant BTN_A_RESET_VALUE : std_logic := '1';
  constant VGA_RESET_VALUE : std_logic := '0';
  constant EVENT_CNT_WIDTH : integer := 8;

  signal sys_res_n_sync, btn_a_sync, btn_b_sync : std_logic;--added by me.
  signal event_cnt : std_logic_vector(EVENT_CNT_WIDTH - 1 downto 0);

  -- for the vga ip core.
  signal command_sync : std_logic_vector(COMMAND_SIZE - 1 downto 0);
  signal command_data_sync : std_logic_vector(3*COLOR_SIZE + CHAR_SIZE - 1 downto 0);
  signal free_sync : std_logic;
  signal vga_clk_sync : std_logic;
  signal vga_res_n_sync : std_logic;	-- see TODO ip vga core.
  signal vga_vsync_n_sync : std_logic;
  signal vga_hsync_n_sync : std_logic;
  signal vga_r0_sync : std_logic;
  signal vga_r1_sync : std_logic;
  signal vga_r2_sync : std_logic;
  signal vga_g0_sync : std_logic;
  signal vga_g1_sync : std_logic;
  signal vga_g2_sync : std_logic;
  signal vga_b0_sync : std_logic;
  signal vga_b1_sync : std_logic;

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

--  button b by me
    btn_b_debounce_inst : debounce
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
      data_in => btn_b,
      data_out => btn_b_sync
    );
--  button b by me ende.

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
      sense_a => btn_a_sync,
      sense_b => btn_b_sync,
      cnt => event_cnt
    );

    seg_a <= to_segs(event_cnt(3 downto 0));
    seg_b <= to_segs(event_cnt(7 downto 4));

--  wires from the vga plug to the vga core.
	vga_r1 <= vga_r1_sync;
	vga_r0 <= vga_r0_sync;
	vga_r2 <= vga_r2_sync;
	vga_g0 <= vga_g0_sync;
	vga_g1 <= vga_g1_sync;
	vga_g2 <= vga_g2_sync;
	vga_b0 <= vga_b0_sync;
	vga_b1 <= vga_b1_sync;
	vga_vsync_n <= vga_vsync_n_sync;
	vga_hsync_n <= vga_hsync_n_sync;

-- clock for vga core.
	pll_inst : pll_vga
	port map
	(
	  inclk0=>sys_clk,
	  c0=>vga_clk_sync
	);

-- here comes my output for the vga machine.
	screen_inst : cnt_to_vga
	generic map
	(
    	RESET_VALUE		=> VGA_RESET_VALUE
	)
	port map
	(
		sys_clk			=> sys_clk,
		sys_res_n		=> sys_res_n_sync,
		next_cmd_flag	=> free_sync,
    	cmd				=> command_sync,
		cmd_data		=> command_data_sync,
	  	vga_res_n 		=> vga_res_n_sync
	);

--  here comes the vga ip core.
    vga_inst : textmode_vga
	generic map
	(
	  VGA_CLK_FREQ => VGA_CLK_FREQ,
	  BLINK_INTERVAL_MS => BLINK_INTERVAL_MS,
	  SYNC_STAGES => SYNC_STAGES
	)
	port map
	(
	  -- internal user interface.
      sys_clk => sys_clk,
      sys_res_n => sys_res_n_sync,
	  command => command_sync,
	  command_data => command_data_sync,
	  free => free_sync,
	  -- external vga interface.
	  vga_clk => vga_clk_sync,

-- TODO.
	  vga_res_n => vga_res_n_sync, -- see cnt_to_vga. 
--	  (schleift sys_res_n durch)
--    i'm not sure if this is the right reset for the vga module.???

	  vsync_n => vga_vsync_n_sync,
	  hsync_n => vga_hsync_n_sync,
	  r(0) => vga_r0_sync,
	  r(1) => vga_r1_sync,
	  r(2) => vga_r2_sync,
	  g(0) => vga_g0_sync,
	  g(1) => vga_g1_sync,
	  g(2) => vga_g2_sync,
	  b(0) => vga_b0_sync,
	  b(1) => vga_b1_sync
	);
-- end of vga ip core.

end architecture struct;
