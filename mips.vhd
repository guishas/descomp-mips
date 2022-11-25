library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips is
  generic (
		simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE 
  );
  port (  
		CLOCK_50			 	: in std_logic;
		KEY					: in std_logic_vector(3 DOWNTO 0);
		SW						: in std_logic_vector(9 DOWNTO 0);
		HEX0					: out std_logic_vector(6 DOWNTO 0);
		HEX1					: out std_logic_vector(6 DOWNTO 0);
		HEX2					: out std_logic_vector(6 DOWNTO 0);
		HEX3					: out std_logic_vector(6 DOWNTO 0);
		HEX4					: out std_logic_vector(6 DOWNTO 0);
		HEX5					: out std_logic_vector(6 DOWNTO 0);
		LEDR					: out std_logic_vector(9 DOWNTO 0);
		PC_OUT				: out std_logic_vector(31 DOWNTO 0);
		ULA_OUT 				: out std_logic_vector(31 DOWNTO 0)
  );
	
end entity;


architecture arquitetura of mips is

	signal SIG_CLK			  			: std_logic;
	signal SIG_SAIDA_FLAGZ_ULA		: std_logic;
	signal SIG_DEC_TO_INVB			: std_logic;	
	signal DECODER_TO_ULA			: std_logic_vector(3 DOWNTO 0);
	signal SIG_RD	 					: std_logic_vector(4 DOWNTO 0);
	signal SIG_RS			 			: std_logic_vector(4 DOWNTO 0);
	signal SIG_RT			 			: std_logic_vector(4 DOWNTO 0);
	signal SIG_MUXBANREG_OUT		: std_logic_vector(4 DOWNTO 0);
	signal SIG_FUNCT					: std_logic_vector(5 DOWNTO 0);
	signal PALAVRA_CONTROLE			: std_logic_vector(7 DOWNTO 0);
	signal SIG_IMEDIATO				: std_logic_vector(15 DOWNTO 0);
	signal SIG_IMEDIATO_EXTENDIDO	: std_logic_vector(31 DOWNTO 0);
	signal SIG_INCPC_OUT 			: std_logic_vector(31 DOWNTO 0);
	signal SIG_INCPC_BEQ_OUT 		: std_logic_vector(31 DOWNTO 0);
	signal SIG_MUX_BEQ_OUT 			: std_logic_vector(31 DOWNTO 0);
	signal SIG_MUX_ULAB_OUT			: std_logic_vector(31 DOWNTO 0);
	signal SIG_MUXPC_OUT				: std_logic_vector(31 DOWNTO 0);
	signal SIG_PC_OUT      			: std_logic_vector(31 DOWNTO 0);
	signal SIG_ROM_OUT     			: std_logic_vector(31 DOWNTO 0);
	signal SIG_RAM_OUT				: std_logic_vector(31 DOWNTO 0);
	signal SIG_ULA_OUT	  			: std_logic_vector(31 DOWNTO 0);
	signal SIG_BAN_OUT_REGA			: std_logic_vector(31 DOWNTO 0);
	signal SIG_BAN_OUT_REGB			: std_logic_vector(31 DOWNTO 0);
	signal SIG_MUX_ULA_MEM_OUT		: std_logic_vector(31 DOWNTO 0);
	signal SIG_MUX_TESTE_OUT		: std_logic_vector(31 DOWNTO 0);

begin

gravar: if simulacao generate
	
	SIG_CLK <= KEY(0);
	
else generate

	SIG_CLK <= KEY(0);

end generate;

PC: entity work.registradorGenerico generic map(larguraDados => 32)
		port map(
			DIN => SIG_MUXPC_OUT,
			DOUT =>	SIG_PC_OUT,
			ENABLE =>'1',
			CLK => SIG_CLK,
			RST => '0'
		);

INCREMENTA_PC : entity work.somaConstante generic map(larguraDados => 32, constante => 4)
		port map(
			entrada => SIG_PC_OUT,
			saida => SIG_INCPC_OUT
		);
		
