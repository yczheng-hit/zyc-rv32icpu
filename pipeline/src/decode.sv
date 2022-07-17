module decode
  import cpu_pkg::*;
(
    input logic [31:0] inst,
    output decode_control_st control,
    output logic [19:0] inst_opcode,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [4:0] rd,
    output logic [31:0] pc_imm,
    output logic [2:0] imm_type,
    output logic [37:0] inst_type
);

  logic mem_signed_ext;
  logic pc_src;
  logic write_pc;
  logic write_reg;
  logic write_reg_mux;
  logic [3:0] mem_wea;
  logic [2:0] mem_len;
  logic [31:0] imm_data;
  logic [6:0] op;
  logic [2:0] func_3;
  logic [6:0] func_7;

  
  //U
  logic inst_lui;
  logic inst_auipc;
  //J
  logic inst_jal;
  logic inst_jalr;
  //B
  logic inst_beq;
  logic inst_bne;
  logic inst_blt;
  logic inst_bge;
  logic inst_bltu;
  logic inst_bgeu;
  //I
  logic inst_lb;
  logic inst_lh;
  logic inst_lw;
  logic inst_lbu;
  logic inst_lhu;
  //S
  logic inst_sb;
  logic inst_sh;
  logic inst_sw;
  //I
  logic inst_addi;
  logic inst_slti;
  logic inst_sltiu;
  logic inst_xori;
  logic inst_ori;
  logic inst_andi;
  logic inst_slli;
  logic inst_srli;
  logic inst_srai;
  //R
  logic inst_add;
  logic inst_sub;
  logic inst_sll;
  logic inst_slt;
  logic inst_sltu;
  logic inst_xor;
  logic inst_srl;
  logic inst_sra;
  logic inst_or;
  logic inst_and;
  //USER DEFINE
  logic inst_usr;
  
  assign rs1 = inst[19:15];
  assign rs2 = inst[24:20];
  assign rd     = (inst_beq |inst_bne |inst_blt |inst_bge |inst_bltu | inst_bgeu)?5'd0:inst[11:7];
  assign op     = inst[6:0];
  assign func_3 = inst[14:12];
  assign func_7 = inst[31:25];

  assign inst_type = {
    inst_lui,
    inst_auipc,
    inst_jal,
    inst_jalr,
    inst_beq,
    inst_bne,
    inst_blt,
    inst_bge,
    inst_bltu,
    inst_bgeu,
    inst_lb,
    inst_lh,
    inst_lw,
    inst_lbu,
    inst_lhu,
    inst_sb,
    inst_sh,
    inst_sw,
    inst_addi,
    inst_slti,
    inst_sltiu,
    inst_xori,
    inst_ori,
    inst_andi,
    inst_slli,
    inst_srli,
    inst_srai,
    inst_add,
    inst_sub,
    inst_sll,
    inst_slt,
    inst_sltu,
    inst_xor,
    inst_srl,
    inst_sra,
    inst_or,
    inst_and,
    inst_usr
  };

  assign inst_lui = op == 7'b0110111;
  assign inst_auipc = op == 7'b0010111;

  assign inst_jal = op == 7'b1101111;
  assign inst_jalr = op == 7'b1100111;

  assign inst_beq = op == 7'b1100011 && func_3 == 3'b000;
  assign inst_bne = op == 7'b1100011 && func_3 == 3'b001;
  assign inst_blt = op == 7'b1100011 && func_3 == 3'b100;
  assign inst_bge = op == 7'b1100011 && func_3 == 3'b101;
  assign inst_bltu = op == 7'b1100011 && func_3 == 3'b110;
  assign inst_bgeu = op == 7'b1100011 && func_3 == 3'b111;

  assign inst_lb = op == 7'b0000011 && func_3 == 3'b000;
  assign inst_lh = op == 7'b0000011 && func_3 == 3'b001;
  assign inst_lw = op == 7'b0000011 && func_3 == 3'b010;
  assign inst_lbu = op == 7'b0000011 && func_3 == 3'b100;
  assign inst_lhu = op == 7'b0000011 && func_3 == 3'b101;

  assign inst_sb = op == 7'b0100011 && func_3 == 3'b000;
  assign inst_sh = op == 7'b0100011 && func_3 == 3'b001;
  assign inst_sw = op == 7'b0100011 && func_3 == 3'b010;

  assign inst_addi = op == 7'b0010011 && func_3 == 3'b000;
  assign inst_slti = op == 7'b0010011 && func_3 == 3'b010;
  assign inst_sltiu = op == 7'b0010011 && func_3 == 3'b011;
  assign inst_xori = op == 7'b0010011 && func_3 == 3'b100;
  assign inst_ori = op == 7'b0010011 && func_3 == 3'b110;
  assign inst_andi = op == 7'b0010011 && func_3 == 3'b111;
  assign inst_slli = op == 7'b0010011 && func_3 == 3'b001 && func_7 == 7'b0000000;
  assign inst_srli = op == 7'b0010011 && func_3 == 3'b101 && func_7 == 7'b0000000;
  assign inst_srai = op == 7'b0010011 && func_3 == 3'b101 && func_7 == 7'b0100000;

  assign inst_add = op == 7'b0110011 && func_3 == 3'b000 && func_7 == 7'b0000000;
  assign inst_sub = op == 7'b0110011 && func_3 == 3'b000 && func_7 == 7'b0100000;
  assign inst_sll = op == 7'b0110011 && func_3 == 3'b001 && func_7 == 7'b0000000;
  assign inst_slt = op == 7'b0110011 && func_3 == 3'b010 && func_7 == 7'b0000000;
  assign inst_sltu = op == 7'b0110011 && func_3 == 3'b011 && func_7 == 7'b0000000;
  assign inst_xor = op == 7'b0110011 && func_3 == 3'b100 && func_7 == 7'b0000000;
  assign inst_srl = op == 7'b0110011 && func_3 == 3'b101 && func_7 == 7'b0000000;
  assign inst_sra = op == 7'b0110011 && func_3 == 3'b101 && func_7 == 7'b0100000;
  assign inst_or = op == 7'b0110011 && func_3 == 3'b110 && func_7 == 7'b0000000;
  assign inst_and = op == 7'b0110011 && func_3 == 3'b111 && func_7 == 7'b0000000;

  assign inst_usr = op == 7'b1111111;

  // ALU operation
  logic alu_lui = inst_lui;
  logic alu_auipc = inst_auipc;
  logic alu_jal = inst_jal;
  logic alu_jalr = inst_jalr;
  logic alu_beq = inst_beq;
  logic alu_bne = inst_bne;
  logic alu_blt = inst_blt;
  logic alu_bge = inst_bge;
  logic alu_bltu = inst_bltu;
  logic alu_bgeu = inst_bgeu;
  logic alu_add   = inst_add | inst_addi | inst_sb | inst_sh | inst_sw |inst_lb | inst_lh | inst_lw | inst_lbu | inst_lhu;
  logic alu_sub = inst_sub;
  logic alu_sll = inst_sll | inst_slli;
  logic alu_sra = inst_sra | inst_srai;
  logic alu_srl = inst_srl | inst_srli;
  logic alu_slt = inst_slt | inst_slti;
  logic alu_sltu = inst_sltu | inst_sltiu;
  logic alu_xor = inst_xor | inst_xori;
  logic alu_or = inst_or | inst_ori;
  logic alu_and = inst_and | inst_andi;

  assign inst_opcode = {
    alu_lui,
    alu_auipc,
    alu_jal,
    alu_jalr,
    alu_beq,
    alu_bne,
    alu_blt,
    alu_bge,
    alu_bltu,
    alu_bgeu,
    alu_add,
    alu_sub,
    alu_sll,
    alu_sra,
    alu_srl,
    alu_slt,
    alu_sltu,
    alu_xor,
    alu_or,
    alu_and
  };

  assign control.reg_src = inst_add | inst_sub | inst_sll | inst_sra | inst_srl | inst_slt | inst_sltu | inst_xor | inst_or | inst_and | inst_beq |inst_bne |inst_blt |inst_bge |inst_bltu | inst_bgeu;

  assign control.imm_signed = inst_sb | inst_sh | inst_sw | inst_lb | inst_lh | inst_lw | inst_lbu | inst_lhu | inst_addi  | inst_slti | inst_sltiu | inst_xori   | inst_ori   | inst_andi | inst_slli  | inst_srli | inst_srai;

  logic imm_11_0_ena     = inst_slli | inst_srai | inst_srli | inst_slti | inst_sltiu | inst_xori | inst_ori | inst_andi | inst_addi |
