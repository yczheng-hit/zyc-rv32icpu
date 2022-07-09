`include "define.v"
module alu (input wire [19:0] inst_opcode,
            input wire [31:0] op1,
            input wire [31:0] op2,
            output reg alu_jmp,
            output reg [31:0] out);

wire signed [31:0] signed_op1 = op1;
wire signed [31:0] signed_op2 = op2;

wire [31:0] signed_bit;
assign signed_bit = {32{op1[31]}};
always @(*) begin
    out = 32'd0;
    alu_jmp = 1'b0;
    case (inst_opcode)
        `ALU_LUI: out = {op2[31:12],op1[11:0]};
        `ALU_AUIPC: out = op1 + op2;
        `ALU_JAL: begin out = op1 + 32'd4; alu_jmp = 1'b1; end
        `ALU_JALR: begin out = op1 + 32'd4; alu_jmp = 1'b1; end 
        `ALU_BEQ: alu_jmp = op1 == op2;
        `ALU_BNE: alu_jmp = op1 != op2;
        `ALU_BLT: alu_jmp = signed_op1 < signed_op2;
        `ALU_BGE: alu_jmp = signed_op1 >= signed_op2;
        `ALU_BLTU:alu_jmp = op1 < op2;
        `ALU_BGEU:alu_jmp = op1 >= op2;
        `ALU_ADD: out = op1 + op2;
        `ALU_SUB: out = op1 - op2;
        `ALU_SLL: out = op1 << op2;
        `ALU_SRA: out = op1[31] ? (signed_bit) << (32 - op2) | (op1 >> op2): op1 >> op2;
        `ALU_SRL: out = op1 >> op2;
        `ALU_SLT: out = signed_op1 < signed_op2 ? 1'b1 : 1'b0;
        `ALU_SLTU: out = op1 < op2 ? 1'b1 : 1'b0;
        `ALU_XOR: out = op1 ^ op2;
        `ALU_OR: out = op1 | op2;
        `ALU_AND: out = op1 & op2;
        default: out = 32'hffff_ffff;
    endcase
end



endmodule
