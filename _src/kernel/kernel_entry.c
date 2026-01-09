#include <arm/exceptions/exceptions.h>
#include <arm/tfa/smccc.h>
#include <boot/panic.h>
#include <drivers/interrupts/gicv3/gicv3.h>
#include <drivers/uart/uart.h>
#include <kernel/init.h>
#include <lib/memcpy.h>
#include <lib/stdint.h>
#include <lib/stdmacros.h>
#include <lib/string.h>

#include "arm/cpu.h"
#include "kernel/devices/drivers.h"

// Main function of the kernel, called by the bootloader (/boot/boot.S)
_Noreturn void kernel_entry()
{
    ARM_cpu_affinity aff = ARM_get_cpu_affinity();

    if (aff.aff0 == 0)
    {
        kernel_init();
        uintptr entry = 0x40200000;

        UART_puts(&UART2_DRIVER, "CORE 0\n\r");

        for (size_t i = 0; i < 400000; i++)
            asm volatile("nop");

        _smc_call(PSCI_CPU_ON_FID64, 0x0000001, entry, 0x0, 0x0, 0x0, 0x0, 0x0);
    }
    else
    {
        UART_puts_sync(&UART2_DRIVER, "CORE 1");
        for (size_t i = 0; i < 4000000; i++)
            asm volatile("nop");

        PANIC("CORE X");
        //  _smc_call(PSCI_SYSTEM_OFF_FID, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0);
    }


    loop
    {
    }
}