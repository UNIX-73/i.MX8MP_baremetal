#include <drivers/uart/uart.h>
#include <drivers/uart/uart_raw.h>
#include <lib/stdint.h>

void UART_putc(UART_ID id, uint8 c)
{
	UartUtxdValue utxd = {(uint32)c};
	UART_UTXD_write(UART_N_BASE[id], utxd);
}




/*
	void UART_puts(UART_ID id, char *s)
	{
		// TODO:
	}
*/