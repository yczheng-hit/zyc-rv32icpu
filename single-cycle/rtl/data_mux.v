module data_mux (
    input wire [31:0]data_in1,
    input wire [31:0]data_in0,
    input wire mux,
    output wire [31:0] data_out
);
    
assign data_out = mux ? data_in1 : data_in0;



endmodule
