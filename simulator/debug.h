#ifndef __DEBUG_H_
#define __DEBUG_H_
#include "stdarg.h"
// #define DEBUG
#define DBG(...) \
if(cpu->debug)\
do{ \
    fprintf(stdout, "\033[0m[DEBUG]%s %s(Line %d): ",__FILE__,__FUNCTION__,__LINE__); \
    fprintf(stdout, __VA_ARGS__); \
}while(0)

#define DBG_TO_FILE(FD,...) \
do{ \
    fprintf(FD, "\[DEBUG]%s %s(Line %d): ",__FILE__,__FUNCTION__,__LINE__); \
    fprintf(FD, __VA_ARGS__); \
}while(0)

#define TRACE(...)\
if(cpu->trace)\
do\
{\
  fprintf(cpu->pFile, "[TRACE]%s %s(Line %d):\t",__FILE__,__FUNCTION__,__LINE__); \
    fprintf(cpu->pFile, __VA_ARGS__); \
} while (0);


static inline void panic(const char *format, ...) {
  char buf[BUFSIZ];
  va_list args;
  va_start(args, format);
  vsprintf(buf, format, args);
  fprintf(stderr, "%s", buf);
  va_end(args);
  fprintf(stderr, "Execution history and memory dump in dump.txt\n");
  exit(-1);
}

#endif
