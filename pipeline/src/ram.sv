module ram #(
    parameter ADDR_WIDTH = 17
) (
    input logic clk,
    input logic rst_n,
    input logic [31:0] raddr1,
    input logic [31:0] raddr2,
    input logic [31:0] waddr,
    input logic [31:0] wdata,
    input logic [3:0] wea,
    output logic [31:0] rdata1,
    output logic [31:0] rdata2
);
//   logic [31:0] tmpr1 = raddr1[ADDR_WIDTH-1:0];
//   logic [31:0] tmpr2 = raddr2[ADDR_WIDTH-1:0];
//   logic [31:0] tmpw = waddr[ADDR_WIDTH-1:0];
    import "DPI-C" function void virtual_uart(input int x);

  reg [7:0] mem_inst[(2**ADDR_WIDTH-1):0];
  reg [7:0] mem_data[(2**ADDR_WIDTH-1):0];
  initial begin
    $readmemh("./image.hex", mem_inst);
  end

    always @(negedge clk) begin
      if (wea[0]&&waddr[31:24] > 8'h10)
        mem_data[waddr[ADDR_WIDTH-1:0]] <= wdata[7:0];
    end
    always @(negedge clk) begin
      if (wea[1]&&waddr[31:24] > 8'h10)
        mem_data[waddr[ADDR_WIDTH-1:0]+1] <= wdata[15:8];
    end
    always @(negedge clk) begin
      if (wea[2]&&waddr[31:24] > 8'h10)
        mem_data[waddr[ADDR_WIDTH-1:0]+2] <= wdata[23:16];
    end
    always @(negedge clk) begin
      if (wea[3]&&waddr[31:24] > 8'h10)
        mem_data[waddr[ADDR_WIDTH-1:0]+3] <= wdata[31:24];
    end
// a bit dirty
  always_ff @(negedge clk)
    if(waddr[31:24] == 8'h10) begin
        virtual_uart(wdata);
    end

  always_ff @(negedge clk or negedge rst_n) begin
    if (!rst_n) rdata1 <= 32'd0;
    else begin
      if (raddr1[31:24] == 8'd0)
        rdata1 <= {
          mem_inst[raddr1[ADDR_WIDTH-1:0]+3],
          mem_inst[raddr1[ADDR_WIDTH-1:0]+2],
          mem_inst[raddr1[ADDR_WIDTH-1:0]+1],
          mem_inst[raddr1[ADDR_WIDTH-1:0]]
        };
      else
        rdata1 <= {
          mem_data[raddr1[ADDR_WIDTH-1:0]+3],
          mem_data[raddr1[ADDR_WIDTH-1:0]+2],
          mem_data[raddr1[ADDR_WIDTH-1:0]+1],
          mem_data[raddr1[ADDR_WIDTH-1:0]]
        };
    end
  end

  always_ff @(negedge clk or negedge rst_n) begin
    if (!rst_n) rdata2 <= 32'd0;
    else begin
      if (raddr2[31:24] == 8'd0)
        rdata2 <= {
          mem_inst[raddr2[ADDR_WIDTH-1:0]+3],
          mem_inst[raddr2[ADDR_WIDTH-1:0]+2],
          mem_inst[raddr2[ADDR_WIDTH-1:0]+1],
          mem_inst[raddr2[ADDR_WIDTH-1:0]]
        };
      else
        rdata2 <= {
          mem_data[raddr2[ADDR_WIDTH-1:0]+3],
          mem_data[raddr2[ADDR_WIDTH-1:0]+2],
          mem_data[raddr2[ADDR_WIDTH-1:0]+1],
          mem_data[raddr2[ADDR_WIDTH-1:0]]
        };
    end
  end

endmodule

