library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity clkdiv is 
    port(
        clkin, reset : in std_logic;
        clkout : out std_logic
    );
end clkdiv;

architecture archi of clkdiv is 
signal count : integer:=0; 
signal clk : std_logic:='0';

begin 

process(clkin, reset) 
begin
    if reset = '1' then 
        count <= 0;
    elsif(rising_edge(clkin)) then
        count <=count+1;
        if(count = 6250000) then
            count <= 0;
            clk <= not clk;
        end if;
    end if;
end process;

clkout <= clk;

end archi;