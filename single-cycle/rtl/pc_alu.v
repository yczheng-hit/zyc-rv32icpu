module pc_alu (
    input [31:0] pc_cur,
    input [31:0] pc_imm,
    output [31:0] pc_next
);

assign pc_next = pc_cur + pc_imm;
    
endmodule

