library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity etat is
port (

continu : in std_logic; -- continu = 0 mode monocoup sinon =1 mode continu
start_stop : in std_logic; -- start_stop = 1 en mode monocoup d�marre une acquisition, si = 0 r�s data_valid
etat : out std_logic_vector(1 downto 0));
end etat ;
 architecture arch of etat is 
 begin 
process(continu,start_stop) 
begin 
if (continu ='0' and start_stop ='0') then -- 00 mode monocoup et r�s de data_valid
etat <= "00";
elsif (continu ='0' and start_stop ='1') then -- 01 mode monocoup et d�marrage d'une aquisition
etat <= "01";
elsif(continu ='1' and start_stop ='0') then -- 10 mode continu et r�s de data_valid
etat <= "10";
elsif(continu ='1' and start_stop ='1') then -- 11 mode continu et demarrage d'une aquisition
etat <= "11";

end if ; 
 
end process;
end arch;
