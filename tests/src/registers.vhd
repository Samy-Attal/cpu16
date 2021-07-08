-- Registers
-- 8 registres de 16 bits

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity registers is 
    port(
        clk, reset, reg_r, reg_w : in std_logic;            -- clock, reset, write access
        addrA, addrB : in std_logic_vector(2 downto 0);  -- adress A, adress B 
        data_w : in std_logic_vector(15 downto 0);       -- data input (result)
        dataA, dataB : out std_logic_vector(15 downto 0); -- data A & B output (arguments)
        reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : out std_logic_vector(15 downto 0)
    );
end registers;

architecture archi of registers is
type reg_t is array(0 to 7) of std_logic_vector(15 downto 0);
signal reg : reg_t;

begin

process(clk, reset)
begin
    if reset = '1' then 
        reg(0) <= x"0000";
        reg(1) <= x"0001";
        reg(2) <= x"0002";
        reg(3) <= x"0003";
        reg(4) <= x"0004";
        reg(5) <= x"0005";
        reg(6) <= x"0006";
        reg(7) <= x"0007";
    elsif rising_edge(clk) then
        if reg_r = '1' then 
            dataA <= reg(to_integer(unsigned(addrA)));
            dataB <= reg(to_integer(unsigned(addrB)));
        elsif reg_w = '1' then  
            reg(to_integer(unsigned(addrA))) <= data_w;
        end if;
    end if;
end process;

-- uniquement pour visualiser
reg0 <= reg(0);
reg1 <= reg(1);
reg2 <= reg(2);
reg3 <= reg(3);
reg4 <= reg(4);
reg5 <= reg(5);
reg6 <= reg(6);
reg7 <= reg(7);

end archi;