library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is 
component MPG1 is
    Port ( 
           clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           en : out STD_LOGIC);
end component MPG1;

component SSD is
    Port(
            clk : in std_logic;
            digits: in std_logic_vector(15 downto 0);
            an : out std_logic_vector(3 downto 0);
            cat : out std_logic_vector(6 downto 0));
         end component SSD;
         
 component reg_file1 is
  Port ( ra1 : in STD_LOGIC_VECTOR (3 downto 0);
           ra2 : in STD_LOGIC_VECTOR (3 downto 0);
           wa : in STD_LOGIC_VECTOR (3 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           regwr : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
 end component;
 
 component InstructionFetch is
 Port(   clk: in std_logic;
            en_PC: in std_logic;
            en_reset: in std_logic;
            branch_address: in std_logic_vector(15 downto 0);
            jump_address: in std_logic_vector(15 downto 0);
            jump: in std_logic;
            PCSrc: in std_logic;
            instruction: out std_logic_vector(15 downto 0);
            next_instruction_address: out std_logic_vector(15 downto 0));
 end component;
   
 component IDecode is
 Port(  clk : in STD_LOGIC;
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
 end component;
 
 
 
 component ControlUnit is
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
 end component;
 
 component Ex is
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
end component;

component MEM is
 Port ( clk : in STD_LOGIC;
          en : in STD_LOGIC;
          ALURes : in STD_LOGIC_VECTOR (15 downto 0);
          RD2 : in STD_LOGIC_VECTOR (15 downto 0);
          MemWrite : in STD_LOGIC;
          MemData : out STD_LOGIC_VECTOR (15 downto 0);
          ALUResOut : out STD_LOGIC_VECTOR (15 downto 0));
end component;
                 
 
signal Instr, PcInc,sum,Rd1,Rd2,Ext_imm,ext_func,ext_sa,WD:std_logic_vector(15 downto 0);
signal JumpAddress,BranchAddress,ALURes,ALURes1,MemData:Std_Logic_vector(15 downto 0);
signal digits:std_logic_vector(15 downto 0);
signal en,rst,sa,zero,PCSrc: std_logic;
signal func:std_logic_vector(2 downto 0);
signal RegDst,ExtOp,ALUSrc,Branch,Jump,MemWrite,MemtoReg,RegWrite:std_logic;
signal AluOp:std_logic_vector(2 downto 0);
begin 
--sumreg<=rd1+rd2;
MPG:  MPG1 port map(clk,btn(0), en);
Mpg2: MPG1 port map(clk,btn(1),rst);

PCSrc<='1' when (Branch='1' and ((zero='1' and Instr(15 downto 13)="110") or (zero='0' and Instr(15 downto 13)="010")))else '0';
instr_fetch: InstructionFetch port map(clk,en,rst,BranchAddress,JumpAddress,Jump,PCSrc,Instr,PcInc);
dec: IDecode port map(clk,en,Instr(12 downto 0),WD,RegWrite,RegDst,ExtOp,Rd1,Rd2,Ext_imm,func,sa);
control:ControlUnit port map(Instr(15 downto 13),RegDst,ExtOp,ALUSrc,Branch,Jump,AluOp,MemWrite,MemtoReg,RegWrite);
Execute: Ex port map(PcInc,Rd1,Rd2,Ext_imm,func,sa,ALUSrc,AluOp,BranchAddress,ALURes,zero);
ram: MEM port map(clk,en,ALURes,Rd2,MemWrite,MemData,AluRes1);

ALURes<=AluRes1;
with MemtoReg select
    WD <=MemData when '1',
         ALURes1 when '0',
         (others => 'X') when others;


JumpAddress <=PcInc(15 downto 13) & Instr(12 downto 0);
with sw(7 downto 5) select
digits <= Instr when "000",
          PcInc when "001",
          Rd1 when   "010",
          Rd2 when    "011",
          ALURes when "100",
          ext_imm when "101",
          ext_func when "110",
         WD when "111",
(others => 'X')when others;
display: SSD port map (clk,digits,an,cat);

led(10 downto 0) <=AluOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;

end Behavioral;

