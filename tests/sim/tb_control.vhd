-- test bench control unit 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_control is 
end tb_control;

architecture simu of tb_control is
signal clk, reset : std_logic := '0';
signal reg_r, reg_w, mem_r, mem_w, alu_or_mem, next_instr, jump_en : std_logic;
signal instr, dataA, dataB, regB, result, reg_in, mem_in, mem_out, mem1 : std_logic_vector(15 downto 0) := x"0000";
signal alu_ctrl, nzp : std_logic_vector(2 downto 0);
signal adrA, adrB : std_logic_vector(2 downto 0);
signal reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : std_logic_vector(15 downto 0);
signal mem_adr : std_logic_vector(8 downto 0);
begin

ctrl : entity work.control 
    port map(clk, reset, nzp, instr, alu_ctrl, reg_r, reg_w, mem_r, mem_w, alu_or_mem, next_instr, jump_en);

regs : entity work.registers
    port map(clk, reset, reg_r, reg_w, adrA, adrB, reg_in, dataA, regB,
        reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7
    );

ual : entity work.alu 
    port map(dataA, dataB, alu_ctrl, nzp, result);

mem : entity work.memory
    port map(clk, reset, mem_r, mem_w, mem_in, mem_adr, mem_out, mem1);

clk <= not(clk) after 10 ns;
reset <= '1', '0' after 5 ns;
adrA <= instr(11 downto 9);
adrB <= instr(7 downto 5);
dataB <= regB when instr(8) = '0' else x"00"&instr(7 downto 0);
reg_in <= result when alu_or_mem = '0' else mem_out;
mem_in <= dataA;
mem_adr <= instr(8 downto 0);
end simu;

-- add R0, R7 0001 000 0 1110 0000 = 0x10E0
--> R0 = 0 + 7 

-- add R1, R0 0001 001 0 0000 0000 = 0x1200
--> R1 = 1 + 7

-- add R1, #1 0001 001 1 0000 0001 = 0x1301

-- loa R7, x1 1000 1110 0000 0001 = 0x8E01

-- add R7, 10 0001 1111 0000 1010 = 0x1F0A

-- sto R7, x1 1001 1110 0000 0001 = 0x9E01