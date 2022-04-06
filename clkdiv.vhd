library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity cmp is
    generic (
        N   : integer := 26    -- Constante qui defini la largeur du compteur sur N bits            
    );
port (  clk: in std_logic;     -- Horloge
    	Arst: in std_logic;	   -- Remise à 0 de façon asynchrone active niveau bas
    	SRst: in std_logic;    -- Remise à 0 de façon synchrone
    	en  : in std_logic;	   -- '1' --> autorise le comptage
    	Ud  : in    std_logic; -- '1' --> Incremente; '0' --> Decremente
    Q   : out   std_logic_vector(N - 1 downto 0)  -- Sortie du compteur sur N bits
	);
end cmp;
architecture rtl of cmp is
    signal sQ   : std_logic_vector(N - 1 downto 0);
begin
        pCnt: process(Clk, Arst)
    begin
            if Arst = '0' then
            sQ <= (others => '0');
        elsif rising_edge(Clk) then
            if SRst = '1' then
                sQ <= (others => '0');
            else
                if En = '1' then       -- autoriser le comptage
                    if Ud = '1' then	
                        sQ<= sQ+1;
                    else
                        sQ <= sQ - 1;
                    end if;
                end if;
            end if;
        end if;
    end process pCnt;
    Q<=sQ;
end architecture rtl;