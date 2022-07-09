#include <stdint.h>
#include <stdbool.h>
#include "uart_api.h"
#include "math.h"

void bubble_sort(int *arr, int size)
{
	int i, j, tmp;
	for (i = 0; i < size - 1; i++)
	{
		for (j = 0; j < size - i - 1; j++)
		{
			if (arr[j] > arr[j + 1])
			{
				tmp = arr[j];
				arr[j] = arr[j + 1];
				arr[j + 1] = tmp;
			}
		}
	}
}

void main(void)
{
	int a;
	int b = 10, c = 5;
	int quo = 0, rem = 0;
	UART_DATA = 'a';
	UART_DATA = '\n';
	write_uart('b');
	write_uart('\n');
	// printf test
	printf("              _                      \n\
             | |                         \n\
__      _____| | ___ ___  _ __ ___   ___ \n\
\\ \\ /\\ / / _ \\ |/ __/ _ \\| '_ ` _ \\ / _ \\\n\
 \\ V  V /  __/ | (_| (_) | | | | | |  __/\n\
  \\_/\\_/ \\___|_|\\___\\___/|_| |_| |_|\\___|\n");
	printf("printf test.\n");
	printf("num is : %d.\n", 114514);
	printf("num is : %x.\n", 114514);

	// div test
	printf("div test.\n");
	DIV(b, c, &quo, &rem);
	printf("%d / %d = %d.\n", b, c, quo);
	printf("%d %% %d = %d.\n", b, c, rem);
	// loop test
	while (a < 10)
	{
		printf("loop test. %d\n", a);
		a++;
	}

	// Fibonacci test
	int t1, t2, next;
	t2 = 1;
	printf("Fibonacci test.\n");
	for (int i = 1; i <= 10; ++i)
	{
		printf("%d ", t1);
		next = t1 + t2;
		t1 = t2;
		t2 = next;
	}
	printf("%d\n", t1);

	// sort test
	int array[] = {1, 5, 7, 121, 426, 77, 21, 13, 1, -5, -7};
	printf("sort test, original array: \n");
	for (int i = 0; i < sizeof(array) / 4; i++)
	{
		printf("%d ", array[i]);
	}
	printf("\n");
	bubble_sort(array, sizeof(array) / 4);
	printf("sort test, sorted array: \n");
	for (int i = 0; i < sizeof(array) / 4; i++)
	{
		printf("%d ", array[i]);
	}
	printf("\n");

	printf("test finished!\n");

	__asm__ volatile(".word 0x0000007f\n.align 2");
}
