#include <arm/exceptions/exceptions.h>
#include <drivers/uart/uart.h>
#include <kernel/panic.h>
#include <lib/stdint.h>
#include <lib/stdmacros.h>
#include <lib/string.h>

#define PANIC_UART_OUTPUT UART_ID_2
#define PANIC_puts(str) UART_puts(PANIC_UART_OUTPUT, str)

#define PANIC_MESSAGE_LEN_INIT_VALUE 4096
#define PANIC_FILE_LEN_INIT_VALUE 1024

// The global static scope variables and buffers allow rust to easily send the
// message in a c format string with \0. It also allows to set the panic
// information without throwing the panic.

uint64 PANIC_MESSAGE_BUF_SIZE;
uint64 PANIC_FILE_BUF_SIZE;

// NOTE: If implementing multithreading the panic infos must be protected by a
// mutex

uint8 *PANIC_MESSAGE_BUF_PTR;
uint8 *PANIC_FILE_BUF_PTR;
uint32 PANIC_LINE;
uint32 PANIC_COL;

_Alignas(16) static uint8 panic_message_buffer[PANIC_MESSAGE_LEN_INIT_VALUE];
_Alignas(16) static uint8 panic_file_buffer[PANIC_FILE_LEN_INIT_VALUE];

void init_panic()
{
	PANIC_MESSAGE_BUF_SIZE = sizeof(panic_message_buffer);
	PANIC_FILE_BUF_SIZE = sizeof(panic_file_buffer);

	PANIC_MESSAGE_BUF_PTR = panic_message_buffer;
	PANIC_FILE_BUF_PTR = panic_file_buffer;

	PANIC_LINE = 0;
	PANIC_COL = 0;

	strcopy((char *)PANIC_MESSAGE_BUF_PTR,
			"Panic message not defined and not changed from init_panic() "
			"initialization stage.",
			PANIC_MESSAGE_LEN_INIT_VALUE);

	strcopy((char *)PANIC_FILE_BUF_PTR, "Panic file not defined",
			PANIC_FILE_LEN_INIT_VALUE);
}

static void log_system_info();

// TODO: use panic via exceptions
_Noreturn void panic()
{
	char buf[200];
	PANIC_puts("\n\r[PANIC!]");

	PANIC_puts("\n\rPanic message:\t");
	PANIC_puts((char *)PANIC_MESSAGE_BUF_PTR);

	PANIC_puts("\n\rPanic file:\t");
	PANIC_puts((char *)PANIC_FILE_BUF_PTR);
	PANIC_puts(" at line ");

	PANIC_puts(stdint_to_ascii((STDINT_UNION){.uint32 = PANIC_LINE},
							   STDINT_UINT32, buf, 200, STDINT_BASE_REPR_DEC));

	if (PANIC_COL != 0) {
		PANIC_puts(":");
		PANIC_puts(stdint_to_ascii((STDINT_UNION){.uint32 = PANIC_COL},
								   STDINT_UINT32, buf, 200,
								   STDINT_BASE_REPR_DEC));
	}

	log_system_info();

	loop {}	 // TODO: TUI with options
}

void set_panic(PanicInfo panic_info)
{
	strcopy((char *)PANIC_MESSAGE_BUF_PTR, panic_info.message,
			PANIC_MESSAGE_LEN_INIT_VALUE);

	strcopy((char *)PANIC_FILE_BUF_PTR, panic_info.location.file,
			PANIC_FILE_LEN_INIT_VALUE);

	PANIC_LINE = panic_info.location.line;
	PANIC_COL = panic_info.location.col;
}

_Noreturn void set_and_throw_panic(PanicInfo panic_info)
{
	set_panic(panic_info);
	panic();
}

// System info

static void log_system_info()
{
	EXCEPTION_STATUS status = exceptions_get_status();

	PANIC_puts("\n\rExceptions state:\n\r");

	char *enabled = "enabled\n\r";
	char *disabled = "disabled\n\r";

	PANIC_puts("\tFIQ:    ");
	PANIC_puts(status.fiq ? enabled : disabled);

	PANIC_puts("\tIRQ:    ");
	PANIC_puts(status.irq ? enabled : disabled);

	PANIC_puts("\tSError: ");
	PANIC_puts(status.serror ? enabled : disabled);

	PANIC_puts("\tDebug:  ");
	PANIC_puts(status.debug ? enabled : disabled);

	// TODO: log registers
}