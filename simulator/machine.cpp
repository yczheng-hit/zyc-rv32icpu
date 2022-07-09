#include "machine.h"
machine *cpu = new machine();

machine::machine() : regs(), mem_data("mem_data"), mem_inst("mem_inst"), running(false), alu(), mmio(), regs_cli()
{
    // if(en_print)
    nPC = 0;
    debug = false;
    trace = false;
    verbose = false;
    pFile = NULL;
    diff = true;
}

void machine::load_ELF(std::string program_path, const bool en_print)
{
    ELFIO::elfio program;
    program.load(program_path);
    if (program.get_class() != ELFIO::ELFCLASS32 ||
        program.get_machine() != 0xf3)
    {
        std::cout << "\n[ERROR] Error loading ELF file, headers does not match with ELFCLASS32/RISC-V!" << std::endl;
        exit(-1);
    }

    ELFIO::Elf_Half seg_num = program.segments.size();

    if (en_print)
    {
        printf("\n[ELF Loader]"
               "\nNumber of segments (program headers): %d",
               seg_num);
    }

    for (uint8_t i = 0; i < seg_num; i++)
    {
        const ELFIO::segment *p_seg = program.segments[i];
        const ELFIO::Elf32_Addr lma_addr = (uint32_t)p_seg->get_physical_address();
        const ELFIO::Elf32_Addr vma_addr = (uint32_t)p_seg->get_virtual_address();
        const uint32_t mem_size = (uint32_t)p_seg->get_memory_size();
        const uint32_t file_size = (uint32_t)p_seg->get_file_size();
        if (i == 0)
        {
            entry = lma_addr;
            size_inst = file_size;
        }
        else
        {
            size_data = file_size;
        }
        // const char *data_pointer = p_seg->get_data();

        if (en_print)
        {
            printf("\nSegment [%d] - LMA[0x%x] VMA[0x%x]", i, (uint32_t)lma_addr, (uint32_t)vma_addr);
            printf("\nFile size [%d] - Memory size [%d]", file_size, mem_size);
        }

        // Notes about loading .data and .bss
        // > According to:
        // https://www.cs.bgu.ac.il/~caspl112/wiki.files/lab9/elf.pdf
        // Page 34:
        // The array element specifies a loadable segment, described by p_filesz and p_memsz.
        // The bytes from the file are mapped to the beginning of the memory segment. If the
        // segment’s memory size (p_memsz) is larger than the file size (p_filesz), the ‘‘extra’’
        // bytes are defined to hold the value 0 and to follow the segment’s initialized area. The file
        // size may not be larger than the memory size. Loadable segment entries in the program
        // header table appear in ascending order, sorted on the p_vaddr member.

        if ((lma_addr >= 0x80000000 && lma_addr < 0x80020000) || (lma_addr >= 0x00000 && lma_addr < 0x20000))
        {
            // IRAM Address
            if (en_print)
                printf("\nIRAM address space");
            for (uint32_t p = 0; p < mem_size; p += 4)
            {
                uint32_t word_line = ((uint8_t)p_seg->get_data()[p + 3] << 24) + ((uint8_t)p_seg->get_data()[p + 2] << 16) + ((uint8_t)p_seg->get_data()[p + 1] << 8) + (uint8_t)p_seg->get_data()[p];
                if (en_print)
                    printf("\nIRAM = %8x - %8x", p, word_line);
                mem_inst.mem.at(p) = (uint8_t)p_seg->get_data()[p];
                mem_inst.mem.at(p + 1) = (uint8_t)p_seg->get_data()[p + 1];
                mem_inst.mem.at(p + 2) = (uint8_t)p_seg->get_data()[p + 2];
                mem_inst.mem.at(p + 3) = (uint8_t)p_seg->get_data()[p + 3];
            }
        }
        else if ((lma_addr >= 0x90000000 && lma_addr < 0x90020000) || (lma_addr >= 0x20000000 && lma_addr < 0x20020000))
        {
            // DRAM Address
            if (en_print)
                printf("\nDRAM address space");
            for (uint32_t p = 0; p < mem_size; p += 4)
            {
                uint32_t word_line;
                if (p >= file_size)
                {
                    word_line = 0;
                }
                else
                {
                    word_line = ((uint8_t)p_seg->get_data()[p + 3] << 24) + ((uint8_t)p_seg->get_data()[p + 2] << 16) + ((uint8_t)p_seg->get_data()[p + 1] << 8) + (uint8_t)p_seg->get_data()[p];

                    mem_data.mem.at(p) = (uint8_t)p_seg->get_data()[p];
                    mem_data.mem.at(p + 1) = (uint8_t)p_seg->get_data()[p + 1];
                    mem_data.mem.at(p + 2) = (uint8_t)p_seg->get_data()[p + 2];
                    mem_data.mem.at(p + 3) = (uint8_t)p_seg->get_data()[p + 3];
                }
                if (en_print)
                    printf("\nDRAM = %8x - %8x", p, word_line);
            }
        }
        else
        {
            exit(-1);
        }
    }
    ELFIO::Elf64_Addr entry_point = program.get_entry();
    regs.PC = (uint32_t)entry_point;
    nPC = regs.PC;
    if (en_print)
        printf("\nEntry point: %8x", (uint32_t)entry_point);

    // cpu->core->riscv_soc->writeRstAddr((uint32_t) entry_point);
    // cpu->loaded = true;
    std::cout << std::endl
              << std::endl;
}

machine::~machine()
{
}

void machine::inst_dump()
{
    for (int i = 0; i < 37; i++)
    {
        printf("inst: %5s time: %5d\t ",INSTNAME[i],inst_cnt[i]);
        if (i % 4 == 3)
            printf("\n");
    }
    printf("\n");
}