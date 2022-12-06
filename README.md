# Projeto do MIPS DLX para a disciplina de Design de Computadores

**Desenvolvedores**:

- Guilherme Lunetta
- José Rafael Fernandes

**Instruções**:

- Tipo A:
  - ADD
  - SUB
  - AND
  - OR
  - SLT
  - LW
  - SW
  - BEQ
  - JUMP (J)
- Tipo B:
  - LUI
  - ADDI
  - ANDI
  - ORI
  - SLTI
  - BNE
  - JAL
  - JR
- Extras:
  - NOR
  - SLL
  - SRL

**Como usar**:

- Na placa, o botão para passar os CLOCK's é a KEY 0.
- No arquivo ROM.vhd, altere entre os arquivos initROM.mif e initROMFull.mif para testar o conjunto A e B e para testar as novas instruções criadas pelo grupo.
  - No arquivo initROM.mif contém as instruções dos cojuntos A e B
  - No arquivo initROMFull.mif contém as instruções NOR, SLL e SRL implementadas pelo grupo.
  - Não esqueça de compilar