INCREMENTA_IMEDIATO : entity work.somaSinais generic map(larguraDados => 32)
		port map(
			entradaCima => SIG_INCPC_OUT,
			entradaBaixo => SIG_IMEDIATO_EXTENDIDO(29 DOWNTO 0) & "00",
			saida => SIG_INCPC_BEQ_OUT
		);
		
MUX_BEQ : entity work.muxGenerico2x1 generic map(larguraDados => 32)
		port map(
			entradaA_MUX => SIG_INCPC_OUT,
			entradaB_MUX => SIG_INCPC_BEQ_OUT,
			seletor_MUX => PALAVRA_CONTROLE(2) and SIG_SAIDA_FLAGZ_ULA,
			saida_MUX => SIG_MUX_BEQ_OUT
		);
		
MUX_BANREG : entity work.muxGenerico2x1 generic map(larguraDados => 5)
		port map(
			entradaA_MUX => SIG_RT,
			entradaB_MUX => SIG_RD,
			seletor_MUX => PALAVRA_CONTROLE(6),
			saida_MUX => SIG_MUXBANREG_OUT
		);
		
MUX_ULAB : entity work.muxGenerico2x1 generic map(larguraDados => 32)
		port map(
			entradaA_MUX => SIG_BAN_OUT_REGB,
			entradaB_MUX => SIG_IMEDIATO_EXTENDIDO,
			seletor_MUX => PALAVRA_CONTROLE(4),
			saida_MUX => SIG_MUX_ULAB_OUT
		);
		
MUX_JMP : entity work.muxGenerico2x1 generic map(larguraDados => 32)
		port map(
			entradaA_MUX => SIG_MUX_BEQ_OUT,
			entradaB_MUX => SIG_INCPC_OUT(31 DOWNTO 28) & SIG_IMEDIATO_EXTENDIDO(25 DOWNTO 0) & "00",
			seletor_MUX => PALAVRA_CONTROLE(7),
			saida_MUX => SIG_MUXPC_OUT
		);

MUX_ULA_MEM : entity work.muxGenerico2x1 generic map(larguraDados => 32)
		port map(
			entradaA_MUX => SIG_ULA_OUT,
			entradaB_MUX => SIG_RAM_OUT,
			seletor_MUX => PALAVRA_CONTROLE(3),
			saida_MUX => SIG_MUX_ULA_MEM_OUT
		);
		
ROM : entity work.ROM generic map(dataWidth => 32, addrWidth => 32, memoryAddrWidth => 6)
		port map (
			Endereco => SIG_PC_OUT,
			Dado => SIG_ROM_OUT
		);
		
RAM : entity work.RAM generic map(dataWidth => 32, addrWidth => 32, memoryAddrWidth => 6)
		port map(
			clk => SIG_CLK,
			Endereco => SIG_ULA_OUT,
			Dado_in => SIG_BAN_OUT_REGB,
			Dado_out => SIG_RAM_OUT,
			we => PALAVRA_CONTROLE(0),
			re => PALAVRA_CONTROLE(1),
			habilita => '1'
		);
		
BANREG : entity work.bancoReg generic map(larguraDados => 32, larguraEndBancoRegs => 5)
		port map (
			clk => SIG_CLK,
			enderecoA => SIG_RS,  
			enderecoB => SIG_RT, 
			enderecoC => SIG_MUXBANREG_OUT, 
			dadoEscritaC => SIG_MUX_ULA_MEM_OUT,
			escreveC => PALAVRA_CONTROLE(5),
			saidaA => SIG_BAN_OUT_REGA,
			saidaB => SIG_BAN_OUT_REGB
		);
		
--ULA : entity work.ULASomaSub generic map(larguraDados => 32)
--		port map (
--			entradaA => SIG_BAN_OUT_REGA,
--			entradaB => SIG_MUX_ULAB_OUT,
--			seletor => SELETOR_ULA,
--			saida => SIG_ULA_OUT,
--			saida_flag_zero => SIG_SAIDA_FLAGZ_ULA
--		);
		
