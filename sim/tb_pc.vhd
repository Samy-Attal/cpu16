-- test bench program counter
-- with memory : mem(0 to 4) <= (x"0000", x"110A" ,x"900F", x"1240", x"D001");

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_pc is 
end tb_pc;

architecture simu of tb_pc is
signal clk, reset, next_instr, jump_en, mem_r, mem_w, alu_or_mem, reg_r, reg_w : std_logic := '0';
signal jump, counter, addr : std_logic_vector(8 downto 0);
signal mem_in, mem_out, mem1, n_instr : std_logic_vector(15 downto 0);
signal nzp, alu_ctrl : std_logic_vector(2 downto 0);
begin 

cnt : entity work.pc
    port map(reset, next_instr, jump_en, jump, counter);

mem : entity work.memory 
    port map(clk, reset, mem_r, mem_w, mem_in, addr, mem_out, mem1);

ctrl : entity work.control 
    port map(clk, reset, nzp, n_instr, alu_ctrl, reg_r, reg_w, mem_r, mem_w, alu_or_mem, next_instr, jump_en);


clk <= not(clk) after 10 ns;
reset <= '1', '0' after 5 ns;
jump <= n_instr(8 downto 0);
addr <= n_instr(8 downto 0) when next_instr = '0' else counter;
mem_in <= x"ABCD", x"FFFF" after 330 ns;
nzp <= "001";

process(next_instr)
begin 
    if rising_edge(next_instr) then 
        n_instr <= mem_out;
    end if;
end process;

end simu;