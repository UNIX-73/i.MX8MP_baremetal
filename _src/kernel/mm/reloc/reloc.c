#include "reloc.h"

#include <lib/mem.h>
#include <lib/stdbool.h>
#include <lib/stdmacros.h>

#include "../mm_info.h"
#include "../phys/page_allocator.h"
#include "arm/mmu/mmu.h"
#include "kernel/mm.h"
#include "kernel/panic.h"

extern _Noreturn void _jmp_to_with_offset(void* to, size_t offset);
extern _Noreturn void _reloc_cfg_end(void);


// allocator freer for the early identity mapping tables
static void reloc_free(void* addr)
{
    page_free((mm_page) {.phys = (p_uintptr)addr});
}


static void* reloc_alloc(size_t bytes, size_t)
{
    return (void*)page_malloc(page_allocator_bytes_to_order(bytes),
                              (mm_page_data) {
                                  .device_mem = false,
                                  .tag = "reloc_test",
                                  .permanent = false,
                                  .virt = 0,
                              })
        .phys;
}


void mm_reloc_kernel()
{
    ASSERT(mmu_is_active());

    mmu_reconfig_allocators(&mm_mmu_h, reloc_alloc, reloc_free);


    // device memory
    mmu_pg_cfg device_cfg = mmu_pg_cfg_new(1, MMU_AP_EL0_NONE_EL1_RW, 0, false, 1, 0, 0, 0);
    mmu_map(&mm_mmu_h, KERNEL_BASE, 0, MEM_GiB, device_cfg, NULL);


    // kernel memory TODO: watch if mapping all the ddr is neccesary or only the used memory
    mmu_pg_cfg mem_cfg = mmu_pg_cfg_new(0, MMU_AP_EL0_NONE_EL1_RW, 0, false, 1, 0, 0, 0);
    mmu_map(&mm_mmu_h, KERNEL_BASE + MEM_GiB, MEM_GiB, 4 * MEM_GiB, mem_cfg, NULL);


    // jumps to the asm fn _reloc_cfg_end (relocated with KERNEL BASE). _reloc_cfg_end returns to
    // reloc_cfg_end
    _jmp_to_with_offset(_reloc_cfg_end, KERNEL_BASE);
}


void reloc_cfg_end()
{
    // reloc the allocated tables pointers offsets
    mmu_reloc(&mm_mmu_h, KERNEL_BASE);


    // unmap the identity mapping
    mmu_unmap(&mm_mmu_h, 0x0, MEM_GiB * 5, NULL);


    extern _Noreturn void _return_to_kernel_entry(size_t physmap_offset);
    _return_to_kernel_entry(KERNEL_BASE);
}