ULA : entity work.ULA
		port map (
			entradaA 	=> SIG_BAN_OUT_REGA,
			entradaB		=> SIG_MUX_ULAB_OUT,
			sel_mux		=> DECODER_TO_ULA(1 DOWNTO 0),
			inverteB		=> DECODER_TO_ULA(2),
			resultado	=> SIG_ULA_OUT,
			flagZero		=> SIG_SAIDA_FLAGZ_ULA
		);
	
		
EXTENSOR : entity work.extensorSinalGenerico generic map(larguraDadoEntrada => 16, larguraDadoSaida => 32)
		port map(
			estendeSinal_IN => SIG_IMEDIATO,
			estendeSinal_OUT => SIG_IMEDIATO_EXTENDIDO
		);
		
DECODER_INSTR : entity work.decoderMIPS
	port map(
		opcode => SIG_ROM_OUT(31 DOWNTO 26),
		funct	 => SIG_ROM_OUT(5 DOWNTO 0),
		ula_ctrl => DECODER_TO_ULA, 
		palavra => PALAVRA_CONTROLE
	);
	
MUX_TESTE : entity work.muxGenerico2x1 generic map(larguraDados => 32)
		port map(
			entradaA_MUX => SIG_PC_OUT,
			entradaB_MUX => SIG_ULA_OUT,
			seletor_MUX => SW(0),
			saida_MUX => SIG_MUX_TESTE_OUT
		);

	
HEX_SEG_0 :  entity work.conversorHex7Seg
        port map(
				dadoHex => SIG_MUX_TESTE_OUT(3 DOWNTO 0),
            apaga =>  '0',
            negativo => '0',
            overFlow =>  '0',
            saida7seg => HEX0
			);

HEX_SEG_1 :  entity work.conversorHex7Seg
        port map(
				dadoHex => SIG_MUX_TESTE_OUT(7 DOWNTO 4),
            apaga =>  '0',
            negativo => '0',
            overFlow =>  '0',
            saida7seg => HEX1
			);

HEX_SEG_2 :  entity work.conversorHex7Seg
        port map(
				dadoHex => SIG_MUX_TESTE_OUT(11 DOWNTO 8),
            apaga =>  '0',
            negativo => '0',
            overFlow =>  '0',
            saida7seg => HEX2
			);

HEX_SEG_3 :  entity work.conversorHex7Seg
        port map(
				dadoHex => SIG_MUX_TESTE_OUT(15 DOWNTO 12),
            apaga =>  '0',
            negativo => '0',
            overFlow =>  '0',
            saida7seg => HEX3
			);

HEX_SEG_4 :  entity work.conversorHex7Seg
        port map(
				dadoHex => SIG_MUX_TESTE_OUT(19 DOWNTO 16),
            apaga =>  '0',
            negativo => '0',
            overFlow =>  '0',
            saida7seg => HEX4
			);

	
HEX_SEG_5 :  entity work.conversorHex7Seg
        port map(
				dadoHex => SIG_MUX_TESTE_OUT(23 DOWNTO 20),
            apaga =>  '0',
            negativo => '0',
            overFlow =>  '0',
            saida7seg => HEX5
			);
		
LEDR(3 DOWNTO 0) <= SIG_MUX_TESTE_OUT(27 DOWNTO 24);
LEDR(7 DOWNTO 4) <= SIG_MUX_TESTE_OUT(31 DOWNTO 28);

SIG_RD <= SIG_ROM_OUT(15 DOWNTO 11);
SIG_RS <= SIG_ROM_OUT(25 DOWNTO 21);
SIG_RT <= SIG_ROM_OUT(20 DOWNTO 16);
SIG_FUNCT <= SIG_ROM_OUT(5 DOWNTO 0);
SIG_IMEDIATO <= SIG_ROM_OUT(15 DOWNTO 0);

PC_OUT <= SIG_PC_OUT;
ULA_OUT <= SIG_ULA_OUT;

end architecture;
