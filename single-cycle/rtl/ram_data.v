module ram_data #(parameter ADDR_WIDTH = 17)
                  (input clk,
                   input [ADDR_WIDTH-1:0] raddr,
                   input [ADDR_WIDTH-1:0] waddr,
                   input [31:0] wdata,
                   input [3:0] wea,
                   output reg [31:0] rdata);
    
    reg [31:0] mem [(2**ADDR_WIDTH-1):0];
    
    always@(negedge clk) begin
        if (wea[0]) mem[waddr][7:0] <= wdata[7:0];
    end
    always@(negedge clk) begin
        if (wea[1]) mem[waddr][15:8] <= wdata[15:8];
    end
    always@(negedge clk) begin
        if (wea[2]) mem[waddr][23:16] <= wdata[23:16];
    end
    always@(negedge clk) begin
        if (wea[3]) mem[waddr][31:24] <= wdata[31:24];
    end
    
    always@(negedge clk) begin
        rdata <= mem[raddr];
    end
    
endmodule

