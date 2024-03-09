
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity Ex is
    Port ( PcInc : in STD_LOGIC_VECTOR (15 downto 0);
           Rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           Rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           func : in STD_LOGIC_VECTOR (2 downto 0);
           sa : in STD_LOGIC;
           ALUSrc : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR(2 downto 0);
          BranchAdd : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC);
end Ex;

architecture Behavioral of Ex is
signal ALUIn2:std_logic_vector(15 downto 0);
signal ALUCtrl:std_logic_vector(2 downto 0);
signal alures2:std_logic_vector(15 downto 0);
begin
with ALUSrc select
ALUIn2 <= Rd2 when '0',--de tip r
        Ext_Imm when '1',--de tip i
        (others => 'X') when others;
        
 process(ALUOp, func)
 begin
    case ALUOp is
         when "000" =>
            case func is
            when "011" =>ALUCtrl <= "000";--add
            when "000" =>ALUCtrl <="011";--and
            when "001" =>ALUCtrl <="001";-- sub
            when "010" =>ALUCtrl <="010";--or
            when "100" =>ALUCtrl <="100";--sll
            when "101" =>ALUCtrl <="101";--srl
            when "110" =>ALUCtrl <="110";--xor
            when "111" => ALUCtrl<="111";--xnor
            when others =>AluCtrl <= (others =>'X');
            end case;
          when "001" =>ALUCtrl <= "000";-- +
          when "010" =>ALUCtrl <= "001"; -- -
          
          when others =>ALuCtrl <= (others => 'X');
       end case;
 end process;
 
 process(ALUCtrl,Rd1,ALUIn2, sa)
 begin
    case ALUCtrl is
        when "000" => alures2 <= Rd1 + ALUIn2; --Add
        when "011" => alures2 <= Rd1 and ALUIn2; --And
        when "001" => alures2 <= Rd1 - ALUIn2; --Sub
        when "010" => alures2 <= Rd1 or ALUIn2; --or
        when "100" => if(sa='1') then
         alures2 <= ALUIn2(14 downto 0) & '0'; --SLL
         else alures2<=ALUIn2;
         end if;
        when "101" => if(sa='1') then
        alures2 <= '0' & ALUIn2(15 downto 1); --SRL
        else alures2<=ALUIn2;
        end if;
        when "110" => alures2 <= Rd1 xor ALUIn2; --xor
        when "111" => alures2 <= Rd1 xnor ALUIN2; --xnor
        when others =>alures2 <=(others =>'X');
        end case;
        end process;
 ALURes<=alures2;
 Zero <= '1' when alures2="0000000000000000" else '0';
 BranchAdd<=PcInc+Ext_Imm;     

end Behavioral;
