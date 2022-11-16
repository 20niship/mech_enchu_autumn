library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity kadai7 is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           CLK : in STD_LOGIC;
           SEG_DATA : out STD_LOGIC_VECTOR (7 downto 0);
           SEG_SEL : out STD_LOGIC_VECTOR (3 downto 0));
end kadai7;

architecture Behavioral of kadai7 is

component kadai5
    Port ( SW : in STD_LOGIC_VECTOR (3 downto 0);
           SEG_SEL : out STD_LOGIC_VECTOR (3 downto 0);
           SEL_DATA : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal S : STD_LOGIC_VECTOR (4 downto 0);
signal SUM_H : STD_LOGIC_VECTOR (4 downto 0);
signal SUM_L : STD_LOGIC_VECTOR (4 downto 0);
signal SEG_H : STD_LOGIC_VECTOR (7 downto 0);
signal SEG_L : STD_LOGIC_VECTOR (7 downto 0);
signal NOUSE : STD_LOGIC_VECTOR (3 downto 0);
signal COUNT : UNSIGNED (25 downto 0):= (others => '0');

begin

S <= std_logic_vector(unsigned('0' & A) + unsigned('0' & B));
SUM_H <= std_logic_vector(unsigned(S) / 10);
SUM_L <= std_logic_vector(unsigned(S) mod 10);
U1: kadai5 port map (SUM_H(3 downto 0), NOUSE, SEG_H);
U2: kadai5 port map (SUM_L(3 downto 0), NOUSE, SEG_L);

process (CLK)
begin
if rising_edge(CLK) then
COUNT <= COUNT+ 1; 
end if;

if(COUNT < 10000) then
SEG_SEL<= "1101";
SEG_DATA <= SEG_H;
elsif(COUNT < 20000) then
SEG_SEL <= "1110";
SEG_DATA <= SEG_L;
else
COUNT <= (others => '0');
end if;

end process;

end Behavioral;
