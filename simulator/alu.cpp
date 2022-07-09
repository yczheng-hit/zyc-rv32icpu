#include "alu.h"

#include "machine.h"
#include "debug.h"
ALU::ALU(/* args */)
{
}

ALU::~ALU()
{
}

void alu_execute(void)
{
    Inst inst = cpu->alu.inst;
    uint32_t op1 = cpu->alu.op1;
    uint32_t op2 = cpu->alu.op2;
    uint32_t offset = cpu->alu.offset;
    uint32_t dRegPC = cpu->alu.PC;
    RegId destReg = cpu->alu.dest;
    bool writeReg = false;
    uint32_t out = 0;
    bool writeMem = false;
    bool readMem = false;
    bool readSignExt = false;
    uint32_t memLen = 0;
    bool branch = false;

    switch (inst)
    {
    case LUI:
        writeReg = true;
        out = offset << 12;
        break;
    case AUIPC:
        writeReg = true;
        out = dRegPC + (offset << 12);
        break;
    case JAL:
        writeReg = true;
        out = dRegPC + 4;
        dRegPC = dRegPC + (int32_t)op1;
        branch = true;
        break;
    case JALR:
        writeReg = true;
        out = dRegPC + 4;
        dRegPC = (op1 + op2) & (~(uint32_t)1);
        branch = true;
        break;
    case BEQ:
        if (op1 == op2)
        {
            branch = true;
            dRegPC = dRegPC + (int32_t)offset;
        }
        break;
    case BNE:
        if (op1 != op2)
        {
            branch = true;
            dRegPC = dRegPC + (int32_t)offset;
        }
        break;
    case BLT:
        if ((int32_t)op1 < (int32_t)op2)
        {
            branch = true;
            dRegPC = dRegPC + (int32_t)offset;
        }
        break;
    case BGE:
        if ((int32_t)op1 >= (int32_t)op2)
        {
            branch = true;
            dRegPC = dRegPC + (int32_t) offset;
        }
        break;
    case BLTU:
        if ((uint32_t)op1 < (uint32_t)op2)
        {
            branch = true;
            dRegPC = dRegPC + (int32_t)offset;
        }
        break;
    case BGEU:
        if ((uint32_t)op1 >= (uint32_t)op2)
        {
            branch = true;
            dRegPC = dRegPC + (int32_t)offset;
        }
        break;
    case LB:
        readMem = true;
        writeReg = true;
        memLen = 1;
        out = op1 + offset;
        readSignExt = true;
        break;
    case LH:
        readMem = true;
        writeReg = true;
        memLen = 2;
        out = op1 + (int32_t)offset;
        readSignExt = true;
        break;
    case LW:
        readMem = true;
        writeReg = true;
        memLen = 4;
        out = op1 + (int32_t)offset;
        readSignExt = true;
        break;
    case LBU:
        readMem = true;
        writeReg = true;
        memLen = 1;
        out = op1 + (int32_t)offset;
        break;
    case LHU:
        readMem = true;
        writeReg = true;
        memLen = 2;
        out = op1 + (int32_t)offset;
        break;
    case SB:
        writeMem = true;
        memLen = 1;
        out = op1 + (int32_t)offset;
        op2 = op2 & 0xFF;
        break;
    case SH:
        writeMem = true;
        memLen = 2;
        out = op1 + (int32_t)offset;
        op2 = op2 & 0xFFFF;
        break;
    case SW:
        writeMem = true;
        memLen = 4;
        out = op1 + (int32_t)offset;
        op2 = op2 & 0xFFFFFFFF;
        break;
    case ADDI:
    case ADD:
        writeReg = true;
        out = op1 + op2;
        break;
    case SUB:
        writeReg = true;
        out = op1 - op2;
        break;
    case SLTI:
    case SLT:
        writeReg = true;
        out = (int32_t)op1 < (int32_t) op2 ? 1 : 0;
        break;
    case SLTIU:
    case SLTU:
        writeReg = true;
        out = op1 < op2 ? 1 : 0;
        break;
    case XORI:
    case XOR:
        writeReg = true;
        out = op1 ^ op2;
        break;
    case ORI:
    case OR:
        writeReg = true;
        out = op1 | op2;
        break;
    case ANDI:
    case AND:
        writeReg = true;
        out = op1 & op2;
        break;
    case SLLI:
    case SLL:
        writeReg = true;
        out = op1 << op2;
        break;
    case SRLI:
    case SRL:
        writeReg = true;
        out = (uint32_t)op1 >> (uint32_t)op2;
        break;
    case SRAI:
    case SRA:
        writeReg = true;
        out = (uint32_t)(((int32_t)op1) >> ((int32_t)op2));
        break;
    default:
        panic("Unknown instruction type %d\n", inst);
    }
    cpu->inst_cnt[inst]++;
    TRACE("branch: %d, write reg: %d op1: %08x op2: %08x offset: %08x out: %08x write mem: %d read mem: %d\n", branch?1:0,writeReg?1:0,op1,op2,offset,out,writeMem?1:0,readMem?1:0);
    cpu->mmio.destReg = destReg;
    cpu->mmio.memLen = memLen;
    cpu->mmio.writeMem = writeMem;
    cpu->mmio.writeReg = writeReg;
    cpu->mmio.readMem = readMem;
    cpu->mmio.op1 = op1;
    cpu->mmio.op2 = op2;
    cpu->mmio.readSignExt = readSignExt;
    cpu->mmio.out = out;

    cpu->branch = branch;
    cpu->nPC = dRegPC;

}
