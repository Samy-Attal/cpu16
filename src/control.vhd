-- Control unit 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity control is 
    port(
        clk, reset : in std_logic;
        instr : in std_logic_vector(15 downto 0);
        alu_ctrl : out std_logic_vector(2 downto 0);
        reg_r, reg_w: out std_logic
    );
end control;

architecture archi of control is
signal opcode : std_logic_vector(3 downto 0);
type state is (ntd, calc, reg_write);
signal EP, EF: state;

begin 

opcode <= instr(15 downto 12);

-- alu control 
process(clk, reset, EP)
begin   
    if reset = '1' then 
        EP <= ntd;
    elsif rising_edge(clk) then 
        EP <= EF;
    end if;

    case(EP) is 
        when ntd => EF <= ntd;
            if (opcode(3) = '0' and opcode /= "0000") then EF <= calc; end if;
        when calc => EF <= reg_write;
        when reg_write => EF <= ntd;
    end case;
end process;

process(EP)
begin
    if EP = ntd then reg_r <= '0'; reg_w <= '0'; alu_ctrl <= "000";
    elsif EP = calc then reg_r <= '1'; reg_w <= '0'; alu_ctrl <= opcode(2 downto 0);
    elsif EP = reg_write then reg_r <= '0'; reg_w <= '1'; alu_ctrl <= "000";
    end if;
end process;

end archi;

