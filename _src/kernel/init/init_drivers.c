// The purpose of this file is to manually set the initialization stages of the
// drivers, as a driver can need to initialize before and after irqs are enabled

#include <drivers/interrupts/gicv3/gicv3.h>
#include <drivers/uart/uart.h>
#include <kernel/init.h>

static void uart_stage0()
{
	for (UART_ID id = UART_ID_1; id <= UART_ID_4; id++) {
		UART_init_stage0(id);
	}
}

static void uart_stage1() { UART_init_stage1(UART_ID_2); }

KERNEL_INITCALL(uart_stage0, KERNEL_INITCALL_STAGE0);
KERNEL_INITCALL(uart_stage1, KERNEL_INITCALL_STAGE1);
KERNEL_INITCALL(uart_irq_init, KERNEL_INITCALL_STAGE2);
