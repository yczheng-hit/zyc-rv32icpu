#ifndef __MEMORY_H_
#define __MEMORY_H_

#include <iostream>
#include <array>
class MEMORY
{
public:
    std::string name;
    std::array<uint8_t, 0x20000> mem;
    MEMORY(std::string str);
    ~MEMORY();
    void dump(int length);
    uint64_t get_u64(uint32_t addr);
    uint32_t get_u32(uint32_t addr);
    uint16_t get_u16(uint32_t addr);
    uint8_t get_u8(uint32_t addr);
    void set_u64(uint32_t addr,uint64_t data);
    void set_u32(uint32_t addr,uint32_t data);
    void set_u16(uint32_t addr,uint16_t data);
    void set_u8(uint32_t addr,uint8_t data);
};



#endif
