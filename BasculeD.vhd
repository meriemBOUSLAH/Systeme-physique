library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity BasculeD is
port ( 
	reset : in std_logic;
	clk : in std_logic;
	en : in std_logic; 
	D : in std_logic;
	Q : out std_logic);
end;

architecture arc of BasculeD is
begin 
	process(reset, clk)
	begin
		if reset='1' then 
			Q <= '0';
		elsif rising_edge (clk) then 
			if en ='1' then 
				Q<=D;
			end if;
		end if;
	end process;
end;