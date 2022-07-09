#include "uart_api.h"
#include <stdarg.h>
#include "math.h"
void write_uart(char data)
{
    UART_DATA = data;
}
const char digits[] = "0123456789abcdef";
static void
printint(int xx, int base, int sign)
{
    // char digits[] = "0123456789abcdef";
    char buf[16];
    int i;
    unsigned int x;
    int quo, rem;

    if (sign && (sign = xx < 0))
        x = -xx;
    else
        x = xx;

    i = 0;
    do
    {
        DIV(x, base, &quo, &rem);
        buf[i++] = digits[rem];
        x = quo;
    } while ((quo) != 0);

    if (sign)
        buf[i++] = '-';

    while (--i >= 0)
        write_uart(buf[i]);
}

void printf(char *fmt, ...)
{
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    {
        if (c != '%')
        {
            write_uart(c);
            continue;
        }
        c = fmt[++i] & 0xff;
        if (c == 0)
            break;
        switch (c)
        {
        case 'd':
            printint(va_arg(ap, int), 10, 1);
            break;
        case 'x':
            printint(va_arg(ap, int), 16, 1);
            break;
        case 's':
            if ((s = va_arg(ap, char *)) == 0)
                s = "(null)";
            for (; *s; s++)
                write_uart(*s);
            break;
        case 'c':
            write_uart(va_arg(ap, int));
            break;
        case '%':
            write_uart('%');
            break;
        default:
            write_uart('%');
            write_uart(c);
            break;
        }
    }
}
