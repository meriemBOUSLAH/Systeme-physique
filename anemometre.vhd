library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

--------------------------------------------------------------------------------------
-- ici on doit créer le bloc anemometre qui recoit un signal d'entrée qui est la vitesse du vent
-- le signal sera transformé en signal numerique carré 
-- la frequence de ce signal doit etre en sortie à 1Mhz
-- la 1ere boite c'est detecteur de front montant du signal in freq qui a comme entrées (Clk 50M et in_freq_anemo)
-----et comme sortie (freq) qui sera l'entrée du second boite
-- la 2eme c'est le compteur qui compte le nbre de front montant 
-- la 3eme c'est un generateur d'impulsion(diviseur) qui dit au compteur tu arretes de compter au bout de 1s
------et remet le compteur à 0 au bout de 1s : genere un signal de 1 Mhz chaque 1s
-- le 4eme qui est le registre qui recoit la valeur du compteur chaque 1 s et qui donne en sortie le signal 1Mhz
------------------------------------------------------------------------------------------

entity anemometre is
    port (
        ARst_N : in std_logic;
        Clk_50M : in std_logic;
        in_freq_anemo : in std_logic;
        data_anemo : out std_logic_vector(7 downto 0);
        data_valid : out std_logic;
        Debug0 : out std_logic;
        Debug1 : out std_logic_vector(7 DOwnto 0)
    );
end anemometre;

architecture arc of anemometre is 
-- DFM
component dfm is
    Port ( clk_50M : in STD_LOGIC;
           in_freq_anemo : in std_logic;
           in_freq_a : out std_logic
              );
end component;
-- Compteur
component cmp is
    generic (
        N   : integer := 8              
    );
port (  clk: in std_logic;
    	Arst: in std_logic;
    	SRst: in std_logic;
    	en  : in std_logic;
    	Ud  : in    std_logic; 
        Q   : out   std_logic_vector(N - 1 downto 0)
	);
end component;
--------------------generateurpulse-----------------------------------    
component generateurpulse is
 generic (
        compare_value   : integer := 49_999_999              
    );
port (clk: in std_logic;
   	  reset: in std_logic;
      pulse: out std_logic;
      clkgen : out std_logic
	);
end component;
              
----------------------registre-----------------------------
component registre is
generic (
        N   : integer := 8              
    );
    Port ( clk : in STD_LOGIC;
           E: in std_logic_vector(N - 1 downto 0);
           en : in std_logic;
           Q: out std_logic_vector(N - 1 downto 0)
              );
end component;
-------------------------machine à etat mae-------------
component machineetat is
    port (
        ARst_N  : in    std_logic;
        Clk     : in    std_logic;
        data_valid, continu, start_stop  : in    std_logic;
        mesure_encours : out   std_logic ); 
end component ;

--- declaration de signaux internes pour les connexions entre les blocs

signal ARst : std_logic;
signal in_freq_FM : std_logic;

signal CptFM_Q : std_logic_vector(7 downto 0);

signal pulse_Q : std_logic;
-----------------------------------------------------------------------
begin
    ARst <= not ARst_N;
    uDFM : dfm
        port map ( 
            clk_50M => Clk_50M,
            in_freq_anemo => in_freq_anemo,
            in_freq_a => in_freq_FM
        );  
    uCptFM : cmp 
        generic map (
            N   => 8
        )
        port map (  
            clk => Clk_50M,
            Arst => ARst,
            SRst => pulse_Q,
            en  => in_freq_FM,
            Ud  => '1',
            Q   => CptFM_Q
        );
        
    ugenerateurpulse : generateurpulse
        generic map (
            compare_value => 25_000
        )
        port map (
            clk => Clk_50M,
            reset => ARst,
            pulse => pulse_Q,
            clkgen => open
	    );
----------------registre-----------------------------
    ureg :  registre 
        generic map (
            N => 8
        )
        port map ( 
            clk =>clk_50M,
            E => CptFM_Q,
            en => pulse_Q,
            Q => data_anemo
        );
  Debug0 <= pulse_Q;
  Debug1 <= CptFM_Q;
  
  
---------------------Machine à etat-------------------



---------------------------------------------
end arc;


			
			