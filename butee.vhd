library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;


entity butee is

port (
ARst_N, Clk, SRst,Ud, raz_n : in std_logic;      
Q: out std_logic_vector(N - 1 downto 0) -- Sortie du compteur sur N bits
);
end entity;

-- circuit de contrôle des butées---------------
architecture rtl of butee is
signal sQ   : std_logic_vector(N - 1 downto 0);
begin

end process;

--generer clock sck --detecter les FM et FD : les evenement 
-- generer des evenement : pulse ; ccounter mpt = comparator 
-- temps de coup horloge 20ns ; -- on s interesse a la sortie du comparator 
-- On doit mémoriser : faire une bascule 
-- COMMENT detecter FM et FD ? on compare le clk et la sortie du comparator sck : porte and
		-- SCKFM <= '1' when pulseQ ='1' and SCK='0' else 0 ;
		-- SCKFD <= '0' when pulseQ = '1' and SCK ='1' else 0 ;
		
--****************generer SCK******************
--- cpt 
pCnt: process(Clk, ARst_N)
    begin
        if ARst_N = '0' then
            sQ <= (others => '0');
        elsif rising_edge(Clk) then
            if SRst = '1' then
                sQ <= (others => '0');
            else
                if En = '1' then
                    if Ud = '1' then
                        sQ <= sQ + 1;
                    end if;
                end if;
            end if;
        end if;
    end process pCnt;
    Q <= sQ;
-- comparator 
comparator : process (clk, raz_n)
	begin
	if raz_n = '0' then
	Q <= '0';
	elsif clk'event and clk = '1' then
		if counter >= duty then
		pwm_cmp <= '0';
		else
		pwm_cmp <= '1';
		end if;
	end if;
end process compare;

pwm_cmp <= pwm_cmp;
end architecture rtl;







