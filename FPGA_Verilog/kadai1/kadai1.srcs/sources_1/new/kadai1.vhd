----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/10/24 14:18:49
-- Design Name: 
-- Module Name: kadai1 - Behavioral
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

entity kadai1 is
    Port ( BTNL : in STD_LOGIC;
           BTNR : in STD_LOGIC;
          LD : out STD_LOGIC_VECTOR (2 downto 0));
end kadai1;

architecture Behavioral of kadai1 is
begin

LD(0) <= BTNL and BTNR;
LD(1) <= BTNL or BTNR;
LD(2) <= BTNL xor BTNR;

end Behavioral;
