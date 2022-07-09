#include "memory.h"


MEMORY::MEMORY(std::string str) : name(str)
{
}

MEMORY::~MEMORY()
{
}

void MEMORY::dump(int length)
{
    std::cout<<"Memory Name: "<<name<<" Display Length: "<<length<<std::endl;
    for (uint32_t i = 0; i < length; i+=4)
    {
        printf("addr:%02x\t,data:0x%08x\r\n",i,get_u32(i));
    }
}

uint64_t MEMORY::get_u64(uint32_t addr)
{
    return ((((uint64_t)get_u32(addr+4))<<32)|get_u32(addr));
}
uint32_t MEMORY::get_u32(uint32_t addr)
{
    return ((((uint32_t)get_u16(addr+2))<<16)|get_u16(addr));
}
uint16_t MEMORY::get_u16(uint32_t addr)
{
    return ((((uint8_t)get_u8(addr+1))<<8)|get_u8(addr));
}
uint8_t MEMORY::get_u8(uint32_t addr)
{
    return mem.at(addr);
}

void MEMORY::set_u64(uint32_t addr,uint64_t data)
{
    set_u32(addr+4,data>>32);
    set_u32(addr,data);
}
void MEMORY::set_u32(uint32_t addr,uint32_t data)
{
    set_u16(addr+2,data>>16);
    set_u16(addr,data);
}
void MEMORY::set_u16(uint32_t addr,uint16_t data)
{
    set_u8(addr+1,data>>8);
    set_u8(addr,data);
}
void MEMORY::set_u8(uint32_t addr,uint8_t data)
{
    mem.at(addr) = data;
}
