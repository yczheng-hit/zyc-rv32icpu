module imm_ext(input logic [31 :0] inst,
               input logic imm_signed,
               input logic [2 :0] imm_type,
               output logic [31:0] imm_data);

    logic [11:0] imm_11_0;
    logic [11:0] imm_11_5_4_0;
    logic [19:0] imm_31_12;

    logic imm_31_12_ena    = imm_type[2];
    logic imm_11_5_4_0_ena = imm_type[1];
    logic imm_11_0_ena     = imm_type[0];

    assign imm_11_0     = inst[31:20];
    assign imm_11_5_4_0 = {inst[31:25], inst[11:7]};
    assign imm_31_12    = inst[31:12];

    // assign imm_data = imm_11_0_ena ? imm_signed ? {{20{imm_11_0[11]}},imm_11_0}:{20'd0,imm_11_0}:
    // imm_31_12_ena ? {imm_31_12,12'd0}:
    // imm_11_5_4_0_ena ? imm_signed ? {{20{imm_11_5_4_0[11]}},imm_11_5_4_0} : {20'd0,imm_11_5_4_0}:
    // 32'd0;
    
    always_comb begin
        unique case (1'b1)
            imm_31_12_ena: imm_data = {imm_31_12,12'd0};
            imm_11_5_4_0_ena: imm_data = imm_signed ? {{20{imm_11_5_4_0[11]}},imm_11_5_4_0} : {20'd0,imm_11_5_4_0};
            imm_11_0_ena: imm_data = imm_signed ? {{20{imm_11_0[11]}},imm_11_0}:{20'd0,imm_11_0};
        endcase
    end

endmodule
