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
        mem(0 to 4) <= (x"DCBA", x"110A" ,x"900F", x"1240", x"D001");
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

-- example program : 
-- add R0, 0x1 | 0001 0001 0000 0001 = 0x1101
-- add R1, R0  | 0001 0010 0000 0000 = 0x1200
-- sto R1, 0xA | 1001 0010 0000 1010 = 0x920A
-- loa R2, 0xA | 1000 0100 0000 1010 = 0x840A
-- add R3, R2  | 1000 0110 0100 0000 = 0x8640

-- add R0, 0xA  | 0001 0001 0000 1010 = x110A
-- sto R0, 0xf  | 1001 0000 0000 1111 = x900F
-- add R1, R2   | 0001 0010 0100 0000 = x1240
-- jp 0x1       | 1101 0000 0000 0000 = xD000