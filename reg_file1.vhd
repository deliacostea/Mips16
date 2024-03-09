----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_file1 is
    Port ( ra1 : in STD_LOGIC_VECTOR (3 downto 0);
           ra2 : in STD_LOGIC_VECTOR (3 downto 0);
           wa : in STD_LOGIC_VECTOR (3 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           regwr : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end reg_file1;

architecture Behavioral of reg_file1 is
type mem is array(0 to 15) of std_logic_vector(15 downto 0);
signal reg:mem;
begin

rd1<=reg(conv_integer(ra1));
rd2<=reg(conv_integer(ra2));
process(regwr)
begin
    if rising_edge(regwr)then
        reg(conv_integer(wa))<=wd;
    end if;
end process;

end Behavioral;
