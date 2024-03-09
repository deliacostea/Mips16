
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity IDecode is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (12 downto 0);
           Wd : in STD_LOGIC_VECTOR (15 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           Rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           Rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
           funct : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end IDecode;

architecture Behavioral of IDecode is
type reg_array is array(0 to 7) of std_logic_vector(15 downto 0);
signal ext0 :std_logic_vector(15 downto 0);
signal reg_file:reg_array:=(
                        X"0000",
                        X"0000",
                        X"0000",
                        X"0000",
                        X"0000",
                        X"0011",
                        X"0101",
                        others =>X"0000");
 signal WriteAddres:std_logic_vector(2 downto 0);
 signal ext_op:std_logic;
begin
with RegDst select 
    WriteAddres <=Instr(6 downto 4) when '1',--rd
                 Instr(9 downto 7) when '0',--rt
                (others => 'X')when others;--unknown
    
    process(clk)
    begin
    if rising_edge(clk) then
    if en='1' and RegWrite='1' then
    reg_file(conv_integer(WriteAddres))<=Wd;
    end if;
    end if;
    end process;
    Rd1<=reg_file(conv_integer(Instr(12 downto 10)));
    Rd2<=reg_file(conv_integer(Instr(9 downto 7)));
    
    ext0<="000000000"&Instr(6 downto 0);
    imm_ext:process(ExtOp)
    begin
    if ExtOp ='0'
        then  Ext_Imm<=ext0;
     else 
     if Instr(6)='0' then 
        Ext_Imm<=ext0;
       else 
        Ext_Imm<= "111111111"&Instr(6 downto 0);
        end if;
        end if;
        end process;
         
   funct<=Instr(2 downto 0);
    sa<=Instr(3);
end Behavioral;
