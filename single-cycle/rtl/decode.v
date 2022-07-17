`include "define.v"

module decode(input [31:0]inst,
              output [19:0] inst_opcode,
              output [4:0] rs1,
              output [4:0] rs2,
              output [4:0] rd,
              output reg_src,
              output mem_signed_ext,
              output pc_src,
              output pc_reg_src,
              output write_pc,
              output write_mem,
              output write_reg,
              output write_reg_mux,
              output [3:0] mem_wea,
              output [2:0] mem_len,
              output [31:0] pc_imm,
              output [31:0] imm_data,
              output [37:0] debug_inst);

assign rs1       = inst[19:15];
assign rs2       = inst[24:20];
assign rd        = inst[11:7];

wire [6:0] op;
wire [2:0] func_3;
wire [6:0] func_7;
wire [11:0] imm_11_0;
wire [11:0] imm_11_5_4_0;
wire [19:0] imm_31_12;

assign op           = inst[6:0];
assign rd           = inst[11:7];
assign func_3       = inst[14:12];
assign func_7       = inst[31:25];
assign imm_11_0     = inst[31:20];
assign imm_11_5_4_0 = {inst[31:25], inst[11:7]};
assign imm_31_12    = inst[31:12];

//U
wire inst_lui;
wire inst_auipc;
//J
wire inst_jal;
wire inst_jalr;
//B
wire inst_beq;
wire inst_bne;
wire inst_blt;
wire inst_bge;
wire inst_bltu;
wire inst_bgeu;
//I
wire inst_lb;
wire inst_lh;
wire inst_lw;
wire inst_lbu;
wire inst_lhu;
//S
wire inst_sb;
wire inst_sh;
wire inst_sw;
//I
wire inst_addi;
wire inst_slti;
wire inst_sltiu;
wire inst_xori;
wire inst_ori;
wire inst_andi;
wire inst_slli;
wire inst_srli;
wire inst_srai;
//R
wire inst_add;
wire inst_sub;
wire inst_sll;
wire inst_slt;
wire inst_sltu;
wire inst_xor;
wire inst_srl;
wire inst_sra;
wire inst_or;
wire inst_and;
//USER DEFINE
wire inst_usr;

assign debug_inst = {inst_lui   , inst_auipc   ,
inst_jal   , inst_jalr    ,
inst_beq   , inst_bne     , inst_blt   , inst_bge    , inst_bltu  ,  inst_bgeu ,
inst_lb    , inst_lh      , inst_lw    , inst_lbu    , inst_lhu   ,
inst_sb    , inst_sh      , inst_sw    ,
inst_addi  , inst_slti    , inst_sltiu , inst_xori   , inst_ori   , inst_andi  , inst_slli  , inst_srli   , inst_srai   ,
inst_add   , inst_sub     , inst_sll   , inst_slt    , inst_sltu  , inst_xor   , inst_srl   , inst_sra    , inst_or      , inst_and, inst_usr};

assign inst_lui   = op == 7'b0110111;
assign inst_auipc = op == 7'b0010111;

assign inst_jal  = op == 7'b1101111;
assign inst_jalr = op == 7'b1100111;

assign inst_beq  = op == 7'b1100011 && func_3 == 3'b000;
assign inst_bne  = op == 7'b1100011 && func_3 == 3'b001;
assign inst_blt  = op == 7'b1100011 && func_3 == 3'b100;
assign inst_bge  = op == 7'b1100011 && func_3 == 3'b101;
assign inst_bltu = op == 7'b1100011 && func_3 == 3'b110;
assign inst_bgeu = op == 7'b1100011 && func_3 == 3'b111;

assign inst_lb  = op == 7'b0000011 && func_3 == 3'b000;
assign inst_lh  = op == 7'b0000011 && func_3 == 3'b001;
assign inst_lw  = op == 7'b0000011 && func_3 == 3'b010;
assign inst_lbu = op == 7'b0000011 && func_3 == 3'b100;
assign inst_lhu = op == 7'b0000011 && func_3 == 3'b101;

assign inst_sb = op == 7'b0100011 && func_3 == 3'b000;
assign inst_sh = op == 7'b0100011 && func_3 == 3'b001;
assign inst_sw = op == 7'b0100011 && func_3 == 3'b010;

assign inst_addi  = op == 7'b0010011 && func_3 == 3'b000;
assign inst_slti  = op == 7'b0010011 && func_3 == 3'b010;
assign inst_sltiu = op == 7'b0010011 && func_3 == 3'b011;
assign inst_xori  = op == 7'b0010011 && func_3 == 3'b100;
assign inst_ori   = op == 7'b0010011 && func_3 == 3'b110;
assign inst_andi  = op == 7'b0010011 && func_3 == 3'b111;
assign inst_slli  = op == 7'b0010011 && func_3 == 3'b001 && func_7 == 7'b0000000;
assign inst_srli  = op == 7'b0010011 && func_3 == 3'b101 && func_7 == 7'b0000000;
assign inst_srai  = op == 7'b0010011 && func_3 == 3'b101 && func_7 == 7'b0100000;

assign inst_add  = op == 7'b0110011 && func_3 == 3'b000 && func_7 == 7'b0000000;
assign inst_sub  = op == 7'b0110011 && func_3 == 3'b000 && func_7 == 7'b0100000;
assign inst_sll  = op == 7'b0110011 && func_3 == 3'b001 && func_7 == 7'b0000000;
assign inst_slt  = op == 7'b0110011 && func_3 == 3'b010 && func_7 == 7'b0000000;
assign inst_sltu = op == 7'b0110011 && func_3 == 3'b011 && func_7 == 7'b0000000;
assign inst_xor  = op == 7'b0110011 && func_3 == 3'b100 && func_7 == 7'b0000000;
assign inst_srl  = op == 7'b0110011 && func_3 == 3'b101 && func_7 == 7'b0000000;
assign inst_sra  = op == 7'b0110011 && func_3 == 3'b101 && func_7 == 7'b0100000;
assign inst_or   = op == 7'b0110011 && func_3 == 3'b110 && func_7 == 7'b0000000;
assign inst_and  = op == 7'b0110011 && func_3 == 3'b111 && func_7 == 7'b0000000;

assign inst_usr = op == 7'b1111111;

// ALU operation
wire alu_lui   = inst_lui;
wire alu_auipc = inst_auipc;
wire alu_jal   = inst_jal;
wire alu_jalr  = inst_jalr;
wire alu_beq   = inst_beq;
wire alu_bne   = inst_bne;
wire alu_blt   = inst_blt;
wire alu_bge   = inst_bge;
wire alu_bltu  = inst_bltu;
wire alu_bgeu  = inst_bgeu;
wire alu_add   = inst_add | inst_addi | inst_sb | inst_sh | inst_sw |inst_lb | inst_lh | inst_lw | inst_lbu | inst_lhu;
wire alu_sub   = inst_sub;
wire alu_sll   = inst_sll | inst_slli;
wire alu_sra   = inst_sra | inst_srai;
wire alu_srl   = inst_srl | inst_srli;
wire alu_slt   = inst_slt | inst_slti;
wire alu_sltu  = inst_sltu | inst_sltiu;
wire alu_xor   = inst_xor | inst_xori;
wire alu_or    = inst_or | inst_ori;
wire alu_and   = inst_and | inst_andi;

assign inst_opcode = {alu_lui , alu_auipc , alu_jal , alu_jalr , alu_beq , alu_bne , alu_blt , alu_bge , alu_bltu , alu_bgeu , alu_add , alu_sub , alu_sll , alu_sra , alu_srl , alu_slt , alu_sltu , alu_xor , alu_or , alu_and};

assign reg_src = inst_add | inst_sub | inst_sll | inst_sra | inst_srl | inst_slt | inst_sltu | inst_xor | inst_or | inst_and | inst_beq |inst_bne |inst_blt |inst_bge |inst_bltu | inst_bgeu;

wire signed_ext = inst_sb | inst_sh | inst_sw | inst_lb | inst_lh | inst_lw | inst_lbu | inst_lhu | inst_addi  | inst_slti | inst_sltiu | inst_xori   | inst_ori   | inst_andi | inst_slli  | inst_srli | inst_srai;

wire imm_11_0_ena     = inst_slli | inst_srai | inst_srli | inst_slti | inst_sltiu | inst_xori | inst_ori | inst_andi | inst_addi |
inst_lb | inst_lh | inst_lw | inst_lbu | inst_lhu;
wire imm_11_5_4_0_ena = inst_sb | inst_sh | inst_sw;
wire imm_31_12_ena = inst_lui | inst_auipc;
// wire

assign imm_data = reg_src ? 32'd0 :
imm_11_0_ena ? signed_ext ? {{20{imm_11_0[11]}},imm_11_0}:{20'd0,imm_11_0}:
imm_31_12_ena ? {imm_31_12,12'd0}:
imm_11_5_4_0_ena ? signed_ext ? {{20{imm_11_5_4_0[11]}},imm_11_5_4_0} : {20'd0,imm_11_5_4_0}:

32'd0;

// write back operation
// ~S
assign write_reg_mux = inst_addi  | inst_slti    | inst_sltiu | inst_xori   | inst_ori   | inst_andi  | inst_slli  | inst_srli   | inst_srai |
inst_add | inst_sub | inst_sll | inst_sra | inst_srl | inst_slt | inst_sltu | inst_xor | inst_or | inst_and | 
inst_jal | inst_jalr |
inst_lui | inst_auipc;
// R I U I-L
assign write_reg = inst_addi | inst_slti | inst_sltiu | inst_xori | inst_ori | inst_andi | inst_slli | inst_srli | inst_srai | 
inst_add | inst_sub | inst_sll | inst_slt | inst_sltu  | inst_xor | inst_srl | inst_sra | inst_or | inst_and | 
inst_lb | inst_lh | inst_lw | inst_lbu | inst_lhu | 
inst_jal | inst_jalr |
inst_lui | inst_auipc;
// S
assign write_mem = inst_sb | inst_sh | inst_sw;
assign mem_len = {(inst_sw|inst_lw), (inst_sh|inst_lh|inst_lhu),(inst_sb|inst_lb|inst_lbu)};
assign mem_signed_ext = inst_lb | inst_lh | inst_lw;
assign mem_wea = inst_sw ? 4'b1111 :
                inst_sh ? 4'b0011 :
                inst_sb ? 4'b0001 :4'b0000
;

// branch operation
assign pc_src = inst_jal | inst_jalr | inst_auipc;
assign write_pc = inst_jal | inst_jalr | inst_beq | inst_bne | inst_blt | inst_bge | inst_bltu | inst_bgeu;
assign pc_imm = inst_jalr ? {{20{imm_11_0}},imm_11_0} : inst_jal ?{{(12){inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0} : {{(19){inst[31]}},{inst[31],inst[7],inst[30:25],inst[11:8]},1'b0};
assign pc_reg_src = inst_jalr;




endmodule
