library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity dff is
Port (CLK, D : in STD_LOGIC; Q : out STD_LOGIC);
end dff;
architecture Behavioral of dff is
begin
process (CLK) begin
if rising_edge(CLK) then -- �N���b�N�̗����オ��G�b�W�̌��o
Q <= D;
end if;
end process;
end Behavioral;
