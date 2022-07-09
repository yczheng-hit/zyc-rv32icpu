`define OPCODE_LUI 0
`define OPCODE_AUIPC 1
`define OPCODE_JAL 2
`define OPCODE_JALR 3
`define OPCODE_BEQ 4
`define OPCODE_BNE 5
`define OPCODE_BLT 6
`define OPCODE_BGE 7
`define OPCODE_BLTU 8
`define OPCODE_BGEU 9
`define OPCODE_LB 10
`define OPCODE_LH 11
`define OPCODE_LW 12
`define OPCODE_LD 13
`define OPCODE_LBU 14
`define OPCODE_LHU 15
`define OPCODE_SB 16
`define OPCODE_SH 17
`define OPCODE_SW 18
`define OPCODE_SD 19
`define OPCODE_ADDI 20
`define OPCODE_SLTI 21
`define OPCODE_SLTIU 22
`define OPCODE_XORI 23
`define OPCODE_ORI 24
`define OPCODE_ANDI 25
`define OPCODE_SLLI 26
`define OPCODE_SRLI 27
`define OPCODE_SRAI 28
`define OPCODE_ADD 29
`define OPCODE_SUB 30
`define OPCODE_SLL 31
`define OPCODE_SLT 32
`define OPCODE_SLTU 33
`define OPCODE_XOR 34
`define OPCODE_SRL 35
`define OPCODE_SRA 36
`define OPCODE_OR 37
`define OPCODE_AND 38
`define OPCODE_ECALL 39
`define OPCODE_ADDIW 40
`define OPCODE_MUL 41
`define OPCODE_MULH 42
`define OPCODE_DIV 43
`define OPCODE_REM 44
`define OPCODE_LWU 45
`define OPCODE_SLLIW 46
`define OPCODE_SRLIW 47
`define OPCODE_SRAIW 48
`define OPCODE_ADDW 49
`define OPCODE_SUBW 50
`define OPCODE_SLLW 51
`define OPCODE_SRLW 52
`define OPCODE_SRAW 53
`define OPCODE_USRDEF 99

`define OP_REG 5'b01100
`define OP_IMM 5'b00100
`define OP_LUI 5'b01101
`define OP_BRANCH 5'b11000
`define OP_STORE 5'b01000
`define OP_LOAD 5'b00000
`define OP_SYSTEM 5'b11100
`define OP_AUIPC 5'b00101
`define OP_JAL 5'b11011
`define OP_JALR 5'b11001
`define OP_IMM32 5'b00110
`define OP_32 5'b01110
`define OP_USRDEF 5'b11111

`define ALU_LUI (1'b1 << 19)
`define ALU_AUIPC (1'b1 << 18)
`define ALU_JAL (1'b1 << 17)
`define ALU_JALR (1'b1 << 16)
`define ALU_BEQ (1'b1 << 15)
`define ALU_BNE (1'b1 << 14)
`define ALU_BLT (1'b1 << 13)
`define ALU_BGE (1'b1 << 12)
`define ALU_BLTU (1'b1 << 11)
`define ALU_BGEU (1'b1 << 10)
`define ALU_ADD (1'b1 << 9)
`define ALU_SUB (1'b1 << 8)
`define ALU_SLL (1'b1 << 7)
`define ALU_SRA (1'b1 << 6)
`define ALU_SRL (1'b1 << 5)
`define ALU_SLT (1'b1 << 4)
`define ALU_SLTU (1'b1 << 3)
`define ALU_XOR (1'b1 << 2)
`define ALU_OR (1'b1 << 1)
`define ALU_AND (1'b1 << 0)
// `define ALU_ADD 37'b0010_0000_0000
// `define ALU_SUB 37'b0001_0000_0000
// `define ALU_SLL 37'b0000_1000_0000
// `define ALU_SRA 37'b0000_0100_0000
// `define ALU_SRL 37'b0000_0010_0000
// `define ALU_SLT 37'b0000_0001_0000
// `define ALU_SLTU 37'b0000_0000_1000
// `define ALU_XOR 37'b0000_0000_0100
// `define ALU_OR 37'b0000_0000_0010
// `define ALU_AND 37'b0000_0000_0001

