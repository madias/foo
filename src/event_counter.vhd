library ieee;
use ieee.std_logic_1164.all;

entity event_counter is
  generic
  (
    CNT_WIDTH : integer range 4 to integer'high;
    RESET_VALUE : std_logic
  );
  port
  (
    sys_clk : in std_logic;
    sys_res_n : in std_logic;
    sense : in std_logic;
    cnt : out std_logic_vector(CNT_WIDTH - 1 downto 0)
  );
end entity event_counter;
