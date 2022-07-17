module cpu (
    input logic clk,
    input logic rst_n,
    input logic [31:0] debug_raddr,
    output logic [31:0] debug_reg,
    output logic [31:0] pc_cur
);

  import cpu_pkg::*;

  // variable define
  // global control
  /* verilator lint_off UNOPTFLAT */
  global_control_st global_control;

  // fetch
  logic [31:0] pc_dest;

  // fetch to decode
  // fetch_to_decode_st fetch_to_decode;

  // decode
  logic [19:0] inst_opcode;
  logic [31:0] inst;
  logic [4:0] rs1;
  logic [4:0] rs2;
  logic [4:0] rd;
  logic [31:0] rdata1;
  logic [31:0] rdata2;
  decode_control_st decode_control;

  logic [31:0] pc_imm;
  logic [31:0] pc_reg;
  logic [31:0] pc_mux_out;
  logic [31:0] pc_alu_out;
  logic [2:0] imm_type;
  logic [31:0] imm_data;
  logic [37:0] inst_type;

  // decode to execute
  decode_to_execute_st decode_to_execute;

  // execute
  logic alu_jmp;
  logic [31:0] alu_out;
  logic [31:0] alu_op1;
  logic [31:0] alu_op2;

  // execute to memory access
  execute_to_mem_st execute_to_mem;

  // memory access
  logic [31:0] mem_rdata;
  logic [31:0] mem_raddr;
  logic [31:0] mem_wdata;
  logic [31:0] mem_waddr;
  logic [3:0] mem_wea;

  // memory access to write back
  mem_to_reg_st mem_to_reg;
  logic [31:0] mem_ext_0_out;
  logic [31:0] mem_ext_1_out;
  logic [31:0] write_reg_mux_out;

  // write back
  logic [31:0] reg_wdata;
  logic reg_wen;


  // debug module
  logic [37:0] debug_inst;
  logic debug_write_reg;
  logic [31:0] debug_reg_data;
  logic [4:0] debug_reg_id;
  logic debug_write_mem;
  logic [31:0] debug_mem_data;
  logic [31:0] debug_mem_addr;
  logic [31:0] debug_pc_cur;


  // module instance
  // user instruction debug
  always_comb begin
    if (debug_inst == 37'h01) begin
      $finish;
    end
  end

  // control module
  always_comb begin
    global_control.pc_en = (~global_control.stall_all) && (~global_control.data_hazard) || alu_jmp;
    // global_control.fetch_to_decode_en = (~global_control.stall_all)&&(~global_control.data_hazard);
    global_control.decode_to_execute_en = (~global_control.stall_all);
    global_control.execute_to_mem_en = (~global_control.stall_all);
    global_control.mem_to_reg_en = (~global_control.stall_all);
  end

  logic rs1_data_hazart =(rs1 !=5'd0) && ((~(|(rs1^decode_to_execute.rd))) ||
                                        (~(|(rs1^execute_to_mem.rd))) ||
                                        (~(|(rs1^mem_to_reg.rd))));
  logic rs2_data_hazart = (decode_control.reg_src||(|decode_control.mem_len)) && (rs2 !=5'd0) && (~(|(rs2^decode_to_execute.rd )) ||
                                        (~(|(rs2^execute_to_mem.rd))) ||
                                        (~(|(rs2^mem_to_reg.rd))));
  assign global_control.data_hazard = rs1_data_hazart || rs2_data_hazart;
  // assign global_control.data_hazard = ((rs1 !=5'd0))&&(~decode_control.reg_src || (rs2 !=5'd0))&&((~(|(rs1^decode_to_execute.rd))) ||
  //                                     (~(|(rs1^execute_to_mem.rd))) ||
  //                                     (~(|(rs1^mem_to_reg.rd))) ||
  //                                     (~(|(rs2^(decode_control.reg_src ? decode_to_execute.rd : 32'd0)))) ||
  //                                     (~(|(rs2^(decode_control.reg_src ? execute_to_mem.rd : 32'd0)))) ||
  //                                     (~(|(rs2^(decode_control.reg_src ? mem_to_reg.rd : 32'd0)))));

  // fetch

  // PC instance posedge
  assign pc_dest = ~alu_jmp ? pc_cur + 32'd4 : decode_to_execute.pc_dest;
  pc u_pc (
      .clk    (clk),
      .rst_n  (rst_n),
      .pc_en  (global_control.pc_en),
      .pc_dest(pc_dest),
      .pc_cur (pc_cur)
  );
  ram u_ram (
      .clk(clk),
      .rst_n(rst_n),
      .raddr1(pc_cur),
      .raddr2(mem_raddr),
      .waddr(mem_waddr),
      .wdata(mem_wdata),
      .wea(mem_wea),
      .rdata1(inst),
      .rdata2(mem_rdata)
  );





  // // fetch to decode
  // always_ff @(posedge clk) begin
  //     if(global_control.fetch_to_decode_en) begin
  //         fetch_to_decode.inst <= inst;
  //         fetch_to_decode.pc_cur <= pc_cur;
  //     end
  // end




  // decode
  decode u_decode (
      .inst       (inst),
      .control    (decode_control),
      .inst_opcode(inst_opcode),
      .rs1        (rs1),
      .rs2        (rs2),
      .rd         (rd),
      .pc_imm         (pc_imm),
      .imm_type   (imm_type),
      .inst_type  (inst_type)
  );

  assign pc_reg = rdata1;
  data_mux u_pc_mux(
  	.data_in1 (pc_reg ),
      .data_in0 (pc_cur ),
      .mux      (decode_control.pc_reg_src      ),
      .data_out (pc_mux_out )
  );
  pc_alu u_pc_alu(
  	.pc_cur  (pc_mux_out  ),
      .pc_imm  (pc_imm  ),
      .pc_next (pc_alu_out )
  );
  

  imm_ext u_imm_ext (
      .inst      (inst),
      .imm_signed(decode_control.imm_signed),
      .imm_type  (imm_type),
      .imm_data  (imm_data)
  );

  regfile u_regfile (
      .clk        (clk),
      .wen        (reg_wen),
      .raddr1     (rs1),
      .raddr2     (rs2),
      .waddr      (mem_to_reg.rd),
      .debug_raddr(debug_raddr),
      .wdata      (reg_wdata),
      .rdata1     (rdata1),
      .rdata2     (rdata2),
      .debug_reg  (debug_reg)
  );

  // decode to execute
  always_ff @(posedge clk) begin
    if (global_control.decode_to_execute_en) begin
      decode_to_execute.inst_type <= inst_type;
      decode_to_execute.rd <=~(global_control.data_hazard||alu_jmp) ? rd : 5'd0;
      decode_to_execute.inst_opcode <= ~(global_control.data_hazard||alu_jmp) ? inst_opcode : 20'd0;
      decode_to_execute.rdata1 <= rdata1;
      decode_to_execute.rdata2 <= rdata2;
      decode_to_execute.imm_data <= imm_data;
      decode_to_execute.pc_src <= decode_control.pc_src;
      decode_to_execute.reg_src <= decode_control.reg_src;
      decode_to_execute.write_reg <= ~(global_control.data_hazard||alu_jmp) ? decode_control.write_reg : 1'b0;
      decode_to_execute.pc_cur <= pc_cur;
      decode_to_execute.pc_dest <= pc_alu_out;
      decode_to_execute.write_reg_mux <= decode_control.write_reg_mux;
      decode_to_execute.mem_signed_ext <= decode_control.mem_signed_ext;
      decode_to_execute.mem_wea <= ~(global_control.data_hazard||alu_jmp) ? decode_control.mem_wea : 4'd0;
      decode_to_execute.mem_len <= ~(global_control.data_hazard||alu_jmp) ? decode_control.mem_len:3'd0;
    end
  end

  // execute
  data_mux u_pc_src_mux (
      .data_in1(decode_to_execute.pc_cur),
      .data_in0(decode_to_execute.rdata1),
      .mux     (decode_to_execute.pc_src),
      .data_out(alu_op1)
  );


  data_mux u_data_mux (
      .data_in1(decode_to_execute.rdata2),
      .data_in0(decode_to_execute.imm_data),
      .mux     (decode_to_execute.reg_src),
      .data_out(alu_op2)
  );


  alu u_alu (
      .inst_opcode(decode_to_execute.inst_opcode),
      .op1        (alu_op1),
      .op2        (alu_op2),
      .alu_jmp    (alu_jmp),
      .alu_out    (alu_out)
  );

  // execute to memory access
  always_ff @(posedge clk) begin
    if (global_control.execute_to_mem_en) begin
      execute_to_mem.write_reg <= decode_to_execute.write_reg;
      execute_to_mem.alu_out <= alu_out;
      execute_to_mem.rd <= decode_to_execute.rd;
      execute_to_mem.inst_type <= decode_to_execute.inst_type;
      execute_to_mem.pc_cur <= decode_to_execute.pc_cur;
      execute_to_mem.rdata2 <= decode_to_execute.rdata2;
      execute_to_mem.write_reg_mux <= decode_to_execute.write_reg_mux;
      execute_to_mem.mem_signed_ext <= decode_to_execute.mem_signed_ext;
      execute_to_mem.mem_wea <= decode_to_execute.mem_wea;
      execute_to_mem.mem_len <= decode_to_execute.mem_len;
    end
  end

  // memory access
  mem_ext u_mem_ext_0 (
      .data_in       (execute_to_mem.rdata2),
      .mem_len       (execute_to_mem.mem_len),
      .mem_signed_ext(1'b0),
      .data_out      (mem_ext_0_out)
  );

  assign mem_wea   = execute_to_mem.mem_wea;
  assign mem_waddr = execute_to_mem.alu_out;
  assign mem_wdata = mem_ext_0_out;
  assign mem_raddr = mem_waddr;
  //   assign mem_rdata = 

  mem_ext u_mem_ext_1 (
      .data_in       (mem_rdata),
      .mem_len       (execute_to_mem.mem_len),
      .mem_signed_ext(execute_to_mem.mem_signed_ext),
      .data_out      (mem_ext_1_out)
  );

  data_mux u_write_reg_mux (
      .data_in1(execute_to_mem.alu_out),
      .data_in0(mem_ext_1_out),
      .mux     (execute_to_mem.write_reg_mux),
      .data_out(write_reg_mux_out)
  );




  // memory access to write back
  always_ff @(posedge clk) begin
    if (global_control.mem_to_reg_en) begin
      mem_to_reg.write_reg <= execute_to_mem.write_reg;
      mem_to_reg.alu_out <= write_reg_mux_out;
      mem_to_reg.rd <= execute_to_mem.rd;
      mem_to_reg.inst_type <= execute_to_mem.inst_type;
      mem_to_reg.pc_cur <= execute_to_mem.pc_cur;
      mem_to_reg.mem_wea <= execute_to_mem.mem_wea;
      mem_to_reg.mem_waddr <= mem_waddr;
      mem_to_reg.mem_wdata <= mem_wdata;
    end
  end


  // write back
  assign reg_wdata = mem_to_reg.alu_out;
  assign reg_wen = mem_to_reg.write_reg;

  // debug
  assign debug_write_reg = mem_to_reg.write_reg;
  assign debug_reg_data = mem_to_reg.alu_out;
  assign debug_reg_id = mem_to_reg.rd;
  assign debug_inst = mem_to_reg.inst_type;
  assign debug_write_mem = |mem_to_reg.mem_wea;
  assign debug_mem_data = mem_to_reg.mem_wdata;
  assign debug_mem_addr = mem_to_reg.mem_waddr;
  assign debug_pc_cur = mem_to_reg.pc_cur;
  debug u_debug (
      .clk            (clk),
      .debug_inst     (debug_inst),
      .debug_write_reg(debug_write_reg),
      .debug_reg_data (debug_reg_data),
      .debug_reg_id   (debug_reg_id),
      .debug_write_mem(debug_write_mem),
      .debug_mem_data (debug_mem_data),
      .debug_mem_addr (debug_mem_addr),
      .debug_pc_cur   (debug_pc_cur)
  );




endmodule
