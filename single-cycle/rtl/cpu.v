module cpu (input clk,
            input rst_n,
            input wire [4:0] debug_raddr,
            output wire [31:0] debug_reg,
            output wire [31:0] debug_data,
            output wire [31:0] debug_addr,
            output wire [4:0] debug_write_reg_id,
            output wire debug_write_reg,
            output wire debug_write_mem,
            output wire debug_uart_en,
            output wire [31:0] debug_uart_data,
            output wire [31:0] pc_cur,
            output wire [37:0] debug_inst);
    
    // variable define
    // fetch
    wire [31:0] pc_alu_in;
    wire [31:0] pc_imm;
    wire [31:0] pc_reg;
    wire [31:0] pc_next;
    wire [31:0] pc_dest;
    wire [31:0] inst;
    
    // decode
    wire [19:0] inst_opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] shamt;
    wire [4:0] rd;
    wire write_reg;
    wire write_pc;
    wire write_mem;
    wire pc_src;
    wire pc_reg_src;
    wire [3:0] mem_wea;
    wire mem_signed_ext;
    
    wire[4:0]raddr1;
    wire[4:0]raddr2;
    wire[4:0]waddr;
    wire[31:0]wdata;
    wire[31:0]rdata1;
    wire[31:0]rdata2;
    
    wire [31:0] imm_data;
    wire reg_src;
    wire [31:0] data1_out;
    wire [31:0] data2_out;
    
    // execute
    wire [31:0] out;
    wire alu_jmp;
    
    // memory access
    wire [2:0] mem_len;
    wire [31:0] mem_in;
    wire [31:0] mem_out;
    wire [31:0] mem_out_inst;
    wire [31:0] mem_to_reg;
    wire write_reg_mux;
    wire [31:0] write_reg_out;
    
    // write back
    
    // debug
    assign debug_write_mem    = write_mem;
    assign debug_write_reg    = write_reg;
    assign debug_addr         = out;
    assign debug_data         = write_reg ? write_reg_out : mem_in;
    assign debug_write_reg_id = rd;
    
    // module instance
    always @(posedge clk) begin
        if (inst == 32'h7f) begin
            $finish;
        end
    end
    
    // fetch
    // assign pc_dest = 32'd0;
    
    pc_alu u_pc_alu(
    .pc_cur  (pc_alu_in),
    .pc_imm  (pc_imm),
    .pc_next (pc_dest)
    );
    
    assign pc_reg = rdata1;
    data_mux u_pc_reg_mux(
    .data_in1 (pc_reg),
    .data_in0 (pc_cur),
    .mux      (pc_reg_src),
    .data_out (pc_alu_in)
    );
    
    pc u_pc(
    .clk     (clk),
    .rst_n   (rst_n),
    .pc_mux  (alu_jmp),
    .pc_dest (pc_dest),
    .pc_cur  (pc_cur),
    .pc_next (pc_next)
    );
    ram_inst u_ram_inst(
    .addr  (pc_cur[16:0]),
    .rdata (inst)
    );
    
    // decode
    decode u_decode(
    .inst           (inst),
    .inst_opcode    (inst_opcode),
    .rs1            (rs1),
    .rs2            (rs2),
    .shamt          (shamt),
    .rd             (rd),
    .reg_src        (reg_src),
    .mem_signed_ext (mem_signed_ext),
    .pc_src         (pc_src),
    .pc_reg_src     (pc_reg_src),
    .write_pc       (write_pc),
    .write_mem      (write_mem),
    .write_reg      (write_reg),
    .write_reg_mux  (write_reg_mux),
    .mem_wea        (mem_wea),
    .mem_len        (mem_len),
    .pc_imm         (pc_imm),
    .imm_data       (imm_data),
    .debug_inst     (debug_inst)
    );
    
    regfile u_regfile(
    .clk         (clk),
    .wen         (write_reg),
    .raddr1      (rs1),
    .raddr2      (rs2),
    .waddr       (rd),
    .debug_raddr (debug_raddr),
    .wdata       (write_reg_out),
    .rdata1      (rdata1),
    .rdata2      (rdata2),
    .debug_reg   (debug_reg)
    );
    
    data_mux u_data_mux_0(
    .data_in1 (pc_cur),
    .data_in0 (rdata1),
    .mux  (pc_src),
    .data_out (data1_out)
    );
    
    data_mux u_data_mux_1(
    .data_in1   (rdata2),
    .data_in0   (imm_data),
    .mux    (reg_src),
    .data_out   (data2_out)
    );
    
    // execute
    alu u_alu(
    .inst_opcode (inst_opcode),
    .op1         (data1_out),
    .op2         (data2_out),
    .alu_jmp     (alu_jmp),
    .out         (out)
    );
    
    // memory access
    mem_ext u_mem_ext_0(
    .data_in        (rdata2),
    .mem_len        (mem_len),
    .mem_signed_ext (1'b0),
    .data_out       (mem_in)
    );
    
    ram_data u_ram_data(
    .clk   (clk),
    .raddr (out[16:0]),
    .waddr (out[16:0]),
    .wdata (mem_in),
    .wea   (mem_wea),
    .rdata (mem_out)
    );
    
    wire [31:0] tmp;
    ram_data_inst u_ram_instld(
    .clk   (clk),
    .raddr (out[16:0]),
    .waddr (out[16:0]),
    .wdata (tmp),
    .wea   (1'b0),
    .rdata (mem_out_inst)
    );
    
    assign debug_uart_en = (out == 32'h1000_0000) && mem_wea;
    assign debug_uart_data = debug_uart_en ? mem_in : 32'd0;

    mem_ext u_mem_ext_1(
    .data_in        ((out[31:24]<8'd1)? mem_out_inst : mem_out),
    .mem_len        (mem_len),
    .mem_signed_ext (mem_signed_ext),
    .data_out       (mem_to_reg)
    );
    
    // write back
    write_reg_mux u_write_reg_mux(
    .alu_out       (out),
    .mem_out       (mem_to_reg),
    .write_reg_mux (write_reg_mux),
    .write_reg_out (write_reg_out)
    );
    
endmodule
