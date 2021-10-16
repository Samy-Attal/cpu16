-- test bench alu

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_alu is
end tb_alu;

architecture simu of tb_alu is
signal inA, inB, result : std_logic_vector(15 downto 0);
signal oper, nzp : std_logic_vector(2 downto 0);

begin 

ual : entity work.alu 
    port map(
        inA, inB, oper, nzp, result
    );

inA <= x"0005", x"FFFF" after 20 ns, x"000A" after 40 ns, x"0000" after 60 ns, x"AAAA" after 80 ns;
inB <= x"0005", x"0000" after 20 ns, x"0001" after 40 ns, x"1111" after 60 ns;
oper <= "001", "011" after 20 ns, "010" after 40 ns, "100" after 60 ns, "101" after 80 ns;

end simu;