#ifndef __UART_API__
#define __UART_API__
#include <stdint.h>
#define UART_DATA *(unsigned int *)0x10000000

void printf(char *fmt, ...);

void write_uart(char data);

#endif
