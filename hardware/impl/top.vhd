library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity top is
    port(
        clkin, reset : in std_logic;
        reg0 : out std_logic_vector(15 downto 0)
    );
end top;

architecture archi of top is 
signal clk : std_logic;

begin 

clkd: entity work.clkdiv
    port map(
        clkin, reset, clk
    );

cpu : entity work.cpu16
    port map(
        clk, reset, reg0
    );

end archi;