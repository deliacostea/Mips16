library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity InstructionFetch is
    Port(   clk: in std_logic;
            en_PC: in std_logic;
            en_reset: in std_logic;
            branch_address: in std_logic_vector(15 downto 0);
            jump_address: in std_logic_vector(15 downto 0);
            jump: in std_logic;
            PCSrc: in std_logic;
            instruction: out std_logic_vector(15 downto 0);
            next_instruction_address: out std_logic_vector(15 downto 0));
end InstructionFetch;

 architecture Behavioral of InstructionFetch is

signal PC: std_logic_vector(15 downto 0) := (others => '0');
signal out_MUX_Jump: std_logic_vector(15 downto 0);
signal out_MUX_Branch: std_logic_vector(15 downto 0);
signal out_adder: std_logic_vector(15 downto 0);
type ROM_array is array (0 to 255) of std_logic_vector(15 downto 0);
signal ROM: ROM_array := (
--suma numerelor pare de pe pozitii impare
B"001_000_110_0000001",         -- 0 addi $6, $0, 1    2301
B"000_000_000_001_0_011",       -- 1 add  $1, $0, $0   0013
B"001_000_100_0001010",         -- 2 addi $4, $0, 10   220A
B"000_000_000_010_0_011",       -- 3 add  $2, $0, $0   0023
B"000_000_000_101_0_011",       -- 4 add  $5, $0, $0   0053
B"110_100_001_0001001",         -- 5 beq  $1, $4,end_loop D089
B"101_010_011_0000000",         -- 6 lw   $3, A_addr($2),0  A980
B"000_001_110_111_0_000",       -- 7 and  $7, $1, $6       0770
B"010_111_110_0000011",         -- 8 bne  $7, $6, loop2    5F03
B"000_011_110_111_0_000",       -- 9 and  $7, $3, $6       0F70
B"010_111_000_0000001",         --10 bne  $7, $0, loop2    5C01
B"000_101_011_101_0_011",       --11 add  $5, $5, $3       15D3
B"001_010_010_0000001",         --12 loop2:addi $2, $2, 1        2901
B"001_001_001_0000001",         --13 addi $1, $1, 1        2481
B"111_0000000000101",           --14 j begin_loop          E005
B"100_000_101_0000000",         --15 sw $5, sum_addr($0)   8280  

others => X"0000");
 
begin
--procesul muxului cu selectia PCSrc
process(PCSrc)
begin
    case PCSrc is
        when '0' => out_MUX_Branch <= out_adder;
        when '1' => out_MUX_Branch <= branch_address;
        when others => out_MUX_Branch <= x"0000";
    end case;
end process;

process(jump)
begin 
    case jump is
        when '0' => out_MUX_Jump <= out_MUX_Branch;
        when '1' => out_MUX_Jump <= jump_address;
        when others => out_mux_Branch <= x"0000";
    end case;
end process;

out_adder <= PC + 1;--sumatorul

next_instruction_address <= out_adder;

process(clk, en_PC, en_reset)
begin
    if rising_edge(clk) then
        if en_reset = '1' then 
            PC <= x"0000"; 
        elsif en_PC = '1' then
            PC <= out_MUX_Jump;
        end if;
    end if;
end process;

instruction <= ROM(conv_integer(PC(7 downto 0)));

end Behavioral;