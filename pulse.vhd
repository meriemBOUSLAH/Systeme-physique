library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

------- pulse ---------------------------------------
entity pulse is
port (
reset, clk, ARst : in std_logic;  
pulseQ : out std_logic ;
sck : out std_logic   
);
end entity;

architecture rtl of pulse is
signal sckfm : std_logic ;	    
component generateurpulse is
 generic (
        compare_value   : integer := 50
    );
port (clk: in std_logic;
   	  reset: in std_logic;
      pulse: buffer std_logic
      --clkgen : out std_logic
	);
end component;             
------------------------------------------------------
begin
upulseQ : generateurpulse
        generic map (
            compare_value => 50
        )
        port map (
            clk => clk,
            reset => ARst,
            pulse => pulseQ
	    );	   
----------- signal sck --------------------------------
genereSCK: process (clk,pulseQ)
begin 
if rising_edge(clk) then    -- generer sck 
	if pulseQ = '1' then
		sck <= not sck;
	end if;
end if; 
end process;

sckfm <= '1' when sck = '0' and pulseQ = '1' else '0'; -- detecter FM et FD
-------------------------------------------------------
end rtl;

-------------------------------------------------------

