
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity ControlUnit is
Port	( Instr:in std_logic_vector(2 downto 0);
			 RegDst: out std_logic;
			 ExtOp: out std_logic;
			 ALUSrc: out std_logic;
			 Branch: out std_logic;
			 Jump: out std_logic;
			 ALUOp: out std_logic_vector(2 downto 0);
			 MemWrite: out std_logic;
			 MemtoReg: out std_logic;
			 RegWrite: out std_logic);
end ControlUnit;

architecture Behavioral of ControlUnit is
signal fl:std_logic_vector(10 downto 0);
begin

process(Instr)
begin
	case (Instr) is 
		when "000"=> --Instructiuni de tip R
			RegDst<='1';
			ExtOp<='0';
			ALUSrc<='0';
			Branch<='0';
			Jump<='0';
			ALUOp<="000";
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='1';
			
		when "001"=> -----ADDI-----
			RegDst<='0';
			ExtOp<='1';
			ALUSrc<='1';
			Branch<='0';
			Jump<='0';
			ALUOp<="001";
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='1';
			
			
		when "101"=> -----LW-----
			RegDst<='0';
			ExtOp<='1';
			ALUSrc<='1';
			Branch<='0';
			Jump<='0';
			ALUOp<="001";--pt adunare in alu
			MemWrite<='0';
			MemtoReg<='1';
			RegWrite<='1';
			
		when "100"=> -----SW-----
			RegDst<='0';
			ExtOp<='1';
			ALUSrc<='1';
			Branch<='0';
			Jump<='0';
			ALUOp<="001";--adunare in alu
			MemWrite<='1';
			MemtoReg<='0';
			RegWrite<='0';
			
		when "110"=> -----BEQ-----
			RegDst<='0';
			ExtOp<='1';
			ALUSrc<='0';
			Branch<='1';
			Jump<='0';
			ALUOp<="010";--salt in alu --pt scadere
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='0';
			
		when "010"=> -----Bne-----
			RegDst<='0';
			ExtOp<='1';
			ALUSrc<='0';
			Branch<='1';
			Jump<='0';
			ALUOp<="010";--scadere
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='0';
			
			when "011"=> -----BGTZ-----
            RegDst<='0';
            ExtOp<='1';
            ALUSrc<='0';
            Branch<='1';
            Jump<='0';
            ALUOp<="010";--salt in alu --pt scadere
            MemWrite<='0';
            MemtoReg<='0';
            RegWrite<='0';
                      
			
			
		when "111"=> -----JUMP-----
			RegDst<='0';
			ExtOp<='0';
			ALUSrc<='0';
			Branch<='0';
			Jump<='1';
			ALUOp<="111";
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='0';
			
			
			
		
		when others =>	-----OTHERS-----
			RegDst<='0';
			ExtOp<='0';
			ALUSrc<='0';
			Branch<='0';
			Jump<='0';
			ALUOp<="000";
			MemWrite<='0';
			MemtoReg<='0';
			RegWrite<='0';
	end case;
end process;		


end Behavioral;
