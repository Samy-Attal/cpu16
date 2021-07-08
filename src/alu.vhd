-- Unité Arithmetique et Logique 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu is
    port(
      A, B : in std_logic_vector(15 downto 0);
      op : in std_logic_vector(2 downto 0);
      nzp : out std_logic_vector(2 downto 0);
      result : out std_logic_vector(15 downto 0)
    );
end alu;

architecture archi of alu is 
signal res : std_logic_vector(15 downto 0);

begin 

process(op, A, B)
begin 
    case op is  
        when "001" => res <= A + B;
        when "010" => res <= A - B;
        when "011" => res <= A and B;
        when "100" => res <= A or B;
        when "101" => res <= not(A);
        when others => NULL;    
    end case;
end process;

process(res)
begin   
    if res = x"0000" then 
        nzp <= "010";
    elsif res(15) = '1' then 
        nzp <= "100";
    else 
        nzp <= "001";
    end if;
end process;

result <= res;

end archi;