module debug(
    input logic clk,
    input logic [37:0] debug_inst,
    input logic debug_write_reg,
    input logic [31:0] debug_reg_data,
    input logic [4:0] debug_reg_id,
    input logic debug_write_mem,
    input logic [31:0] debug_mem_data,
    input logic [31:0] debug_mem_addr,
    input logic [31:0] debug_pc_cur
);
import dbg_pkg::*;
import "DPI-C" function void data_syn(input debug_st x) ;


debug_st dbg;

    always_comb begin
        dbg.op_type = {debug_write_mem,debug_write_reg};
        dbg.pc_cur = debug_pc_cur;
        dbg.mem_addr = debug_mem_addr;
        dbg.mem_data = debug_mem_data;
        dbg.reg_id = debug_reg_id;
        dbg.reg_data = debug_reg_data;
        dbg.debug_inst_h = {{26{1'b0}},debug_inst[37:32]};
        dbg.debug_inst_l = {debug_inst[31:0]};
    end
    
    always_ff @(posedge clk) begin
        if(debug_write_reg||debug_write_mem)
            data_syn(dbg);
    end
       


endmodule
