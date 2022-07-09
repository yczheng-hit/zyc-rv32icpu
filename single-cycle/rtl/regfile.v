`timescale 1ns / 1ps

module regfile(input clk,
               input wen,
               input [4 :0] raddr1,
               input [4 :0] raddr2,
               input [4 :0] waddr,
               input [4 :0] debug_raddr,
               input [31:0] wdata,
               output [31:0] rdata1,
               output [31:0] rdata2,
               output [31:0] debug_reg);
    //总共32个寄存器
    integer i = 0;
    reg [31:0] regs[31:0];
    // initial begin
    //     for(i = 0;i < 32;i = i + 1)
    //         regs[i] <= 0;
        
    // end
    always @ (posedge clk)
    begin
        if (wen && waddr!=5'd0) begin
            regs[waddr] <= wdata;
        end
    end
    
    assign rdata1 = regs[raddr1];
    assign rdata2 = regs[raddr2];
    assign debug_reg = regs[debug_raddr];
endmodule
    
