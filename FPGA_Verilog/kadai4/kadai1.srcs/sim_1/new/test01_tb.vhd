library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test01_tb is 
end test01_tb;

architecture Behavioral of test01_tb is
component kadai1
Port ( SW : in STD_LOGIC_VECTOR (1 downto 0);
LD : out STD_LOGIC);
end component;
signal SW : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
signal LD : STD_LOGIC;
begin
-- Instantiate the Unit Under Test (UUT)
  uut: kadai1 port map (SW, LD);
-- Stimulus process
  stim_process: process
begin
-- hold reset state for 100 ns.
wait for 100 ns;
-- insert stimulus here
wait for 200 ns; SW(0) <='1';
wait for 200 ns; SW(1) <='1';
wait for 200 ns; SW(0) <='0';
wait for 200 ns; SW(1) <='0';
-- always end with wait
wait;
end process;
end Behavioral;