#include "mmio.h"
#include "debug.h"
#include "machine.h"

void mmio_access(void)
{
    Inst inst = cpu->alu.inst;
    bool writeReg = cpu->mmio.writeReg;
    RegId destReg = cpu->mmio.destReg;
    uint32_t op1 = cpu->mmio.op1; // for jalr
    uint32_t op2 = cpu->mmio.op2; // for store
    uint32_t out = cpu->mmio.out;
    bool writeMem = cpu->mmio.writeMem;
    bool readMem = cpu->mmio.readMem;
    bool readSignExt = cpu->mmio.readSignExt;
    uint32_t memLen = cpu->mmio.memLen;

    if (writeMem)
    {
        cpu->mmio.write_io(out, op2, memLen);
    }

    if (readMem)
    {
        if (readSignExt)
        {
            out = (uint32_t)cpu->mmio.read_io(out, memLen);
            // expand signed bit
            if(memLen!=4)
            out = (1<<(memLen*8-1))&out ? (out|((0xffffffff)^((1<<memLen*8)-1))) : out;
        }
        else
        {
            out = (uint32_t)cpu->mmio.read_io(out, memLen);
        }
    }
    if (readMem || writeMem)
        TRACE("Memory Access: %s\n", INSTNAME[inst]);
    
    cpu->regs.writeReg = writeReg;
    cpu->regs.destReg = destReg;
    cpu->regs.out = out;
}

void MMIO::write_io(uint32_t addr, uint64_t data, uint32_t length)
{
    uint32_t offset;
    offset = addr&0x3ffff;
    TRACE("offset: %05x\taddr: %08x\tdata: %08lx\n",offset,addr,data);
    if ((addr >= 0x80000000) && (addr < 0x80020000)||(addr >= 0x00000000) && (addr < 0x00020000))
    {
        switch (length)
        {
        case 8:
            cpu->mem_inst.set_u64(offset, data);
            break;
        case 4:
            cpu->mem_inst.set_u32(offset, data);
            break;
        case 2:
            cpu->mem_inst.set_u16(offset, data);
            break;
        case 1:
            cpu->mem_inst.set_u8(offset, data);
            break;
        default:
            panic("Unknown memLen %d\n", length);
            break;
        }
    }
    else if ((addr >= 0x90000000) && (addr < 0x90020000)||(addr >= 0x20000000) && (addr < 0x20020000))
    {
        switch (length)
        {
        case 8:
            cpu->mem_data.set_u64(offset, data);
            break;
        case 4:
            cpu->mem_data.set_u32(offset, data);
            break;
        case 2:
            cpu->mem_data.set_u16(offset, data);
            break;
        case 1:
            cpu->mem_data.set_u8(offset, data);
            break;
        default:
            panic("Unknown memLen %d\n", length);
            break;
        }
    }
    else if (addr == 0x10000000)
    {
        putchar(data);
    }
    else
    {
    }
}

uint64_t MMIO::read_io(uint32_t addr, uint32_t length)
{
    uint32_t offset;
    offset = addr&0x3ffff;
    TRACE("offset: %05x\taddr: %08x\n",offset,addr);
    if ((addr >= 0x80000000) && (addr < 0x80020000)||(addr >= 0x00000000) && (addr < 0x00020000))
    {
        switch (length)
        {
        case 8:
            return cpu->mem_inst.get_u64(offset);
        case 4:
            return cpu->mem_inst.get_u32(offset);
        case 2:
            return cpu->mem_inst.get_u16(offset);
        case 1:
            return cpu->mem_inst.get_u8(offset);
        default:
            panic("Unknown memLen %d\n", length);
            break;
        }
    }
    else if ((addr >= 0x90000000) && (addr < 0x90020000)||(addr >= 0x20000000) && (addr < 0x20020000))
    {
        switch (length)
        {
        case 8:
            return cpu->mem_data.get_u64(offset);
        case 4:
            return cpu->mem_data.get_u32(offset);
        case 2:
            return cpu->mem_data.get_u16(offset);
        case 1:
            return cpu->mem_data.get_u8(offset);
        default:
            panic("Unknown memLen %d\n", length);
            break;
        }
    }
    else
    {
    }
    return -1;
}

MMIO::MMIO(/* args */)
{
}

MMIO::~MMIO()
{
}
