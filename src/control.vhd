-- Control unit 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity control is 
    port(
        clk, reset : in std_logic;
        nzp : in std_logic_vector(2 downto 0);
        instr : in std_logic_vector(15 downto 0);
        alu_ctrl : out std_logic_vector(2 downto 0);
        reg_r, reg_w, mem_r, mem_w, alu_or_mem, next_instr, jump_en : out std_logic
    );
end control;

architecture archi of control is
signal opcode : std_logic_vector(3 downto 0);
type state is (ntd, wait_instr, calc, res_write, mem_read, reg_write, reg_read, mem_write, writing_mem, jump, neg, zero, pos);
signal EP, EF: state;

begin 

opcode <= instr(15 downto 12);

-- sucession des etats
process(clk, reset, EP)
begin   
    if reset = '1' then 
        EP <= ntd;
    elsif rising_edge(clk) then 
        EP <= EF;
    end if;

    case(EP) is 
        when ntd => EF <= wait_instr;
        when wait_instr => EF <= ntd;
            if (opcode(3) = '0' and opcode /= "0000") then EF <= calc;  -- ALU
            elsif opcode = "1000" then EF <= mem_read;                  -- loa
            elsif opcode = "1001" then EF <= reg_read;                  -- sto
            elsif opcode = "1010" then EF <= jump;                      -- jmp    
            elsif opcode = "1011" then EF <= neg;                       -- jn
            elsif opcode = "1100" then EF <= zero;                      -- jz
            elsif opcode = "1101" then EF <= pos;                       -- jp
            end if;
        when calc => EF <= res_write;
        when res_write => EF <= ntd;
        when mem_read => EF <= reg_write;
        when reg_write => EF <= ntd;
        when reg_read => EF <= mem_write;
        when mem_write => EF <= writing_mem;
        when writing_mem => EF <= ntd;
        when neg => EF <= ntd;
            if nzp(2) = '1' then EF <= jump; end if;
        when zero => EF <= ntd;
            if nzp(1) = '1' then EF <= jump; end if;
        when pos => EF <= ntd;
            if nzp(0) = '1' then EF <= jump; end if;
        when jump => EF <= ntd;
    end case;
end process;

-- signaux de sorties en fonction des etats
process(EP)
begin
    if EP = ntd then
        next_instr <= '0'; jump_en <= '0';
        reg_r <= '0'; reg_w <= '0'; alu_ctrl <= "000";
        mem_r <= '0'; mem_w <= '0'; alu_or_mem <= '0';
    elsif EP = wait_instr then
        next_instr <= '1'; jump_en <= '0';
        reg_r <= '0'; reg_w <= '0'; alu_ctrl <= "000";
        mem_r <= '1'; mem_w <= '0'; alu_or_mem <= '0';
    elsif EP = calc then 
        next_instr <= '0'; jump_en <= '0';
        reg_r <= '1'; reg_w <= '0'; alu_ctrl <= opcode(2 downto 0);
        mem_r <= '0'; mem_w <= '0'; alu_or_mem <= '0';
    elsif EP = res_write then
        next_instr <= '0'; jump_en <= '0';
        reg_r <= '0'; reg_w <= '1'; alu_ctrl <= "000";
        mem_r <= '0'; mem_w <= '0'; alu_or_mem <= '0';
    elsif EP = mem_read then
        next_instr <= '0'; jump_en <= '0';
        reg_r <= '0'; reg_w <= '0'; alu_ctrl <= "000";
        mem_r <= '1'; mem_w <= '0'; alu_or_mem <= '0';
    elsif EP = reg_write then
        next_instr <= '0'; jump_en <= '0';
        reg_r <= '0'; reg_w <= '1'; alu_ctrl <= "000";
        mem_r <= '0'; mem_w <= '0'; alu_or_mem <= '1';
    elsif EP = reg_read then
        next_instr <= '0'; jump_en <= '0';
        reg_r <= '1'; reg_w <= '0'; alu_ctrl <= "000";
        mem_r <= '0'; mem_w <= '0'; alu_or_mem <= '0';
    elsif EP = mem_write then
        next_instr <= '0'; jump_en <= '0';
        reg_r <= '0'; reg_w <= '0'; alu_ctrl <= "000";
        mem_r <= '0'; mem_w <= '1'; alu_or_mem <= '0';
    elsif EP = writing_mem then 
        next_instr <= '0'; jump_en <= '0';
        reg_r <= '0'; reg_w <= '0'; alu_ctrl <= "000";
        mem_r <= '0'; mem_w <= '1'; alu_or_mem <= '0';
    elsif EP = neg or EP = zero or EP = pos then 
        next_instr <= '0'; jump_en <= '0';
        reg_r <= '0'; reg_w <= '0'; alu_ctrl <= "000";
        mem_r <= '0'; mem_w <= '0'; alu_or_mem <= '0';
    elsif EP = jump then 
        next_instr <= '0'; jump_en <= '1';
        reg_r <= '0'; reg_w <= '0'; alu_ctrl <= "000";
        mem_r <= '1'; mem_w <= '0'; alu_or_mem <= '0';
    end if;
end process;

end archi;