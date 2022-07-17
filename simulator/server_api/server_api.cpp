#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <ctype.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <netdb.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/wait.h>

#include "server_api.h"
#include <string>
#include <iostream>

difftest::Difftest data4server;
int listenfd, connfd;
char buf[BUF_SIZE];
int nbuf;
int server_init(void)
{
    if ((listenfd = socket(AF_UNIX, SOCK_STREAM, 0)) < 0)
    {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    struct sockaddr_un servaddr;
    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sun_family = AF_UNIX;
    strcpy(servaddr.sun_path, SOCK_PATH);

    unlink(SOCK_PATH);
    if (bind(listenfd, (struct sockaddr *)&servaddr, sizeof(servaddr)) < 0)
    {
        perror("bind");
        exit(EXIT_FAILURE);
    }
    chmod(SOCK_PATH, 00640);

    if (listen(listenfd, SOMAXCONN) < 0)
    {
        perror("listen");
        exit(EXIT_FAILURE);
    }
    if ((connfd = accept(listenfd, NULL, NULL)) < 0)
    {
        perror("accept");
        // continue;
    }
    return 0;
}

uint32_t server_communication()
{
    nbuf = recv(connfd, buf, BUF_SIZE, 0);
    std::string dese_str(buf, nbuf);
    if (cpu->verbose)
        std::cout << "-------------" << std::endl;
    if(dese_str == "")
        return 1;
    if (!data4server.ParseFromString(dese_str))
    {
        std::cerr << "Failed to parse student." << std::endl;
        // strcpy(buf,"ERROR!\0");
        // nbuf = 7;
        // send(connfd, buf, nbuf, 0);
        return -1;
    }
    //打印解析后的student消息对象
    // std::cout << "data4server debugString: " << data4server.DebugString();
    // std::cout << std::endl
    //   << "pc: " << data4server.pc() << std::endl;
    cpu->regs_cli.PC = (uint32_t)data4server.pc();
    switch (data4server.type())
    {
    case difftest::Difftest::WRITE_REG:
        cpu->type_cli = WRITE_REG;
        if (cpu->verbose)
            std::cout << "Write Reg" << std::endl;
        break;
    case difftest::Difftest::WRITE_MEM:
        cpu->type_cli = WRITE_MEM;
        if (cpu->verbose)
            std::cout << "Write Mem" << std::endl;
        break;
    case difftest::Difftest::CHECK_REG:
        cpu->type_cli = CHECK_REG;
        if (cpu->verbose)
            std::cout << "Check Reg" << std::endl;
        break;
    case difftest::Difftest::BRANCH:
        cpu->type_cli = BRANCH;
        if (cpu->verbose)
            std::cout << "Check Reg" << std::endl;
        break;
    }
    if (data4server.has_dest_addr())
    {
        cpu->addr_cli = (uint32_t)data4server.dest_addr();
        if (cpu->verbose)
            std::cout << "dest addr: " << data4server.dest_addr() << std::endl;
    }
    if (data4server.has_dest_data())
    {
        cpu->data_cli = (uint32_t)data4server.dest_data();
        if (cpu->verbose)
            std::cout << "dest data: " << data4server.dest_data() << std::endl;
    }
    if (data4server.has_dest_reg())
    {
        cpu->regid_cli = (uint32_t)data4server.dest_reg();
        if (cpu->verbose)
            std::cout << "dest reg: " << data4server.dest_reg() << std::endl;
    }
    for (int i = 0; i < data4server.regs_size(); i++)
    {
        const difftest::Difftest::Reigster &reg = data4server.regs(i);
        if (cpu->verbose)
            std::cout << i << " reg id: " << reg.id() << " reg data:" << reg.data() << std::endl;
        cpu->regs_cli.regs[reg.id()] = (uint32_t)reg.data();
    }
    // server_response("OK",3);
    // buf[0] = 'O';
    // buf[1] = 'K';
    // buf[2] = 0;
    // nbuf = 3;
    // send(connfd, buf, nbuf, 0);

    // google::protobuf::ShutdownProtobufLibrary();

    return 0;
}

void server_response(char * buf2client,int nbuf2client)
{
    // strcpy(buf,buf2client);
    // nbuf = 3;
    send(connfd, buf2client, nbuf2client, 0);
}

int server_close()
{

    close(connfd);
    return 0;
}