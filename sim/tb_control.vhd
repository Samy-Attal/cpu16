-- test bench control unit 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_control is 
end tb_control;

architecture simu of tb_control is
signal clk, reset : std_logic := '0';
signal r, w : std_logic;
signal instr, dataA, dataB, regB, result : std_logic_vector(15 downto 0) := x"0000";
signal alu_ctrl, nzp : std_logic_vector(2 downto 0);
signal adrA, adrB : std_logic_vector(2 downto 0);
signal reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : std_logic_vector(15 downto 0);

begin

ctrl : entity work.control 
    port map(clk, reset, instr, alu_ctrl, r, w);

regs : entity work.registers
    port map(clk, reset, r, w, 
        instr(11 downto 9), 
        instr(7 downto 5), 
        result, dataA, regB,
        reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7
    );

ual : entity work.alu 
    port map(dataA, dataB, alu_ctrl, nzp, result);

clk <= not(clk) after 10 ns;
reset <= '1', '0' after 5 ns;
instr <= x"1301", x"10E0" after 70 ns;
adrA <= instr(11 downto 9);
adrB <= instr(7 downto 5);
dataB <= regB when instr(8) = '0' else x"00"&instr(7 downto 0);

end simu;

-- add R0, R7
-- 0001 000 0 1110 0000 = 0x10E0
--> R0 = 0 + 7 

-- add R1, R0
-- 0001 001 0 0000 0000 = 0x1200
--> R1 = 1 + 7

-- add R1, #1
-- 0001 001 1 0000 0001 = 0x1301