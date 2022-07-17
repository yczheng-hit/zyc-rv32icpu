#ifndef __CLIENT_API_H
#define __CLIENT_API_H
#include "difftest.pb.h"

#define SOCK_PATH "/home/zycccccc/handles/socket"
#define BUF_SIZE 256
extern difftest::Difftest data2server;
int client_init();
int client_communication();
int client_close();

#endif
