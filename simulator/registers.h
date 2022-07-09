#ifndef __REGISTER_H_
#define __REGISTER_H_
#include <iostream>
extern const char *regsl[];
class REGISTERS
{
public:
    uint32_t regs[32];
    const uint32_t x0 = 0;
    uint32_t &x1;
    uint32_t &x2;
    uint32_t &x3;
    uint32_t &x4;
    uint32_t &x5;
    uint32_t &x6;
    uint32_t &x7;
    uint32_t &x8;
    uint32_t &x9;
    uint32_t &x10;
    uint32_t &x11;
    uint32_t &x12;
    uint32_t &x13;
    uint32_t &x14;
    uint32_t &x15;
    uint32_t &x16;
    uint32_t &x17;
    uint32_t &x18;
    uint32_t &x19;
    uint32_t &x20;
    uint32_t &x21;
    uint32_t &x22;
    uint32_t &x23;
    uint32_t &x24;
    uint32_t &x25;
    uint32_t &x26;
    uint32_t &x27;
    uint32_t &x28;
    uint32_t &x29;
    uint32_t &x30;
    uint32_t &x31;

    const uint32_t &zero;
    uint32_t &ra;
    uint32_t &sp;
    uint32_t &gp;
    uint32_t &tp;
    uint32_t &t0;
    uint32_t &t1;
    uint32_t &t2;
    uint32_t &s0;
    uint32_t &fp;
    uint32_t &s1;
    uint32_t &a0;
    uint32_t &a1;
    uint32_t &a2;
    uint32_t &a3;
    uint32_t &a4;
    uint32_t &a5;
    uint32_t &a6;
    uint32_t &a7;
    uint32_t &s2;
    uint32_t &s3;
    uint32_t &s4;
    uint32_t &s5;
    uint32_t &s6;
    uint32_t &s7;
    uint32_t &s8;
    uint32_t &s9;
    uint32_t &s10;
    uint32_t &s11;
    uint32_t &t3;
    uint32_t &t4;
    uint32_t &t5;
    uint32_t &t6;

    uint32_t PC;

    uint32_t out;
    uint32_t destReg;
    bool writeReg;

    void dump(void);
    REGISTERS(/* args */);
    ~REGISTERS();
};
void write_regs(void);

#endif
