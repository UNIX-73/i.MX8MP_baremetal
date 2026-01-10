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

#include "arm/cpu.h"
#include "kernel/devices/drivers.h"

static void test_timer(timer_arg arg)
{
    uint64* call_n = arg;

    char buf[50];
    stdint_to_ascii((STDINT_UNION) {.uint64 = (*call_n)++}, STDINT_UINT64, buf, 50,
                    STDINT_BASE_REPR_DEC);

    UART_puts(&UART2_DRIVER, buf);
    UART_puts(&UART2_DRIVER, "\n\r");


    AGT_timer_schedule_delta(&AGT0_DRIVER, 1e6, test_timer, arg);
}

extern void _secondary_entry(void);

// Main function of the kernel, called by the bootloader (/boot/boot.S)
_Noreturn void kernel_entry()
{
    ARM_cpu_affinity aff = ARM_get_cpu_affinity();

    if (aff.aff0 == 0)
    {
        kernel_init();

        int8 temp = TMU_get_temp(&TMU_DRIVER);
        char buf[30];
        stdint_to_ascii((STDINT_UNION) {.int8 = temp}, STDINT_INT8, buf, 30, STDINT_BASE_REPR_DEC);

        UART_puts(&UART2_DRIVER, "\n\rCurrent temp: ");
        UART_puts(&UART2_DRIVER, buf);
        UART_puts(&UART2_DRIVER, "°\n\r");
    }


    if (aff.aff0 < 3)
    {
        _smc_call(PSCI_CPU_ON_FID64, aff.aff0 + 1, (uintptr)_secondary_entry, 0x0, 0x0, 0x0, 0x0,
                  0x0);
    }

    uint64 call_n = 0;

    if (aff.aff0 == 0)
    {
        for (size_t i = 0; i < 900000; i++)
        {
            asm volatile("nop");
        }

        asm volatile("nop");

        UART_puts(&UART2_DRIVER, "CORE 0");


        AGT_timer_schedule_delta(&AGT0_DRIVER, 3e9 , test_timer, &call_n);
    }
    else
    {
        char buf[200];
        stdint_to_ascii((STDINT_UNION) {.uint64 = aff.aff0}, STDINT_UINT64, buf, 200,
                        STDINT_BASE_REPR_DEC);
        UART_puts(&UART2_DRIVER, "CORE ");
        UART_puts(&UART2_DRIVER, buf);
        UART_puts(&UART2_DRIVER, "\n\r");
    }

    loop
    {
    }
}