#ifndef __MATH_H_
#define __MATH_H_
#include <stdbool.h>
#define ABS(X) (X >= 0 ? X : -X)
void MUL(int src, int dst, int* pro);
void DIV(int src, int dst, int *quo, int *rem);
#endif
