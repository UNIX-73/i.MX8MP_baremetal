#include <drivers/uart/uart.h>
#include <lib/kernel_utils.h>
#include <lib/stdmacros.h>

#include "lib/stdint.h"

void kernel_entry()
{
	FOREVER
	{
		UART_putc(UART_ID_2, (uint8)(_currentEL() + 48));

		for (volatile int i = 0; i < 200000; i++) {
			asm volatile("nop");
			asm volatile("nop");
			asm volatile("nop");
			asm volatile("nop");
			asm volatile("nop");
		}
	}
}