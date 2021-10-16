-- Program counter

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pc is
    port(
        reset, next_instr, jump_en : in std_logic;
        jump : in std_logic_vector(8 downto 0); 
        counter : out std_logic_vector(8 downto 0)
    );
end pc;

architecture archi of pc is
signal count : std_logic_vector(8 downto 0) := (others => '0');

begin 

process(reset, next_instr, jump_en)
begin
    if reset = '1' then 
        count <= "000000000";
    elsif jump_en = '1' then 
        count <= jump;
    elsif rising_edge(next_instr) then
        count <= count + '1';
    end if;
end process;  

counter <= count; 

end architecture;