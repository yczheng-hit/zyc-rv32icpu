module mem_ext (
    input wire [31:0]data_in,
    input wire [2:0]mem_len,
    input wire mem_signed_ext,
    output wire [31:0] data_out
);
    
assign data_out = mem_len & 3'b100 ? data_in : 
                mem_len & 3'b010 ? mem_signed_ext ? {{16{data_in[15]}},data_in[15:0]} : {16'd0,data_in[15:0]}:
                mem_len & 3'b001 ? mem_signed_ext ? {{24{data_in[7]}},data_in[7:0]} : {24'd0,data_in[7:0]} :
                 31'd0;



endmodule
