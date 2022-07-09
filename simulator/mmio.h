#ifndef __MMIO_H_
#define __MMIO_H_
#include <iostream>
#include "isa.h"
// class for memory access
class MMIO
{
public:
    uint32_t op1,op2,out;
    uint32_t memLen;
    bool writeReg,writeMem,readMem,readSignExt;
    RegId destReg;
    void write_io(uint32_t addr,uint64_t data, uint32_t length);
    uint64_t read_io(uint32_t addr,uint32_t length);
    MMIO(/* args */);
    ~MMIO();
};

void mmio_access(void);

#endif
