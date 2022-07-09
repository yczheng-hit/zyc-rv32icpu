#ifndef __SERVER_API_H
#define __SERVER_API_H

#define SOCK_PATH "/home/zycccccc/handles/socket"
#define BUF_SIZE 256
#include "machine.h"
#include "difftest.pb.h"
int server_init(void);
// int server_communication();
uint32_t server_communication();
int server_close(void);
extern difftest::Difftest data4server;
#endif
