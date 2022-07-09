module pc(input clk,
          input rst_n,
          input pc_mux,
          input [31:0] pc_dest,
          output reg[31:0] pc_cur,
          output reg[31:0] pc_next);
    
    
    always@(*)
    begin
        case(pc_mux)  
            1'b0:   pc_next   = pc_cur + 4;
            1'b1:   pc_next   = pc_dest;
            default:  pc_next = pc_cur + 4;
        endcase
    end
    
    always@(posedge clk or posedge rst_n)
    begin
        if (!rst_n) begin
            pc_cur  <= 32'd0;
        end
        else
            pc_cur <= pc_next;
    end
    
endmodule
