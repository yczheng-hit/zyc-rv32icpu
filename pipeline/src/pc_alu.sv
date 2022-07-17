module pc_alu (
    input logic [31:0] pc_cur,
    input logic [31:0] pc_imm,
    output logic [31:0] pc_next
);

assign pc_next = pc_cur + pc_imm;
    
endmodule

