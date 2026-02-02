
#include "panic_puts.h"

#include <lib/stdarg.h>
#include <lib/string.h>

#include "drivers/uart/uart.h"
#include "kernel/devices/drivers.h"


#define PANIC_UART_OUTPUT UART2_DRIVER


static void panic_putc_colored(char c)
{
    uart_putc_sync(&PANIC_UART_OUTPUT, c);

    if (c == '\n') {
        uart_puts_sync(&PANIC_UART_OUTPUT, "\r" ANSI_ERASE_LINE);
    }
}


void panic_puts(const char* s, ...)
{
    va_list ap;
    va_start(ap, s);

    str_fmt_print(panic_putc_colored, s, ap);

    va_end(ap);
}
