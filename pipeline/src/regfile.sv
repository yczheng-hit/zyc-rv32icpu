module regfile(input logic clk,
               input logic wen,
               input logic [4 :0] raddr1,
               input logic [4 :0] raddr2,
               input logic [4 :0] waddr,
               input logic [4 :0] debug_raddr,
               input logic [31:0] wdata,
               output logic [31:0] rdata1,
               output logic [31:0] rdata2,
               output logic [31:0] debug_reg);
    integer i = 0;
    reg [31:0] regs[31:0];

    // end
    always_ff @ (posedge clk)
    begin
        if (wen && waddr!=5'd0) begin
            regs[waddr] <= wdata;
        end
    end
    
    assign rdata1 = regs[raddr1];
    assign rdata2 = regs[raddr2];
    assign debug_reg = regs[debug_raddr];
endmodule
    
