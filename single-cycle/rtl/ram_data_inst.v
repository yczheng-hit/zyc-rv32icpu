module ram_data_inst #(parameter ADDR_WIDTH = 17)
                  (input clk,
                   input [ADDR_WIDTH-1:0] raddr,
                   input [ADDR_WIDTH-1:0] waddr,
                   input [31:0] wdata,
                   input [3:0] wea,
                   output reg [31:0] rdata);
    
    reg [7:0] mem [(2**ADDR_WIDTH-1):0];
    initial begin
        $readmemh("./image.hex",mem);
    end
    always@(negedge clk) begin
        if (wea[0]) mem[waddr] <= wdata[7:0];
    end
    always@(negedge clk) begin
        if (wea[1]) mem[waddr+1] <= wdata[15:8];
    end
    always@(negedge clk) begin
        if (wea[2]) mem[waddr+2] <= wdata[23:16];
    end
    always@(negedge clk) begin
        if (wea[3]) mem[waddr+3]<= wdata[31:24];
    end
    
    always@(negedge clk) begin
        rdata <= {mem[raddr+3],mem[raddr+2],mem[raddr+1],mem[raddr]};
    end
    
endmodule

