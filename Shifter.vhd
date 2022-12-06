library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shifter is
    generic(
        larguraDados : natural  :=    32
    );
    port(
		  ENTRADA : in std_logic_vector((larguraDados - 1) DOWNTO 0);
		  SHAMT	 : in std_logic_vector(4 DOWNTO 0);
		  SIG_SLL : in std_logic;
		  SIG_SRL : in std_logic;
		  SAIDA 	 : out std_logic_vector((larguraDados - 1) DOWNTO 0)
    );
end entity;

architecture comportamento of Shifter is
	
	signal LEFTSHIFT : std_logic_vector((larguraDados - 1) DOWNTO 0);
	signal RIGHTSHIFT : std_logic_vector((larguraDados - 1) DOWNTO 0);

begin

	
	LEFTSHIFT <= std_logic_vector(unsigned(ENTRADA) sll to_integer(unsigned(SHAMT)));
	RIGHTSHIFT <= std_logic_vector(unsigned(ENTRADA) srl to_integer(unsigned(SHAMT)));
	
	SAIDA <= LEFTSHIFT when SIG_SLL = '1' else RIGHTSHIFT when SIG_SRL = '1' else x"00000000";

end architecture;