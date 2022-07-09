#include <iostream>
#include "elfio/elfio.hpp"
#include "cxxopts.hpp"

#include "debug.h"
#include "server_api.h"
#include "memory.h"
#include "registers.h"
#include "machine.h"
#include "isa.h"
#include "alu.h"
#include "mmio.h"
#include "signal.h"
#define MEM_LEN(len) (len == 4 ? 0xffffffff : len == 2 ? 0xffff \
                                          : len == 1   ? 0xff   \
                                                       : 0)
void my_exit(int id)
{
    std::cout << std::endl;
    if (!id)
        std::cout << "---------------------simulation finish---------------------" << std::endl;
    else
        std::cout << "---------------------simulation exited---------------------" << std::endl;
    cpu->inst_dump();
    cpu->regs.dump();
    cpu->mem_data.dump(40);
    if (cpu->trace)
        fclose(cpu->pFile);
    server_close();
    exit(id);
}
void signalHandler(int signum)
{
    std::cout << "Interrupt signal (" << signum << ") received.\n";

    // cleanup and close up stuff here
    // terminate program
    my_exit(EXIT_FAILURE);
}
bool model_init(int argc, char **argv)
{
    std::string elf_path;
    bool debug, diff, verbose;
    std::string trace_file;
    cxxopts::Options options("main", "RV32i cpu c-model.");
    options
        .set_width(70)
        .set_tab_expansion()
        .allow_unrecognised_options()
        .add_options()("e,elf", "Executable file", cxxopts::value<std::string>())("t,trace", "Trace file", cxxopts::value<std::string>())("v,verbose", "More detail", cxxopts::value<bool>())("d,debug", "Debug option", cxxopts::value<bool>())("diff", "Debug option", cxxopts::value<bool>())("h,help", "Print help");
    // arguments parse
    auto result = options.parse(argc, argv);
    if (result.count("help"))
    {
        std::cout << options.help({"", "Group"}) << std::endl;
        exit(0);
    }
    // Verilated::commandArgs(argc, argv);
    try
    {
        elf_path = result["elf"].as<std::string>();
        std::cout << elf_path << std::endl;
        debug = result["debug"].as<bool>();
        trace_file = result["trace"].as<std::string>();
        std::cout << trace_file << std::endl;
        diff = result["diff"].as<bool>();
        verbose = result["verbose"].as<bool>();
    }
    catch (const cxxopts::OptionException &e)
    {
        std::cout << "error parsing options: " << e.what() << std::endl;
        exit(1);
    }

    // cpu->mem_inst.dump(cpu->size_inst);
    // cpu->mem_data.dump(cpu->size_data);
    if (!trace_file.empty())
        cpu->trace = true;
    else
        cpu->trace = false;
    if (cpu->trace)
        cpu->pFile = fopen(trace_file.c_str(), "w");
    cpu->verbose = verbose;
    cpu->diff = diff;
    cpu->load_ELF(elf_path, cpu->verbose);
    if (cpu->diff)
    {
        std::cout << "Difftest enabled, waiting for connect!" << std::endl;
        server_init();
    }
    cpu->debug = debug;
    std::cout << "---------------------simulation start---------------------" << std::endl;
    return false;
}

void fetch(void)
{
    DBG("\033[31mFetch\n");
    cpu->regs.PC = cpu->nPC;
    cpu->cur_inst = cpu->mem_inst.get_u32(cpu->regs.PC & 0x3ffff);
}

void decode(void)
{
    DBG("\033[32mDecode\n");
    if (rv32i_decode())
    {
        cpu->running = false;
    }
}

void execute(void)
{
    DBG("\033[33mExecute\n");
    alu_execute();
}
void mem_access(void)
{
    DBG("\033[34mMemory Access\n");
    mmio_access();
}
void write_back(void)
{
    DBG("\033[35mWrite Back\n");
    write_regs();
    if (!cpu->branch)
        cpu->nPC = cpu->regs.PC + 4;
    else
    {
        DBG("Branch Happened: %08x\n", cpu->nPC);
    }
}

void main_loop(void)
{
    cpu->running = true;

    while (cpu->running)
    {
        fetch();
        decode();
        execute();
        mem_access();
        write_back();
        if (cpu->diff)
        {
            if (server_communication())
                my_exit(EXIT_FAILURE);
            if (cpu->regs_cli.PC != cpu->regs.PC)
            {
                printf("ERROR!: PC dismatch!\n");
                printf("simulator PC: 0x%08x\t CPU PC: 0x%08x\t", cpu->regs.PC, cpu->regs_cli.PC);
                my_exit(EXIT_FAILURE);
            }
            switch (cpu->type_cli)
            {
            case WRITE_REG:
                if ((cpu->regs.regs[cpu->regid_cli] == cpu->data_cli) && (cpu->regid_cli == cpu->regs.destReg))
                {
                    if (cpu->verbose)
                        printf("pc:%04x id:%d data match! data:0x%08x\n", cpu->regs_cli.PC, cpu->regid_cli, cpu->data_cli);
                }
                else
                {
                    printf("ERROR!: data dismatch!\n");
                    printf("PC: 0x%08x simulator data:0x%08x id:%d\t cpu data:0x%08x id:%d\t", cpu->regs.PC, cpu->regs.regs[cpu->regid_cli], cpu->regs.destReg, cpu->data_cli, cpu->regid_cli);
                    my_exit(EXIT_FAILURE);
                }
                break;
            case WRITE_MEM:
                if (!cpu->mmio.writeMem)
                {
                    printf("ERROR!: option dismatch! write_mem expected\n");
                    my_exit(EXIT_FAILURE);
                }
                if ((cpu->mmio.out == cpu->addr_cli) && ((cpu->mmio.op2 & MEM_LEN(cpu->mmio.memLen)) == cpu->data_cli))
                {
                    if (cpu->verbose)
                        printf("store addr:0x%08x data match! data:0x%08x\n", cpu->addr_cli, cpu->data_cli);
                }
                else
                {
                    printf("ERROR!: addr/data dismatch!\n");
                    printf("PC: 0x%08x\t simulator addr:0x%08x data:0x%08x cpu  addr:0x%08x data:0x%08x", cpu->regs.PC, cpu->mmio.out, cpu->mmio.op2, cpu->addr_cli, cpu->data_cli);
                    my_exit(EXIT_FAILURE);
                }
                break;
            case BRANCH:
                if (cpu->verbose)
                    printf("Branch happened!\tsimulator PC: 0x%08x\t CPU PC: 0x%08x\t", cpu->regs.PC, cpu->regs_cli.PC);
                break;
            case CHECK_REG:
                break;
            }
        }
        if (!cpu->running)
            return;
    }
}

int main(int argc, char **argv)
{
    signal(SIGINT, signalHandler);
    model_init(argc, argv);

    main_loop();
    my_exit(EXIT_SUCCESS);
    return 0;
}
