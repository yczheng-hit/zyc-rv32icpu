#include "math.h"

void MUL(int src, int dst, int *pro)
{
    bool sign = ((src ^ dst) < 0); //判断符号
    int res = 0;                   //结果
    int muled = ABS(src);          //被乘数
    int mul = ABS(dst);            //乘数

    for (int i = 31; i >= 0; i--)
    { //类似贪心算法，移位求解
        if ((1 << i) <= dst)
        {
            res = res + muled << i;
            mul = mul - (1 << i);
        }
    }
    sign ? (*pro = -res) : (*pro = res);
}

void DIV(int src, int dst, int *quo, int *rem)
{
    bool sign = ((src ^ dst) < 0); //判断符号
    int res = 0;                   //结果
    int dived = ABS(src);          //被除数
    int div = ABS(dst);            //除数

    for (int i = 31; i >= 0; i--)
    { //类似贪心算法，移位求解
        if (dived >> i >= dst)
        {
            res = res + (1 << i);
            dived = dived - (div << i);
        }
    }
    sign ? (*quo = -res) : (*quo = res);
    *rem = dived;
}
