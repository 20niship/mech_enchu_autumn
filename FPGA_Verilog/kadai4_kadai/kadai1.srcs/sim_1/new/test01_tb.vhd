library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test01_tb is 
end test01_tb;

architecture Behavioral of test01_tb is
component kadai3
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           S : out STD_LOGIC_VECTOR (4 downto 0));
end component;
-- signal SW : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
-- signal LD : STD_LOGIC;

signal A : STD_LOGIC_VECTOR (3 downto 0):= (others => '0');
signal B :  STD_LOGIC_VECTOR (3 downto 0):= (others => '0');
signal S : STD_LOGIC_VECTOR (4 downto 0);
begin
-- Instantiate the Unit Under Test (UUT)
  uut: kadai3 port map (A, B, S);
-- Stimulus process
  stim_process: process
begin
-- hold reset state for 100 ns.
wait for 100 ns;
    A <= "1000";
    B <= "0011";
-- insert stimulus here
wait for 200 ns;
    A <= "0001";
    B <= "0010";
wait for 200 ns;
    A <= "1000";
    B <= "0001";
wait for 200 ns;
    A <= "0101";
    B <= "0010";
wait for 200 ns;
    A <= "1110";
    B <= "0010";
wait for 200 ns;

-- always end with wait
wait;
end process;
end Behavioral;