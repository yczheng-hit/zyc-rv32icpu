module write_reg_mux (
    input [31:0] alu_out,
    input [31:0] mem_out,
    input write_reg_mux,
    output [31:0] write_reg_out
);
assign write_reg_out = write_reg_mux ? alu_out : mem_out;
    
endmodule
