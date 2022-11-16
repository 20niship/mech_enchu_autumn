----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/10/24 14:36:17
-- Design Name: 
-- Module Name: kadai2 - Behavioral
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

entity kadai2 is
    Port ( SW : in STD_LOGIC_VECTOR (2 downto 0);
           LD : out STD_LOGIC_VECTOR (1 downto 0));
end kadai2;

architecture Behavioral of kadai2 is

begin
process (SW)
begin
case SW is
when "000" => LD <= "00";
when "001" => LD <= "01";
when "010" => LD <= "01";
when "011" => LD <= "10";
when "100" => LD <= "01";
when "101" => LD <= "10";
when "110" => LD <= "10";
when "111" => LD <= "11";
when others => LD <= "--"; -- don't care o—Í
end case;
end process;
end Behavioral;