inst_lb | inst_lh | inst_lw | inst_lbu | inst_lhu;
  logic imm_11_5_4_0_ena = inst_sb | inst_sh | inst_sw;
  logic imm_31_12_ena = inst_lui | inst_auipc;
  // logic


  assign imm_type = {imm_31_12_ena, imm_11_5_4_0_ena, imm_11_0_ena};

  // write back operation
  // ~S
  assign control.write_reg_mux = inst_addi  | inst_slti    | inst_sltiu | inst_xori   | inst_ori   | inst_andi  | inst_slli  | inst_srli   | inst_srai |
inst_add | inst_sub | inst_sll | inst_sra | inst_srl | inst_slt | inst_sltu | inst_xor | inst_or | inst_and | 
inst_jal | inst_jalr |
inst_lui | inst_auipc;
  // R I U I-L
  assign control.write_reg = inst_addi | inst_slti | inst_sltiu | inst_xori | inst_ori | inst_andi | inst_slli | inst_srli | inst_srai | 
inst_add | inst_sub | inst_sll | inst_slt | inst_sltu  | inst_xor | inst_srl | inst_sra | inst_or | inst_and | 
inst_lb | inst_lh | inst_lw | inst_lbu | inst_lhu | 
inst_jal | inst_jalr |
inst_lui | inst_auipc|
inst_beq |inst_bne |inst_blt |inst_bge |inst_bltu | inst_bgeu; //branch write rd 0
  // S
  assign control.mem_len = {
    (inst_sw | inst_lw), (inst_sh | inst_lh | inst_lhu), (inst_sb | inst_lb | inst_lbu)
  };
  assign control.mem_signed_ext = inst_lb | inst_lh | inst_lw;
  assign control.mem_wea = inst_sw ? 4'b1111 : inst_sh ? 4'b0011 : inst_sb ? 4'b0001 : 4'b0000;

  // branch operation
  assign control.pc_src = inst_jal | inst_jalr | inst_auipc;

  assign pc_imm = inst_jalr ? {{20{inst[31]}},inst[31:20]} : inst_jal ?{{(12){inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0} : {{(19){inst[31]}},{inst[31],inst[7],inst[30:25],inst[11:8]},1'b0};
  assign control.pc_reg_src = inst_jalr;




endmodule
