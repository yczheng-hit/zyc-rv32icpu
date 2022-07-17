module pc (
    input logic  clk,
    input logic  rst_n,
    input logic  pc_en,
    input logic  [31:0] pc_dest,
    output logic [31:0] pc_cur
);

    always_ff @(posedge clk or negedge rst_n) 
        if(!rst_n)
            pc_cur <= 32'hFFFF_FFFC;
        else begin
            if(pc_en)
                pc_cur <= pc_dest;
        end

endmodule
