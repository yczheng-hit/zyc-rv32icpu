#include "registers.h"
#include "machine.h"
const char *regsl[] = {
    "x0/zero", "x1/ra", "x2/sp", "x3/gp", "x4/tp", "x5/t0", "x6/t1", "x7/t2",
    "x8/s0", "x9/s1", "x10/a0", "x11/a1", "x12/a2", "x13/a3", "x14/a4", "x15/a5",
    "x16/a6", "x17/a7", "x18/s2", "x19/s3", "x20/s4", "x21/s5", "x22/s6", "x23/s7",
    "x24/s8", "x25/s9", "x26/s10", "x27/s11", "x28/t3", "x29/t4", "x30/t5", "x31/t6"};

REGISTERS::REGISTERS(/* args */) : zero(x0),
                                 ra(regs[1]),
                                 sp(regs[2]),
                                 gp(regs[3]),
                                 tp(regs[4]),
                                 t0(regs[5]),
                                 t1(regs[6]),
                                 t2(regs[7]),
                                 s0(regs[8]),
                                 s1(regs[9]),
                                 fp(regs[9]),
                                 a0(regs[10]),
                                 a1(regs[11]),
                                 a2(regs[12]),
                                 a3(regs[13]),
                                 a4(regs[14]),
                                 a5(regs[15]),
                                 a6(regs[16]),
                                 a7(regs[17]),
                                 s2(regs[18]),
                                 s3(regs[19]),
                                 s4(regs[20]),
                                 s5(regs[21]),
                                 s6(regs[22]),
                                 s7(regs[23]),
                                 s8(regs[24]),
                                 s9(regs[25]),
                                 s10(regs[26]),
                                 s11(regs[27]),
                                 t3(regs[28]),
                                 t4(regs[29]),
                                 t5(regs[30]),
                                 t6(regs[31]),
                                 x1(regs[1]),
                                 x2(regs[2]),
                                 x3(regs[3]),
                                 x4(regs[4]),
                                 x5(regs[5]),
                                 x6(regs[6]),
                                 x7(regs[7]),
                                 x8(regs[8]),
                                 x9(regs[9]),
                                 x10(regs[10]),
                                 x11(regs[11]),
                                 x12(regs[12]),
                                 x13(regs[13]),
                                 x14(regs[14]),
                                 x15(regs[15]),
                                 x16(regs[16]),
                                 x17(regs[17]),
                                 x18(regs[18]),
                                 x19(regs[19]),
                                 x20(regs[20]),
                                 x21(regs[21]),
                                 x22(regs[22]),
                                 x23(regs[23]),
                                 x24(regs[24]),
                                 x25(regs[25]),
                                 x26(regs[26]),
                                 x27(regs[27]),
                                 x28(regs[28]),
                                 x29(regs[29]),
                                 x30(regs[30]),
                                 x31(regs[31])
{
    for (uint8_t i = 0; i < 32; i++)
    {
        regs[i] = 0;
    }
    PC = 0;
}

REGISTERS::~REGISTERS()
{
}
void REGISTERS::dump(void)
{
    int i;
    printf("Register Dump\n");
    for (i = 0; i < 32; i++)
    {
        printf("%7s: 0x%08x\t", regsl[i], regs[i]);
        if (i % 4 == 3)
            printf("\n");
    }
    printf("PC: 0x%08x\n", PC);
}

void write_regs(void)
{
    uint32_t out = cpu->regs.out;
    uint32_t destReg = cpu->regs.destReg;
    bool writeReg = cpu->regs.writeReg;

    if(writeReg && destReg != 0)
    {
        cpu->regs.regs[destReg] = out;
    }
}
