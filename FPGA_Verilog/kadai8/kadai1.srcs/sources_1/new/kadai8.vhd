----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/10/25 16:04:18
-- Design Name: 
-- Module Name: kadai8 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity kadai8 is
    Port ( CIN : in STD_LOGIC;
           A : in STD_LOGIC;
           B : in STD_LOGIC;
           CLK : in STD_LOGIC;
           S : out STD_LOGIC;
           COUT : out STD_LOGIC;
           SHZ : out STD_LOGIC;
           CHZ : out STD_LOGIC);
end kadai8;

architecture Behavioral of kadai8 is

component kadai2 is
    Port ( 
    SW : in STD_LOGIC_VECTOR (2 downto 0);
     LD : out STD_LOGIC_VECTOR (1 downto 0)
     );
end component;

component dff is
Port (CLK, D : in STD_LOGIC; Q : out STD_LOGIC);
end component;

signal FA_IN : STD_LOGIC_VECTOR (2 downto 0);
signal FA_OUT : STD_LOGIC_VECTOR (1 downto 0);
signal CLKHZ : STD_LOGIC;
signal COUNT : UNSIGNED (30 downto 0):= (others => '0');

begin
FA_IN(0) <= CIN;
FA_IN(1) <= B;
FA_IN(2) <= A;
U1: kadai2 port map (FA_IN,FA_OUT);
S <= FA_OUT(0);
COUT <= FA_OUT(1);


process (CLK)
begin
if rising_edge(CLK) then
COUNT <= COUNT+ 1; 
end if;

if(COUNT < 50000000) then
CLKHZ <= '0';
elsif(COUNT < 100000000) then
CLKHZ <= '1';
else
COUNT <= (others => '0');
end if;
end process;

U2: dff port map (CLKHZ, FA_OUT(0), SHZ);
U3: dff port map (CLKHZ, FA_OUT(1), CHZ);

end Behavioral;
