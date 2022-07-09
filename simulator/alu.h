#ifndef __ALU_H_
#define __ALU_H_
#include <iostream>
#include "isa.h"
class ALU
{
public:
    Inst inst;
    uint32_t op1,op2,offset;
    uint32_t PC;
    RegId dest;
    ALU(/* args */);
    ~ALU();
};
void alu_execute(void);



#endif
