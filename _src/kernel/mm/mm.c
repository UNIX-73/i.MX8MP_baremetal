#include "kernel/mm/mm.h"

#include <boot/panic.h>
#include <frdm_imx8mp.h>

#include "./init/early_kalloc.h"
#include "arm/mmu/mmu.h"
#include "drivers/uart/uart.h"
#include "kernel/devices/drivers.h"
#include "lib/stdint.h"
#include "lib/stdmacros.h"
#include "lib/string.h"
#include "lib/unit/mem.h"
#include "mm_info.h"


static void* mmu_allocator(size_t bytes, size_t alignment)
{
    (void)alignment;

    return (void*)early_kalloc(bytes, "mmu alignment", false);
}


static void mmu_freer(void* addr)
{
    char buf[200];
    stdint_to_ascii((STDINT_UNION) {.uint64 = (uintptr)addr}, STDINT_UINT64, buf, 200,
                    STDINT_BASE_REPR_HEX);

    UART_puts(&UART2_DRIVER, buf);
    UART_puts(&UART2_DRIVER, "\n\r");


    return;
}


void mm_early_init()
{
    mm_info_init();

    // init early kalloc. Used by the next initialization stages
    early_kalloc_init();


    early_kalloc(MEM_GiB * 2, "reserved", true);


    mmu_handle h;
    mmu_init(&h, MMU_GRANULARITY_4KB, mmu_allocator, mmu_freer);

    mmu_cfg cfg = mmu_cfg_new(1, MMU_AP_EL0_NONE_EL1_RW, 0, false, 1, 0, 0, 0);


    mmu_map_ctx ctx;

    bool result = mmu_map(h, MEM_KiB * 4, MEM_KiB * 4, MEM_GiB, cfg, &ctx);




    result = mmu_map(h, 0, 0, MEM_KiB * 4, cfg,NULL);


    (void)result;
}

void mm_init()
{
}
