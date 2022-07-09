#include "isa.h"
#include "debug.h"
#include "machine.h"
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
};
bool rv32i_decode(void)
{
    std::string instname = "";
    std::string inststr = "";
    std::string deststr, op1str, op2str, offsetstr;
    Inst insttype = Inst::UNKNOWN;
    uint32_t inst = cpu->cur_inst;
    uint32_t op1 = 0, op2 = 0, offset = 0; // op1, op2 and offset are values
    RegId dest = 0, reg1 = -1, reg2 = -1;  // reg1 and reg2 are operands

    uint32_t opcode = inst & 0x7F;
    uint32_t funct3 = (inst >> 12) & 0x7;
    uint32_t funct7 = (inst >> 25) & 0x7F;
    RegId rd = (inst >> 7) & 0x1F;
    RegId rs1 = (inst >> 15) & 0x1F;
    RegId rs2 = (inst >> 20) & 0x1F;
    uint32_t imm_i = uint32_t(inst) >> 20;
    uint32_t imm_u = uint32_t(inst) >> 12;
    // signed bit expand
    // store
    int32_t imm_s =
        int32_t(((inst >> 7) & 0x1F) | ((inst >> 20) & 0xFE0)) << 20 >> 20;
    // branch
    int32_t imm_sb = int32_t(((inst >> 7) & 0x1E) | ((inst >> 20) & 0x7E0) |
                             ((inst << 4) & 0x800) | ((inst >> 19) & 0x1000))
                         << 19 >>
                     19;
    // jal
    int32_t imm_uj = int32_t(((inst >> 21) & 0x3FF) | ((inst >> 10) & 0x400) |
                             ((inst >> 1) & 0x7F800) | ((inst >> 12) & 0x80000))
                         << 12 >>
                     11;

    switch (opcode)
    {
    case OP_REG:
        op1 = cpu->regs.regs[rs1];
        op2 = cpu->regs.regs[rs2];
        reg1 = rs1;
        reg2 = rs2;
        dest = rd;
        switch (funct3)
        {
        case 0x0: // add, sub
            if (funct7 == 0x00)
            {
                instname = "add";
                insttype = ADD;
            }
            else if (funct7 == 0x20)
            {
                instname = "sub";
                insttype = SUB;
            }
            else
            {
                panic("Unknown funct7 0x%x for funct3 0x%x\n", funct7, funct3);
            }
            break;
        case 0x1: // sll
            if (funct7 == 0x00)
            {
                instname = "sll";
                insttype = SLL;
            }
            else
            {
                panic("Unknown funct7 0x%x for funct3 0x%x\n", funct7, funct3);
            }
            break;
        case 0x2: // slt
            if (funct7 == 0x00)
            {
                instname = "slt";
                insttype = SLT;
            }
            else
            {
                panic("Unknown funct7 0x%x for funct3 0x%x\n", funct7, funct3);
            }
            break;
        case 0x3: // sltu
            if (funct7 == 0x00)
            {
                instname = "sltu";
                insttype = SLTU;
            }
            else
            {
                panic("Unknown funct7 0x%x for funct3 0x%x\n", funct7, funct3);
            }
            break;
        case 0x4: // xor
            if (funct7 == 0x00)
            {
                instname = "xor";
                insttype = XOR;
            }
            else
            {
                panic("Unknown funct7 0x%x for funct3 0x%x\n", funct7, funct3);
            }
            break;
        case 0x5: // srl, sra
            if (funct7 == 0x00)
            {
                instname = "srl";
                insttype = SRL;
            }
            else if (funct7 == 0x20)
            {
                instname = "sra";
                insttype = SRA;
            }
            else
            {
                panic("Unknown funct7 0x%x for funct3 0x%x\n", funct7, funct3);
            }
            break;
        case 0x6: // or
            if (funct7 == 0x00)
            {
                instname = "or";
                insttype = OR;
            }
            else
            {
                panic("Unknown funct7 0x%x for funct3 0x%x\n", funct7, funct3);
            }
            break;
        case 0x7: // and
            if (funct7 == 0x00)
            {
                instname = "and";
                insttype = AND;
            }
            else
            {
                panic("Unknown funct7 0x%x for funct3 0x%x\n", funct7, funct3);
            }
            break;
        default:
            panic("Unknown Funct3 field %x\n", funct3);
        }
        op1str = regsl[rs1];
        op2str = regsl[rs2];
        deststr = regsl[rd];
        inststr = instname + " " + deststr + "," + op1str + "," + op2str;
        break;
    case OP_IMM:
        op1 = cpu->regs.regs[rs1];
        reg1 = rs1;
        op2 = imm_i;
        op2 = (op2 >> 11) ? 0xfffff800 | op2 : op2;
        dest = rd;
        switch (funct3)
        {
        case 0x0:
            instname = "addi";
            insttype = ADDI;
            break;
        case 0x2:
            instname = "slti";
            insttype = SLTI;
            break;
        case 0x3:
            instname = "sltiu";
            insttype = SLTIU;
            break;
        case 0x4:
            instname = "xori";
            insttype = XORI;
            break;
        case 0x6:
            instname = "ori";
            insttype = ORI;
            break;
        case 0x7:
            instname = "andi";
            insttype = ANDI;
            break;
        case 0x1:
            instname = "slli";
            insttype = SLLI;
            op2 = op2 & 0x3F;
            break;
        case 0x5:
            if (((inst >> 26) & 0x3F) == 0x0)
            {
                instname = "srli";
                insttype = SRLI;
                op2 = op2 & 0x3F;
            }
            else if (((inst >> 26) & 0x3F) == 0x10)
            {
                instname = "srai";
                insttype = SRAI;
                op2 = op2 & 0x3F;
            }
            else
            {
                panic("Unknown funct7 0x%x for OP_IMM\n", (inst >> 26) & 0x3F);
            }
            break;
        default:
            panic("Unknown Funct3 field %x\n", funct3);
        }
        op1str = regsl[rs1];
        op2str = std::to_string(op2);
        deststr = regsl[dest];
        inststr = instname + " " + deststr + "," + op1str + "," + op2str;
        break;
    case OP_LUI:
        op1 = imm_u;
        op2 = 0;
        offset = imm_u;
        dest = rd;
        instname = "lui";
        insttype = LUI;
        op1str = std::to_string(imm_u);
        deststr = regsl[dest];
        inststr = instname + " " + deststr + "," + op1str;
        break;
    case OP_AUIPC:
        op1 = imm_u;
        op2 = 0;
        offset = imm_u;
        dest = rd;
        instname = "auipc";
        insttype = AUIPC;
        op1str = std::to_string(imm_u);
        deststr = regsl[dest];
        inststr = instname + " " + deststr + "," + op1str;
        break;
    case OP_JAL:
        op1 = imm_uj;
        op2 = 0;
        offset = imm_uj;
        dest = rd;
        instname = "jal";
        insttype = JAL;
        op1str = std::to_string(imm_uj);
        deststr = regsl[dest];
        inststr = instname + " " + deststr + "," + op1str;
        break;
    case OP_JALR:
        op1 = cpu->regs.regs[rs1];
        reg1 = rs1;
        op2 = imm_i;
        op2 = (op2 >> 11) ? 0xfffff800 | op2 : op2;
        dest = rd;
        instname = "jalr";
        insttype = JALR;
        op1str = regsl[rs1];
        op2str = std::to_string(op2);
        deststr = regsl[dest];
        inststr = instname + " " + deststr + "," + op1str + "," + op2str;
        break;
    case OP_BRANCH:
        op1 = cpu->regs.regs[rs1];
        op2 = cpu->regs.regs[rs2];
        reg1 = rs1;
        reg2 = rs2;
        offset = imm_sb;
        switch (funct3)
        {
        case 0x0:
            instname = "beq";
            insttype = BEQ;
            break;
        case 0x1:
            instname = "bne";
            insttype = BNE;
            break;
        case 0x4:
            instname = "blt";
            insttype = BLT;
            break;
        case 0x5:
            instname = "bge";
            insttype = BGE;
            break;
        case 0x6:
            instname = "bltu";
            insttype = BLTU;
            break;
        case 0x7:
            instname = "bgeu";
            insttype = BGEU;
            break;
        default:
            panic("Unknown funct3 0x%x at OP_BRANCH\n", funct3);
        }
        op1str = regsl[rs1];
        op2str = regsl[rs2];
        offsetstr = std::to_string((int32_t)offset);
        inststr = instname + " " + op1str + "," + op2str + "," + offsetstr;
        break;
    case OP_STORE:
        op1 = cpu->regs.regs[rs1];
        op2 = cpu->regs.regs[rs2];
        reg1 = rs1;
        reg2 = rs2;
        offset = imm_s;
        switch (funct3)
        {
        case 0x0:
            instname = "sb";
            insttype = SB;
            break;
        case 0x1:
            instname = "sh";
            insttype = SH;
            break;
        case 0x2:
            instname = "sw";
            insttype = SW;
            break;
        default:
            panic("Unknown funct3 0x%x for OP_STORE\n", funct3);
        }
        op1str = regsl[rs1];
        op2str = regsl[rs2];
        offsetstr = std::to_string((int32_t)offset);
        inststr = instname + " " + op2str + "," + offsetstr + "(" + op1str + ")";
        break;
    case OP_LOAD:
        op1 = cpu->regs.regs[rs1];
        reg1 = rs1;
        op2 = imm_i;
        op2 = (op2 >> 11) ? 0xfffff800 | op2 : op2;
        offset = imm_i;
        offset = (offset >> 11) ? 0xfffff800 | offset : offset;
        dest = rd;
        switch (funct3)
        {
        case 0x0:
            instname = "lb";
            insttype = LB;
            break;
        case 0x1:
            instname = "lh";
            insttype = LH;
            break;
        case 0x2:
            instname = "lw";
            insttype = LW;
            break;
        case 0x4:
            instname = "lbu";
            insttype = LBU;
            break;
        case 0x5:
            instname = "lhu";
            insttype = LHU;
            break;
        default:
            panic("Unknown funct3 0x%x for OP_LOAD\n", funct3);
        }
        op1str = regsl[rs1];
        op2str = std::to_string(op2);
        deststr = regsl[rd];
        inststr = instname + " " + deststr + "," + op2str + "(" + op1str + ")";
        break;
    case OP_USRDEF:
        instname = "usrdef";
        insttype = USRDEF;
        return true;
    default:
        panic("Unsupported opcode 0x%x!\n", opcode);
    }

    cpu->alu.inst = insttype;
    cpu->alu.op1 = op1;
    cpu->alu.op2 = op2;
    cpu->alu.offset = offset;
    cpu->alu.PC = cpu->regs.PC;
    cpu->alu.dest = dest;
    TRACE("Addr 0x%.8x\t Decoded instruction 0x%.8x as %s\n", cpu->regs.PC, inst, inststr.c_str());
    return false;
}
