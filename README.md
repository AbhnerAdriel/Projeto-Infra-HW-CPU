# CPU MIPS Multiciclo de 32 Bits

Projeto de uma CPU MIPS multiciclo de 32 bits implementada em Verilog. A arquitetura foi organizada em uma Unidade de Processamento, implementada principalmente no módulo `CPU.v`, e uma Unidade de Controle, implementada no módulo `uControl.v`. O módulo de topo do projeto é `Main.v`, que interliga a CPU e o controle.

## Identificação

- **Projeto:** Implementação de CPU MIPS 32 Bits Multiciclo
- **Grupo:** Grupo 06
- **Autor:** Abhner Adriel Cristóvão Silva
- **Login:** aac2@cin.ufpe.br
- **Instituição:** Universidade Federal de Pernambuco — Centro de Informática (CIn/UFPE)

## Visão geral

A CPU executa instruções MIPS em múltiplos ciclos de clock. Em vez de executar todas as etapas de uma instrução em um único ciclo, a arquitetura divide a execução em etapas como busca da instrução, decodificação, cálculo de endereço, execução da ULA, acesso à memória, escrita no banco de registradores, tratamento de desvios, saltos, multiplicação, divisão, operações de deslocamento e exceções.

O projeto utiliza memória inicializada por arquivo `.mif`, banco de registradores, ULA de 32 bits, registradores intermediários, unidade de deslocamento, unidade de multiplicação/divisão, multiplexadores e uma unidade de controle baseada em máquina de estados finitos.

## Principais características

- CPU MIPS multiciclo de 32 bits.
- Unidade de controle implementada por máquina de estados em `uControl.v`.
- Unidade de processamento implementada em `CPU.v`.
- Suporte a instruções dos tipos R, I e J.
- Suporte a acesso à memória por byte e por palavra.
- Suporte a multiplicação e divisão com registradores `HI` e `LO`.
- Suporte a instruções `mfhi` e `mflo`.
- Suporte a deslocamentos lógicos e aritméticos.
- Suporte a exceções de opcode inválido, overflow e divisão por zero.
- Memória inicializada pelo arquivo `instrucoes.mif`.
- Projeto compatível com simulação no ModelSim/QuestaSim.

## Estrutura dos arquivos

| Arquivo | Descrição |
|---|---|
| `Main.v` | Módulo principal do projeto. Instancia a CPU e a Unidade de Controle. |
| `CPU.v` | Unidade de Processamento. Contém datapath, registradores, memória, ULA, HI/LO, multiplexadores e demais conexões. |
| `uControl.v` | Unidade de Controle. Implementa a máquina de estados que gera os sinais de controle da CPU. |
| `Banco_reg.vhd` | Banco de registradores da CPU. |
| `Memoria.vhd` | Memória do sistema, inicializada pelo arquivo `instrucoes.mif`. |
| `Instr_Reg.vhd` | Registrador de instrução, responsável por separar opcode, registradores e imediato. |
| `Registrador.vhd` | Registrador genérico de 32 bits com clock, reset e load. |
| `ula32.vhd` | ULA de 32 bits, com operações aritméticas, lógicas e flags. |
| `RegDesloc.vhd` | Registrador/unidade de deslocamento para instruções de shift. |
| `DIVMULT.v` | Unidade que integra multiplicação e divisão, selecionando a saída por `MDControl`. |
| `mult.v` | Módulo de multiplicação sequencial. Escreve resultado em `HI` e `LO`. |
| `div.v` | Módulo de divisão sequencial. Escreve resto em `HI`, quociente em `LO` e sinaliza `div0`. |
| `LoadSize.v` | Ajusta o dado carregado da memória conforme o tipo de load. |
| `StoreSize.v` | Ajusta o dado escrito na memória conforme o tipo de store. |
| `Mux2to1.v` | Multiplexador 2 para 1. |
| `Mux3to1.v` | Multiplexador 3 para 1. |
| `mux4to1.v` | Multiplexador 4 para 1. |
| `Mux5to1.v` | Multiplexador 5 para 1. |
| `Mux9to1.v` | Multiplexador 9 para 1. |
| `ShiftLeft2.v` | Deslocamento à esquerda de 2 bits. |
| `ShiftLeft16.v` | Deslocamento à esquerda de 16 bits, usado em `lui`. |
| `ShiftLeft26to28.v` | Ajuste do campo de endereço usado em instruções de salto. |
| `SignExtend16to32.v` | Extensão de sinal/imediato de 16 para 32 bits. |
| `SignExtend1to32.v` | Extensão de 1 bit para 32 bits, usada em resultados comparativos. |
| `teste.v` | Módulo auxiliar para teste da unidade `DIVMULT`. |
| `instrucoes.mif` | Arquivo de inicialização da memória de instruções/dados. |
| `wave.do` | Script de ondas do ModelSim. |

## Módulo principal

O módulo principal é:

```verilog
Main
```

Entradas principais:

| Sinal | Descrição |
|---|---|
| `clk` | Clock do sistema. |
| `reset` | Reinicialização da CPU e da unidade de controle. |

