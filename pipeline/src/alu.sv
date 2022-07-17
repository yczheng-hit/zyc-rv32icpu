module alu (input logic [19:0] inst_opcode,
            input logic [31:0] op1,
            input logic [31:0] op2,
            output logic alu_jmp,
            output logic [31:0] alu_out);

logic signed [31:0] signed_op1 = op1;
logic signed [31:0] signed_op2 = op2;

logic [31:0] signed_bit;
logic alu_lui   = inst_opcode[19];
logic alu_auipc = inst_opcode[18];
logic alu_jal   = inst_opcode[17];
logic alu_jalr  = inst_opcode[16];
logic alu_beq   = inst_opcode[15];
logic alu_bne   = inst_opcode[14];
logic alu_blt   = inst_opcode[13];
logic alu_bge   = inst_opcode[12];
logic alu_bltu  = inst_opcode[11];
logic alu_bgeu  = inst_opcode[10];
logic alu_add   = inst_opcode[9];
logic alu_sub   = inst_opcode[8];
logic alu_sll   = inst_opcode[7];
logic alu_sra   = inst_opcode[6];
logic alu_srl   = inst_opcode[5];
logic alu_slt   = inst_opcode[4];
logic alu_sltu  = inst_opcode[3];
logic alu_xor   = inst_opcode[2];
logic alu_or    = inst_opcode[1];
logic alu_and   = inst_opcode[0];
assign signed_bit = {32{op1[31]}};

always_comb begin
    alu_out = 32'd0;
    alu_jmp = 1'b0;
    case (1'b1)
        alu_lui: alu_out = {op2[31:12],12'd0};
        alu_auipc: alu_out = op1 + op2;
        alu_jal: begin alu_out = op1 + 32'd4; alu_jmp = 1'b1; end
        alu_jalr: begin alu_out = op1 + 32'd4; alu_jmp = 1'b1; end 
        alu_beq: alu_jmp = op1 == op2;
        alu_bne: alu_jmp = op1 != op2;
        alu_blt: alu_jmp = signed_op1 < signed_op2;
        alu_bge: alu_jmp = signed_op1 >= signed_op2;
        alu_bltu:alu_jmp = op1 < op2;
        alu_bgeu:alu_jmp = op1 >= op2;
        alu_add: alu_out = op1 + op2;
        alu_sub: alu_out = op1 - op2;
        alu_sll: alu_out = op1 << op2;
        alu_sra: alu_out = op1[31] ? (signed_bit) << (32 - op2) | (op1 >> op2): op1 >> op2;
        alu_srl: alu_out = op1 >> op2;
        alu_slt: alu_out = signed_op1 < signed_op2 ? 1'b1 : 1'b0;
        alu_sltu: alu_out = op1 < op2 ? 1'b1 : 1'b0;
        alu_xor: alu_out = op1 ^ op2;
        alu_or: alu_out = op1 | op2;
        alu_and: alu_out = op1 & op2;
        default: alu_out = 32'hffff_ffff;
    endcase
end



endmodule
