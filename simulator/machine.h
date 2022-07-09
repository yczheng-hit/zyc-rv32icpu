#ifndef __MACHINE_H_
#define __MACHINE_H_
#include "memory.h"
#include "registers.h"
#include "elfio/elfio.hpp"
#include "isa.h"
#include "alu.h"
#include "mmio.h"

enum DiffType{
WRITE_REG 	= 0,
WRITE_MEM 	= 1,
CHECK_REG 	= 2,
BRANCH 	    = 3,
};

class machine
{
public:
    MEMORY mem_data;
    MEMORY mem_inst;
    REGISTERS regs;
    ALU alu;
    MMIO mmio;
    uint32_t entry;
    uint32_t size_inst;
    uint32_t size_data;
    uint32_t nPC;
    bool branch;
    uint32_t cur_inst;
    bool running;
    bool debug;
    bool trace;
    bool diff;
    bool verbose;
    FILE * pFile;
    uint32_t inst_cnt[37];
    // difftest
    REGISTERS regs_cli;
    uint32_t regid_cli;
    uint32_t addr_cli;
    uint32_t data_cli;
    DiffType type_cli;
    machine();
    void load_ELF(std::string program_path, const bool en_print);
    void inst_dump();
    ~machine();
};
extern machine *cpu;

#endif
