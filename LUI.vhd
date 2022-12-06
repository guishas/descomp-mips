library ieee;
use ieee.std_logic_1164.all;

entity LUI is
    generic
    (
        larguraDadoEntrada : natural  :=    16;
        larguraDadoSaida   : natural  :=    32
    );
    port
    (
        -- Input ports
        SINAL_IN : in  std_logic_vector(larguraDadoEntrada-1 downto 0);
        -- Output ports
        SINAL_OUT: out std_logic_vector(larguraDadoSaida-1 downto 0)
    );
end entity;

architecture comportamento of LUI is
begin

    SINAL_OUT <= SINAL_IN & x"0000";
end architecture;