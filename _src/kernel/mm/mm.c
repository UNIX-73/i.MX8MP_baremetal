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


static void* mmu_early_im_alloc(size_t bytes, size_t alignment)
{
    (void)alignment;

    return (void*)early_kalloc(bytes, "mm_early_identity_mapping_tbl", false);
}


static void mmu_early_im_free(void* addr)
{
#ifdef DEBUG
    char buf[200];
    stdint_to_ascii((STDINT_UNION) {.uint64 = (uintptr)addr}, STDINT_UINT64, buf, 200,
                    STDINT_BASE_REPR_HEX);

    uart_puts(&UART2_DRIVER, buf);
    uart_puts(&UART2_DRIVER, "\n\r");
#else
    PANIC("The early identity mapping allocations should not free any tables");
    (void)addr;
#endif
}


static void mm_reserve_device_and_kernel_mem()
{
    /* reserve memory for mmio */
    early_kalloc(MEM_GiB * 1, "mmio", true); // TODO: not hardcoded


    /* reserve memory for TF-A reserved zone */
    size_t tf_a_bytes = mm_info_kernel_start() - mm_info_ddr_start();
    ASSERT(tf_a_bytes % MMU_GRANULARITY_4KB == 0);
    early_kalloc(tf_a_bytes, "tf_a_protected", true);


    /* reserve memory for the text + bss + rodata + data + el2:1 stacks of the kernel */
    ASSERT(mm_info_kernel_size() % MMU_GRANULARITY_4KB == 0);
    early_kalloc(mm_info_kernel_size(), "kernel_static", true);
}


static mmu_handle mm_early_identity_mapping()
{
    mmu_handle h;
    mmu_init(&h, MMU_GRANULARITY_4KB, mmu_early_im_alloc, mmu_early_im_free);


    mmu_cfg device_cfg = mmu_cfg_new(1, MMU_AP_EL0_NONE_EL1_RW, 0, false, 1, 0, 0, 0);
    mmu_map(h, 0, 0, MEM_GiB, device_cfg, NULL);

    mmu_cfg mem_cfg = mmu_cfg_new(0, MMU_AP_EL0_NONE_EL1_RW, 0, false, 1, 0, 0, 0);
    mmu_map(h, MEM_GiB, MEM_GiB, 4 * MEM_GiB, mem_cfg, NULL);

    mmu_activate(h, true, true, false);

    return h;
}


void mm_early_init()
{
    mm_info_init();

    // init early kalloc. Used by the next initialization stages
    early_kalloc_init();


    mm_reserve_device_and_kernel_mem();


    mmu_handle identity_map_handle = mm_early_identity_mapping();

#ifdef DEBUG
    uart_puts(&UART2_DRIVER, "Identity mapping mmu: \n\r");
    mmu_debug_dump(identity_map_handle);
#endif
}

void mm_init()
{
}
