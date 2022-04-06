library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

  -- en mode continu la donnée est rafraîchie toute les secondes
 
 --------------------explication code mae-------------------------
--continu =0 et start stop paase à = 1 alors mesure encours passe à 0 que lorsque data valid est a 1
--pcq on a fini notre mesure  ( on est pret a faire une autre mesure ) 
--il faut un effet memoire si jai pas de mesure en cours 
--et que start stop passe a 1 alors mesure en cours prend 1
--SINON si jai data valid qui passe a 1 alors mesure en cours prend 0
------------------------------------------------------------------

-- on cherche à détecter un evenement qui indique la fin de la mesure 
------------ Mode monocoup ------------------------------------
---- au début on est dans un état repos ca veut dire qu'une mesure est en cours,  
---- data_valid veut dire qu'une mesure s'est achevée , je demande à faire une aquisition quand start_stop = 1
---- je sais qu'une aquisition est achevé quand j'ai data_valid = 1 donc à partir de la je repasse en mode repos
---- l'état aquisition est un enable qui autorise à notre anemometre de faire l'aquisition
---------------Mode continu--------------------------------
------Le monde continu = 1 c'est quand on reste tout le temps dans l'état aquisition qlq soit l'état de data_valid
------ on ajoute un ou avec la transition de repos vers aquisition par exemple quand continu = 1 peut importe 
-------- la valeur de start_stop on sait qu'on va etre en mode continu, il va tout le temps rester dans
-------- letat aquisition et pour eviter de sortir de l'état d'aquisition on sort que si continu = 0

-----------------------resume ----------------------
--je sors de l'état d'aquisition vers repos si data_valid = 1 et que continu = 0
---------------------------------------------------------
-- on crée une machine à état avec 2 états : repos et aquisition
-- aquisition est l'image d'inable :
--enable vaut 1 que si on est dans aquisition
---------------------------------------------------------


entity mae is
port(raz_n: in std_logic ; --initialise le circuit à 0

clk : in std_logic;
continu : in std_logic ; -- 0 mode continu , 1 mode monocoup
start_stop :  in std_logic ; -- 0 mesure valid rà1 de data_valid sinon demarre aquisition 
data_valid : in std_logic ; -- si = 1 mesure valid 

mesure_encours : out std_logic 
  ); end mae;

architecture arch of mae is

begin 
  process (clk)
  begin 
  if raz_n ='1' then
	if (continu ='0') then
	if (data_valid = '1' and start_stop <= '1') then 
	   mesure_encours <= '0' ; -- demarrer une nvelle mesure
	 --- effet memoire
	 
	  elsif  (start_stop = '1' and data_valid ='0') then
	   mesure_encours <= '1'; 
	
	end if;
	end if;
   end if;
	 
	 end process;
end arch;