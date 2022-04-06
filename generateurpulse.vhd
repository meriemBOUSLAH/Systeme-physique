library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use IEEE.math_real.all; 

entity generateurpulse is
	generic (
		compare_value : integer := 49_999_999      
	);
	port (
		clk : in std_logic;
		reset : in std_logic;
		pulse : out std_logic;
		clkgen : out std_logic
	);
end generateurpulse;

architecture arc of generateurpulse is
-- Declaration des composants 
-- compteur
	component cmp is
		generic (
			N   : integer := 8              
		);
		port (  
				ARst : in std_logic;
				Clk : in std_logic;
				SRst : in std_logic;
				en : in std_logic;
				Ud : in    std_logic; 
				Q  : out   std_logic_vector(N - 1 downto 0)
		);
	end component;
-- bascule
	component BasculeD is
		port ( 
			reset : in std_logic;
			clk : in std_logic;
			en : in std_logic;
			D : in std_logic;
			Q : out std_logic
		);
	end component;
-- Decclaration de constantes
    constant N_bits_Cnt : integer := integer(ceil(log2(real(compare_value))));
-- Déclaration des signaux
	signal sQ : std_logic_vector(N_bits_Cnt - 1 downto 0);
	signal comparateur : std_logic;
	signal iClkDiv : std_logic;
	signal iClkDiv_N : std_logic;
begin

	uCnt : cmp
		generic map (
			N => N_bits_Cnt
		)
		port map (  
			clk  => Clk,
			Arst => reset,
			SRst => comparateur,
			en   => '1',
			Ud   => '1',
			Q    => sQ
		);	

	comparateur <= '1' when sQ >= (compare_value - 1) else '0';

    uBasculeClkGen : BasculeD
        port map ( 
            reset => reset, 
            clk => clk, 
            en => comparateur, 
            D => iClkDiv_N,
            Q => iClkDiv
        );
        iClkDiv_N <= not iClkDiv;
        clkgen <= iClkDiv;

    uBasculePulseGen : BasculeD
        port map ( 
            reset => reset, 
            clk => clk, 
            en => '1', 
            D => comparateur,
            Q => pulse
        );
end;