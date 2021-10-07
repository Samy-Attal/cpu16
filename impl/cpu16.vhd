-- cpu16

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity cpu16 is 
    port(
        clk, reset : in std_logic;
        reg0 : out std_logic_vector(15 downto 0)
    );
end cpu16;

architecture archi of cpu16 is
signal reg_r, reg_w, mem_r, mem_w, alu_or_mem, next_instr, jump_en : std_logic := '0';
signal nzp, alu_ctrl, adrA, adrB : std_logic_vector(2 downto 0);
signal jump, counter, mem_addr : std_logic_vector(8 downto 0);
signal instr, result, dataA, dataB, regB, reg_in, mem_in, mem_out : std_logic_vector(15 downto 0);
    
begin


ctrl : entity work.control
    port map(
        clk, reset, nzp, instr,
        alu_ctrl, reg_r, reg_w, mem_r, mem_w, alu_or_mem, next_instr, jump_en
    );

regs : entity work.registers
    port map(
        clk, reset, reg_r, reg_w, adrA, adrB, reg_in,
        dataA, regB, reg0
    );

ual : entity work.alu
    port map(
        dataA, dataB, alu_ctrl, 
        nzp, result
    );

mem : entity work.memory
    port map(
        clk, reset, mem_r, mem_w, mem_in, mem_addr, 
        mem_out
    );

cnt : entity work.pc 
    port map(
        reset, next_instr, jump_en, jump, 
        counter
    );

-- gestion registres
adrA <= instr(11 downto 9);
adrB <= instr(7 downto 5);
dataB <= regB when instr(8) = '0' else x"00"&instr(7 downto 0);
reg_in <= result when alu_or_mem = '0' else mem_out;

-- gestion memory & program counter
mem_in <= dataA;
jump <= instr(8 downto 0);
mem_addr <= instr(8 downto 0) when next_instr = '0' else counter;

-- instruction
process(next_instr)
begin  
    if rising_edge(next_instr) then 
        instr <= mem_out;
    end if;
end process;

end archi;