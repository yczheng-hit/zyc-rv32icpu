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
#include <signal.h>
#include <sys/wait.h>

#include "client_api.h"
#include <string>
#include <iostream>


difftest::Difftest data2server;
int sockfd;
int client_init(void)
{
    if ((sockfd = socket(AF_UNIX, SOCK_STREAM, 0)) < 0)
    {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    struct sockaddr_un servaddr;
    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sun_family = AF_UNIX;
    strcpy(servaddr.sun_path, SOCK_PATH);

    if (connect(sockfd, (struct sockaddr *)&servaddr, sizeof(servaddr)) < 0)
    {
        perror("connect");
        exit(EXIT_FAILURE);
    }

    return 0;
}

int client_communication(void)
{
    char buf[BUF_SIZE];
    int nbuf;
    std::string se_str;

    data2server.SerializeToString(&se_str);

    nbuf = 0;
    send(sockfd, (void *)se_str.c_str(), se_str.length(), 0);
    memset(buf,0,BUF_SIZE);
    nbuf = recv(sockfd, buf, BUF_SIZE, 0);
    if(nbuf<0)
        return -1;
    buf[nbuf] = 0;
    printf("\nnubf: %d echo msg: \"%s\"\n",nbuf, buf);

    // std::cout << "serialization result:" << se_str << std::endl; //序列化后的字符串内容是二进制内容，非可打印字符，预计输出乱码
    std::cout << std::endl
         << "debugString:" << data2server.DebugString();
    if(!strcmp(buf,"OK"))
        return 0;
    else
        return -1;
}

int client_close(void)
{
    close(sockfd);
    return 0;
}
