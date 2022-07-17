`include "define.v"
module alu (input wire [19:0] inst_opcode,
            input wire [31:0] op1,
            input wire [31:0] op2,
            output reg alu_jmp,
            output reg [31:0] out);

wire signed [31:0] signed_op1 = op1;
wire signed [31:0] signed_op2 = op2;

wire [31:0] signed_bit;
wire alu_lui   = inst_opcode[19];
wire alu_auipc = inst_opcode[18];
wire alu_jal   = inst_opcode[17];
wire alu_jalr  = inst_opcode[16];
wire alu_beq   = inst_opcode[15];
wire alu_bne   = inst_opcode[14];
wire alu_blt   = inst_opcode[13];
wire alu_bge   = inst_opcode[12];
wire alu_bltu  = inst_opcode[11];
wire alu_bgeu  = inst_opcode[10];
wire alu_add   = inst_opcode[9];
wire alu_sub   = inst_opcode[8];
wire alu_sll   = inst_opcode[7];
wire alu_sra   = inst_opcode[6];
wire alu_srl   = inst_opcode[5];
wire alu_slt   = inst_opcode[4];
wire alu_sltu  = inst_opcode[3];
wire alu_xor   = inst_opcode[2];
wire alu_or    = inst_opcode[1];
wire alu_and   = inst_opcode[0];
assign signed_bit = {32{op1[31]}};

always @(*) begin
    out = 32'd0;
    alu_jmp = 1'b0;
    case (1'b1)
        alu_lui: out = {op2[31:12],op1[11:0]};
        alu_auipc: out = op1 + op2;
        alu_jal: begin out = op1 + 32'd4; alu_jmp = 1'b1; end
        alu_jalr: begin out = op1 + 32'd4; alu_jmp = 1'b1; end 
        alu_beq: alu_jmp = op1 == op2;
        alu_bne: alu_jmp = op1 != op2;
        alu_blt: alu_jmp = signed_op1 < signed_op2;
        alu_bge: alu_jmp = signed_op1 >= signed_op2;
        alu_bltu:alu_jmp = op1 < op2;
        alu_bgeu:alu_jmp = op1 >= op2;
        alu_add: out = op1 + op2;
        alu_sub: out = op1 - op2;
        alu_sll: out = op1 << op2;
        alu_sra: out = op1[31] ? (signed_bit) << (32 - op2) | (op1 >> op2): op1 >> op2;
        alu_srl: out = op1 >> op2;
        alu_slt: out = signed_op1 < signed_op2 ? 1'b1 : 1'b0;
        alu_sltu: out = op1 < op2 ? 1'b1 : 1'b0;
        alu_xor: out = op1 ^ op2;
        alu_or: out = op1 | op2;
        alu_and: out = op1 & op2;
        default: out = 32'hffff_ffff;
    endcase
end



endmodule
