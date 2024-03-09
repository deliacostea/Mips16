

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MPG1 is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           en : out STD_LOGIC);
end MPG1;

architecture Behavioral of MPG1 is
signal count: std_logic_vector(15 downto 0);
signal q1,q2,q3:std_logic;
begin
counter: process (clk)
begin
   if clk='1' and clk'event then
      count <= count + 1;
   end if;
end process;
dflipflop1: process (clk)
begin
   if clk'event and clk='1' then
    if count(15 downto 0)="1111111111111111" then
      q1 <= btn;
      end if;
   end if;
end process;
dflipflop2: process (clk)
begin
   if clk'event and clk='1' then
      q2 <= q1;
      q3 <= q2;
   end if;
end process;
en <= q2 and (not q3);
end Behavioral;