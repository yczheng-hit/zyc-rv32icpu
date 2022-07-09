module ram_inst #(parameter ADDR_WIDTH = 17)
                  (
                   input [ADDR_WIDTH-1:0] addr,
                   output reg [31:0] rdata);
    
    reg [7:0] memory [(2**ADDR_WIDTH-1):0];
    
    initial begin
        $readmemh("./image.hex",memory);
    end
    // always@(posedge clk) begin
    //     doutb <= memory[addr];
    // end

    always @(*) begin
      rdata = {memory[addr+3],memory[addr+2],memory[addr+1],memory[addr]};
    end
endmodule
