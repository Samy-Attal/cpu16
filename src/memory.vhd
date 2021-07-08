-- Memory
-- 512 blocs de 16 bits

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity memory is 
    port(
        clk, reset, mem_r, mem_w : in std_logic;
        data_in : in std_logic_vector(15 downto 0);
        addr : in std_logic_vector(8 downto 0);
        data_out, memf : out std_logic_vector(15 downto 0)
    );
end memory;

architecture archi of memory is
type mem_t is array(0 to 511) of std_logic_vector(15 downto 0);
signal mem : mem_t := ((others => (others => '0')));

begin

process(clk, reset)
begin   
    if reset = '1' then -- program instructions
        mem(0 to 4) <= (x"0000", x"10E0" ,x"2620", x"D001", x"900F");
    elsif rising_edge(clk) then 
        if mem_r = '1' then 
            data_out <= mem(to_integer(unsigned(addr)));
        elsif mem_w = '1' then 
            mem(to_integer(unsigned(addr))) <= data_in;
        end if;
    end if;
end process;
memf <= mem(15);
end archi;

-- 00000000000000000000000000000000000000000
-- add R0, R7   | 0001 0000 1110 0000 = 10E0
-- sub R3, R1   | 0010 0110 0010 0000 = 2620
-- jp  0x1      | 1101 0000 0000 0001 = D001
-- sto R0, 0xF  | 1001 0000 0000 000F = 900F

