library ieee;
use ieee.std_logic_1164.all;

entity extensorSinalGenerico is
    generic
    (
        larguraDadoEntrada : natural  :=    16;
        larguraDadoSaida   : natural  :=    32
    );
    port
    (
        -- Input ports
		  SIG_ORIANDI : in std_logic;
        estendeSinal_IN : in  std_logic_vector(larguraDadoEntrada-1 downto 0);
        -- Output ports
        estendeSinal_OUT: out std_logic_vector(larguraDadoSaida-1 downto 0)
    );
end entity;

architecture comportamento of extensorSinalGenerico is
	
	signal SIG_MUX_OUT : std_logic_vector(15 DOWNTO 0);

begin

	 MUX_EXTENSOR : entity work.muxGenerico2x1 generic map(larguraDados => 16)
		port map(
			entradaA_MUX => (others => estendeSinal_IN(larguraDadoEntrada-1)),
			entradaB_MUX => x"0000",
			seletor_MUX => SIG_ORIANDI,
			saida_MUX => SIG_MUX_OUT
		);

    estendeSinal_OUT <= SIG_MUX_OUT & estendeSinal_IN;

end architecture;