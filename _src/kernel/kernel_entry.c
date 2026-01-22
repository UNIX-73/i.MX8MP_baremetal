#include <arm/exceptions/exceptions.h>
#include <arm/tfa/smccc.h>
#include <boot/panic.h>
#include <drivers/arm_generic_timer/arm_generic_timer.h>
#include <drivers/interrupts/gicv3/gicv3.h>
#include <drivers/tmu/tmu.h>
#include <drivers/uart/uart.h>
#include <kernel/init.h>
#include <lib/memcpy.h>
#include <lib/stdint.h>
#include <lib/stdmacros.h>
#include <lib/string.h>

#include "../arm/mmu/mmu_pd.h"
#include "arm/cpu.h"
#include "arm/mmu/mmu.h"
#include "kernel/devices/drivers.h"
#include "kernel/mm/mm.h"
#include "lib/math.h"
#include "lib/unit/mem.h"
#include "mm/init/early_kalloc.h"


static void test_putc(char c)
{
    uart_putc(&UART2_DRIVER, c);
}


static void puts(const char* s, ...)
{
    va_list ap;
    va_start(ap, s);

    str_fmt_print(test_putc, s, ap);

    va_end(ap);
}

// Main function of the kernel, called by the bootloader (/boot/boot.S)
_Noreturn void kernel_entry()
{
    ARM_cpu_affinity aff = ARM_get_cpu_affinity();

    if (aff.aff0 == 0) {
        kernel_init();
        uart_puts(&UART2_DRIVER, "\x1B[2J\x1B[H"); // clear screen

        mm_early_init();

        uart_puts(&UART2_DRIVER, "MMU apparently not crashing\n\r");
    }


    puts("c=%c s=%s d=%d u=%u x=%x p=%p %%\n", 'A', NULL, -42, 42u, 0x2A, (void*)0x1234);


    loop
    {
    }
}