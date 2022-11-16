----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/10/24 15:23:50
-- Design Name: 
-- Module Name: kadai5 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity kadai5 is
    Port ( SW : in STD_LOGIC_VECTOR (3 downto 0);
           SEG_SEL : out STD_LOGIC_VECTOR (3 downto 0);
           SEL_DATA : out STD_LOGIC_VECTOR (7 downto 0));
end kadai5;

architecture Behavioral of kadai5 is
begin
process (SW)
begin
case SW is
when "0000" => SEL_DATA <= "11000000"; --"00111111";
when "0001" => SEL_DATA <= "11111001";
when "0010" => SEL_DATA <= "10100100";
when "0011" => SEL_DATA <= "10110000"; --"01001111"; --3
when "0100" => SEL_DATA <= "10011001"; --"01100110"; --4
when "0101" => SEL_DATA <= "10010010"; --"01101101"; --5
when "0110" => SEL_DATA <= "10000010"; --"00111101"; --6
when "0111" => SEL_DATA <= "11111000"; --"00000111"; --7
when "1000" => SEL_DATA <= "10000000"; --"01111111"; --8
when "1001" => SEL_DATA <= "10010000"; --"01101111"; --9
when "1010" => SEL_DATA <= "10100000"; --"01011111"; --a
when "1011" => SEL_DATA <= "10000011"; --"01111100"; --b
when "1100" => SEL_DATA <= "11000110"; --"00111001"; --c
when "1101" => SEL_DATA <= "10100001"; --"01011110"; --d
when "1110" => SEL_DATA <= "10000110"; --"01111011"; --e
when "1111" => SEL_DATA <= "10001110"; --"01110001"; --f
when  others => SEL_DATA <= "--------"; -- don't care o—Í
end case;
end process;

SEG_SEL<="1110";

end Behavioral;
