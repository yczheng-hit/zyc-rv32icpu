#include <stdlib.h>
#include <iostream>
#include <verilated.h>
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

// 终止时间
#define MAX_SIM_TIME 200000
vluint64_t sim_time = MAX_SIM_TIME;

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
bool diff = true;
int main(int argc, char **argv, char **env)
{
    TB_cpu *cpu = new TB_cpu(sim_time, true);
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
        // printf("PC: 0x%04x\tinst:%s instid: %d\n", cpu->m_core->pc_cur, INSTNAME[bit2num(cpu->m_core->debug_inst)], bit2num(cpu->m_core->debug_inst));
        data2server.set_pc(cpu->m_core->pc_cur);
        if (cpu->m_core->debug_uart_en)
            putchar(cpu->m_core->debug_uart_data);
        if (cpu->m_core->debug_write_reg)
        {
            data2server.set_type(difftest::Difftest::WRITE_REG);
            if (cpu->m_core->debug_write_reg_id == 0)
                data2server.set_dest_data(0);
            else
                data2server.set_dest_data(cpu->m_core->debug_data);
            data2server.set_dest_reg(cpu->m_core->debug_write_reg_id);
        }
        else if (cpu->m_core->debug_write_mem)
        {
            data2server.set_type(difftest::Difftest::WRITE_MEM);
            data2server.set_dest_data(cpu->m_core->debug_data);
            data2server.set_dest_addr(cpu->m_core->debug_addr);
        }
        else
        {
            data2server.set_type(difftest::Difftest::BRANCH);
        }

        // data2server.set_dest_addr(2);
        // dest_reg->set_id(1);
        // dest_reg->set_data(0xaabbccdd);
        if (diff)
        {
            if (client_communication())
            {
                cpu->register_dump();
                cpu->close();
                client_close();
                delete cpu;
                exit(EXIT_FAILURE);
            }
        }

        cpu->tick();
    }
    printf("\n---------------Simulation Finished---------------\n");
    cpu->register_dump();
    cpu->close();
    client_close();
    delete cpu;
    exit(EXIT_SUCCESS);
}
