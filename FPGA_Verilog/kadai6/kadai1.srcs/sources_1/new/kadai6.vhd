library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity kadai6 is
    Port (
    CLK: in STD_LOGIC;
    LD0 : out STD_LOGIC);
end kadai6;

architecture Behavioral of kadai6 is
signal COUNT : UNSIGNED (25 downto 0):= (others => '0');
begin

process (CLK)
begin
if rising_edge(CLK) then -- ämé¿
COUNT <= COUNT+ 1; 
end if;

if(COUNT < 10000000) then
LD0 <= '1';
elsif(COUNT < 20000000) then
LD0 <= '0';
else
COUNT <= (others => '0');
end if;

end process;

end Behavioral;
