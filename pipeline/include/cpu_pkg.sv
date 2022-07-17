package cpu_pkg;
    
parameter DATA_WIDTH = 32;

// pipeline
// typedef struct packed {
//     logic [31:0]inst;
//     logic [31:0]pc_cur;
// } fetch_to_decode_st;

typedef struct packed {
    logic [4:0]rd;
    logic reg_src;
    logic pc_src;
    logic write_reg;
    logic [19:0]inst_opcode;
    logic [31:0]rdata1;
    logic [31:0]rdata2;
    logic [31:0]imm_data;
    logic [31:0]pc_cur;
    logic [31:0]pc_dest;
    logic [37:0]inst_type;
    logic write_reg_mux;
    logic mem_signed_ext;
    logic [3:0]mem_wea;
    logic [2:0]mem_len;
} decode_to_execute_st;

typedef struct packed {
    logic [4:0]rd;
    logic write_reg;
    logic [31:0]alu_out;
    logic [31:0]rdata2;
    logic [31:0]pc_cur;
    logic [37:0]inst_type;
    logic write_reg_mux;
    logic mem_signed_ext;
    logic [3:0]mem_wea;
    logic [2:0]mem_len;
} execute_to_mem_st;

typedef struct packed {
    logic [4:0]rd;
    logic write_reg;
    logic [31:0]alu_out;
    logic [31:0]rdata2;
    logic [31:0]pc_cur;
    logic [37:0]inst_type;
    logic [3:0]mem_wea;
    logic [31:0]mem_waddr;
    logic [31:0]mem_wdata;
} mem_to_reg_st;


// control

typedef struct packed {
    // auipc
    logic pc_src;
    // jalr
    logic pc_reg_src;
    // imm
    logic reg_src;
    logic imm_signed;
    logic signed_ext;
    // reg
    logic write_reg;
    // mem
    logic write_reg_mux;
    logic mem_signed_ext;
    logic [3:0]mem_wea;
    logic [2:0]mem_len;
} decode_control_st;

typedef struct packed {
    logic stall_all;
    logic pc_en;
    logic fetch_to_decode_en;
    logic decode_to_execute_en;
    logic execute_to_mem_en;
    logic mem_to_reg_en;
    logic nop;
    logic data_hazard;
} global_control_st;





endpackage
