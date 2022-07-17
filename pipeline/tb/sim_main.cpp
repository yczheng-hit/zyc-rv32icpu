#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include "Vcpu__Dpi.h"
#include "Vcpu__Syms.h"
#include "testbench.h"
#include "Vcpu.h"
#include "client_api.h"

const char *INSTNAME[]{
    "lui",
    "auipc",
    "jal",
    "jalr",
    "beq",
    "bne",
    "blt",
    "bge",
    "bltu",
    "bgeu",
    "lb",
    "lh",
    "lw",
    "lbu",
    "lhu",
    "sb",
    "sh",
    "sw",
    "addi",
    "slti",
    "sltiu",
    "xori",
    "ori",
    "andi",
    "slli",
    "srli",
    "srai",
    "add",
    "sub",
    "sll",
    "slt",
    "sltu",
    "xor",
    "srl",
    "sra",
    "or",
    "and",
    "usr",
    "err",
};
const char *regsl[] = {
    "x0/zero", "x1/ra", "x2/sp", "x3/gp", "x4/tp", "x5/t0", "x6/t1", "x7/t2",
    "x8/s0", "x9/s1", "x10/a0", "x11/a1", "x12/a2", "x13/a3", "x14/a4", "x15/a5",
    "x16/a6", "x17/a7", "x18/s2", "x19/s3", "x20/s4", "x21/s5", "x22/s6", "x23/s7",
    "x24/s8", "x25/s9", "x26/s10", "x27/s11", "x28/t3", "x29/t4", "x30/t5", "x31/t6"};

// 4byte 对齐
#pragma pack(push, 4)
// I don't know why it is reversed
typedef struct
{
    uint32_t pc_cur;
    uint64_t debug_inst;
    uint32_t reg_data;
    uint32_t reg_id;
    uint32_t mem_data;
    uint32_t mem_addr;
    uint32_t op_type;
} debug_st;
#pragma pack(pop)

typedef union
{
    uint32_t data[8];
    debug_st st;
} debug_un;

class TB_cpu : public TESTBENCH<Vcpu>
{
private:
public:
private:
public:
    TB_cpu(unsigned long count, bool trace) : TESTBENCH<Vcpu>(count, trace)
    {
    }

    void register_dump(void)
    {
        printf("\n--------register dump--------\n");
        for (int i = 0; i < 32; i++)
        {
            m_core->debug_raddr = i;
            m_core->eval();
            // tick();
            printf("%7s: 0x%08x\t", regsl[i], m_core->debug_reg);
            if (i % 4 == 3)
                printf("\n");
        }
        printf("PC: 0x%08x\n", m_core->pc_cur);
    }
};

debug_un *dbg_data_from_rtl;
debug_un dbg_data;

#define MAX_SIM_TIME 200000
vluint64_t sim_time = MAX_SIM_TIME;
bool diff = true;
TB_cpu *cpu;


void my_exit(int id){
    diff = false;
    cpu->register_dump();
    cpu->close();
    client_close();
    delete cpu;
    exit(id);
}



int bit2num(uint64_t bit)
{
    int num = 0;
    if (!bit)
        return 38;
    while (bit != 1)
    {
        bit >>= 1;
        num++;
    }

    return 37 - num;
}

void virtual_uart(int x){
    putchar(x);
}


void data_syn(const svBitVecVal *x)
{
    dbg_data_from_rtl = (debug_un *)x;
    // for (int i = 0; i < sizeof(dbg_data_from_rtl->st) / 4; i++)
    // {
    //     dbg_data_from_rtl->data[i] = dbg_data_from_rtl->data[i];
    // }
    // printf("dpi-c , pc:%05x\n", dbg_data_from_rtl->st.pc_cur);
    // printf("inst:%s instid: %d\n", INSTNAME[bit2num(dbg_data_from_rtl->st.debug_inst)], bit2num(dbg_data_from_rtl->st.debug_inst));
    // printf("%d\n", dbg_data_from_rtl->st.op_type);
    // printf("reg id:%d reg data: 0x%08x\n", dbg_data_from_rtl->st.reg_id, dbg_data_from_rtl->st.reg_data);
    // printf("mem addr:0x%08x mem data: 0x%08x\n", dbg_data_from_rtl->st.mem_addr, dbg_data_from_rtl->st.mem_data);
    data2server.set_pc(dbg_data_from_rtl->st.pc_cur);
    if (dbg_data_from_rtl->st.op_type == 0x01)
    {
        data2server.set_type(difftest::Difftest::WRITE_REG);
        if (dbg_data_from_rtl->st.reg_id == 0)
            data2server.set_dest_data(0);
        else
            data2server.set_dest_data(dbg_data_from_rtl->st.reg_data);
        data2server.set_dest_reg(dbg_data_from_rtl->st.reg_id);
    }
    else if (dbg_data_from_rtl->st.op_type == 0x02)
    {
        data2server.set_type(difftest::Difftest::WRITE_MEM);
        data2server.set_dest_data(dbg_data_from_rtl->st.mem_data);
        data2server.set_dest_addr(dbg_data_from_rtl->st.mem_addr);
    }
    else
    {
        data2server.set_type(difftest::Difftest::BRANCH);
    }

    if (diff)
    {
        if (client_communication())
        {
            my_exit(EXIT_FAILURE);
        }
    }
}

int main(int argc, char **argv, char **env)
{
    cpu = new TB_cpu(sim_time, true);
    cpu->opentrace("waveform.vcd");
    if (argc > 1)
        diff = false;
    if (diff)
        client_init();

    cpu->reset();
    // cpu->tick();
    // data2server.add_regs();
    while (!cpu->done())
    {
        cpu->tick();
    }
    printf("\n---------------Simulation Finished---------------\n");
    my_exit(EXIT_SUCCESS);
}