Saídas principais:

| Sinal | Descrição |
|---|---|
| `wPCOut` | Valor atual do Program Counter. |
| `wShiftRegOut` | Saída da unidade de deslocamento. |
| `wALUResult` | Resultado atual da ULA. |
| `wMemOut` | Palavra lida da memória. |
| `eqf` | Flag de igualdade gerada pela ULA. |
| `wCurrentState` | Estado atual da Unidade de Controle. |

## Instruções implementadas

O controle identifica instruções pelo `opcode` e, no caso de instruções do tipo R, também pelo campo `funct`.

### Tipo R

| Instrução | Função |
|---|---|
| `add` | Soma entre registradores. |
| `and` | Operação lógica AND. |
| `sub` | Subtração entre registradores. |
| `slt` | Set on less than. |
| `sll` | Shift lógico à esquerda com `shamt`. |
| `sllv` | Shift lógico à esquerda com quantidade variável. |
| `srl` | Shift lógico à direita. |
| `sra` | Shift aritmético à direita com `shamt`. |
| `srav` | Shift aritmético à direita com quantidade variável. |
| `mult` | Multiplicação com resultado em `HI` e `LO`. |
| `div` | Divisão com resto em `HI` e quociente em `LO`. |
| `mfhi` | Move o conteúdo de `HI` para um registrador. |
| `mflo` | Move o conteúdo de `LO` para um registrador. |
| `jr` | Salto para endereço armazenado em registrador. |
| `xchg` | Troca valores em memória usando os endereços armazenados em registradores. |
| `rte` | Retorno de exceção usando o registrador EPC. |

### Tipo I

| Instrução | Função |
|---|---|
| `addi` | Soma com imediato. |
| `beq` | Desvio se os operandos forem iguais. |
| `bne` | Desvio se os operandos forem diferentes. |
| `lb` | Carregamento de byte da memória. |
| `lw` | Carregamento de palavra da memória. |
| `sb` | Escrita de byte na memória. |
| `sw` | Escrita de palavra na memória. |
| `lui` | Carregamento do imediato na parte alta da palavra. |
| `sram` | Leitura da memória seguida de deslocamento aritmético. |

### Tipo J

| Instrução | Função |
|---|---|
| `j` | Salto incondicional. |
| `jal` | Salto com armazenamento do endereço de retorno. |

## Unidade de Controle

A Unidade de Controle está em `uControl.v` e usa uma máquina de estados finitos. O estado atual é disponibilizado na saída `currentState`, conectada em `Main.v` como `wCurrentState`.

Principais grupos de estados:

| Grupo | Estados |
|---|---|
| Busca de instrução | `S_FETCH_ADDR`, `S_FETCH_WAIT`, `S_FETCH_LOAD` |
| Decodificação | `S_DECODE` |
| Execução aritmética/lógica | `S_ALU_EXEC`, `S_R_WRITE`, `S_I_WRITE`, `S_SLT_WRITE` |
| Deslocamentos | `S_SHIFT_LOAD`, `S_SHIFT_EXEC`, `S_SHIFT_WAIT`, `S_SHIFT_WRITE` |
| Memória | `S_MEM_ADDR`, `S_MEM_READ`, `S_MEM_WAIT`, `S_MEM_CAPTURE`, `S_MEM_LOAD_WRITE`, `S_MEM_STORE` |
| Desvios e saltos | `S_BRANCH`, `S_JUMP`, `S_JAL`, `S_JR` |
| Multiplicação/divisão | `S_MD_START`, `S_MD_WAIT`, `S_HILO_SAVE` |
| Acesso a HI/LO | `S_MFHI_WRITE`, `S_MFLO_WRITE` |
| SRAM | `S_SRAM_ADDR`, `S_SRAM_READ`, `S_SRAM_WAIT`, `S_SRAM_CAPTURE`, `S_SRAM_LOAD`, `S_SRAM_EXEC`, `S_SRAM_SHIFT_WAIT`, `S_SRAM_WRITE` |
| XCHG | `S_XCHG_READ_RS`, `S_XCHG_WAIT_RS`, `S_XCHG_LATCH_RS`, `S_XCHG_READ_RT`, `S_XCHG_WAIT_RT`, `S_XCHG_LATCH_RT`, `S_XCHG_WRITE_RT`, `S_XCHG_WRITE_RS` |
| Exceções | `S_EXC_OPCODE`, `S_EXC_OPCODE_WAIT`, `S_EXC_OVERFLOW`, `S_EXC_OVF_WAIT`, `S_EXC_DIV0`, `S_EXC_DIV0_WAIT`, `S_EXC_CAPTURE`, `S_EXC_SET_PC` |
| Retorno de exceção | `S_RTE` |

## Licença e uso

Este projeto foi desenvolvido com finalidade acadêmica para a disciplina de Infraestrutura de Hardware, do curso de Ciência da Computação do CIn-UFPE, envolvendo a implementação e simulação de uma CPU MIPS multiciclo de 32 bits.
