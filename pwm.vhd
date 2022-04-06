library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;


--- gestion PWM ----
-- fixer la fréquence de la pwm

entity pwm is

port (
clk, reset_n : in std_logic;
reset_counter : in std_logic;
pwm_out : out std_logic
);

end entity pwm ;


ARCHITECTURE arc of pwm IS
---************gestion PWM***************************
	signal freq : std_logic_vector (15 downto 0);
    signal freq_pwm : std_logic_vector (15 downto 0);
	signal duty : std_logic_vector (15 downto 0);
	signal counter : std_logic_vector (15 downto 0);
-------------------------
	signal raz_n : std_logic;
BEGIN

--- gestion PWM ----
-- fixer la fréquence de la pwm

divide: process (clk, raz_n)
	begin
	if raz_n = '0' then
	counter <= (others => '0');
	elsif clk'event and clk = '1' then
		if counter >= freq_pwm then
		counter <= (others => '0');
		else
		counter <= counter + 1;
		end if;
	end if;
end process divide;	

--******************************************************
--génère le rapport cyclique
--***************************************************** 
compare: process(clk, reset_n)
        begin
			if(reset_n = '0') then
				pwm_out <= '0';
            elsif (clk'event and clk='1') then
					if counter >= duty then
					pwm_out <= '0';
					  else
					   pwm_out <= '1';
					end if;
            end if;
            
end process compare ;   
    
end arc;