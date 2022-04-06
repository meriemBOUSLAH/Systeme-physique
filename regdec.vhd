library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Regdec is -- 
port (
data_in : in std_logic_vector (15 downto 0); -- recup donnée 
en : in std_logic ; -- SCKFM connecté à enable du RD pour autoriser le décalage
data_valid : out std_logic_vector (15 downto 0)  
);
end entity;

architecture arc of Regdec is
signal data_valid std_logic_vector (15 downto 0);
begin
rec_dec: process (sck)
	variable i: integer ;
	begin
if sck'event and sck='1' then
data_valid(0) <= data_in(0);
data_in(i) = data_in(i-1) when i<=11; 
end if ;
end process rec_dec;



compt_fronts: process (s_clk_adc, raz_compteur)
	begin
	if raz_compteur = '1' then
	compt_front <=0;
	elsif s_clk_adc'event and s_clk_adc='1' then
		if compt_front=14 then
		compt_front <= 0;
		fin <= '1';
		else
		compt_front <= compt_front +1;
		fin <= '0';
		end if;
	end if;
	end process compt_fronts;















end arc;