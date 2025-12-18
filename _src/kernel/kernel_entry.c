
#define DRIVERS

#include <arm/exceptions/exceptions.h>
#include <drivers/uart/uart.h>
#include <kernel/panic.h>
#include <lib/memcpy.h>
#include <lib/stdint.h>
#include <lib/stdmacros.h>
#include <lib/string.h>

#include "arm/cpu.h"
#include "arm/sysregs.h"
#include "drivers/interrupts/gicv3/gicv3_raw/gicr_typer.h"

static void kernel_init()
{
	init_panic();
	UART_init(UART_ID_2);

	exceptions_set_status((EXCEPTION_STATUS){
		.fiq = true,
		.irq = true,
		.serror = true,
		.debug = true,
	});
}

extern uint64 _ARM_ICC_SRE_EL2();
extern uint64 _ARM_HCR_EL2();

// Main function of the kernel, called by the bootloader (/boot/boot.S)
_Noreturn void kernel_entry()
{
	kernel_init();

	UART_puts(UART_ID_2, "Hello test!\n\r");

	char buf[500];

	for (size_t i = 0; i < 4; i++) {
		GicrTyper r = GICV3_GICR_TYPER_read(i);

		uint32 affinity =
			U32_FROM_CPU_AFFINITY(GICV3_GICR_TYPER_BF_get_AffinityValue(r));

		UART_puts(UART_ID_2, "ID: ");
		UART_puts(UART_ID_2, stdint_to_ascii((STDINT_UNION){.uint32 = affinity},
											 STDINT_UINT32, buf, 200,
											 STDINT_BASE_REPR_BIN));
		UART_puts(UART_ID_2, "\n\r");
	}

	uint64 icc_sre = _ARM_HCR_EL2();
	UART_puts(UART_ID_2,
			  stdint_to_ascii((STDINT_UNION){.uint64 = icc_sre}, STDINT_UINT64,
							  buf, 200, STDINT_BASE_REPR_BIN));

	loop
	{
		uint8 data;

		if (UART_read(UART_ID_2, &data)) {
			UART_putc(UART_ID_2, data);
		}
	}

	loop {}
}