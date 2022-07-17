module data_mux (
    input logic [31:0]data_in1,
    input logic [31:0]data_in0,
    input logic mux,
    output logic [31:0] data_out
);
    
assign data_out = mux ? data_in1 : data_in0;



endmodule
