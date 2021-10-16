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
        data_out : out std_logic_vector(15 downto 0)
    );
end memory;

architecture archi of memory is
type mem_t is array(0 to 511) of std_logic_vector(15 downto 0);
signal mem : mem_t := ((others => (others => '0')));

begin

process(clk, reset)
begin   
    if reset = '1' then -- instructions
        mem(0 to 4) <= (
            -- Test programs
            x"0000",    -- reserved
            x"10E0",    -- add R0, R7
            x"2620",    -- sub R3, R1
            x"D001",    -- jp  0x1
            x"F000"     -- halt
        );
    elsif rising_edge(clk) then 
        if mem_r = '1' then 
            data_out <= mem(to_integer(unsigned(addr)));
        elsif mem_w = '1' then 
            mem(to_integer(unsigned(addr))) <= data_in;
        end if;
    end if;
end process;
end archi;

-- nop              x"0000" -- reserved
-- or  r0, 0x64     x"4164" 
-- sto r0, 0x50     x"9050" 
-- not r0           x"5000"
-- jn  0x1          x"B001"
-- or r0, 0xFF      x"41FF"
-- hlt              x"F000"
--


