package dbg_pkg;
import cpu_pkg::*;

typedef struct{
    logic [31:0]op_type;
    logic [31:0]mem_addr;
    logic [31:0]mem_data;
    logic [31:0]reg_id;
    logic [31:0]reg_data;
    logic [31:0]debug_inst_h;
    logic [31:0]debug_inst_l;
    logic [31:0]pc_cur;
} debug_st;




endpackage
