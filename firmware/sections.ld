MEMORY
{
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 0x20000
    RAM (xrw) : ORIGIN = 0x20000000, LENGTH = 0x20000 
}
SECTIONS {
    .text :
    {
        . = ALIGN(4);
        *(.text)
        *(.text*)
        *(.rodata)
        *(.rodata*)
        *(.srodata)
        *(.srodata*)
        . = ALIGN(4);
        _etext = .;
        _sidata = _etext;
    } >FLASH
    .data : 
    {
        . = ALIGN(4);
        _sdata = .;
        _ram_start = .;
        . = ALIGN(4);
        *(.data)
        *(.data*)
        *(.sdata)
        *(.sdata*)
        . = ALIGN(4);
        _edata = .;
    } >RAM
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss)
        *(.bss*)
        *(.sbss)
        *(.sbss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } >RAM
    .heap_stack :
    {
        . = ALIGN(4);
        _heap_start = .;
        _heap_end = .;
        _stack_start = .;
        . = . + 0x10000;
        _stack_end = .;
    } >RAM
    __StackTop = ORIGIN(RAM) + LENGTH(RAM);
	PROVIDE(__stack = __StackTop);
}
