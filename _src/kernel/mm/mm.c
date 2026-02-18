#include "kernel/mm.h"

#include <arm/mmu/mmu.h>
#include <frdm_imx8mp.h>
#include <kernel/panic.h>
#include <lib/stdint.h>

#include "lib/mem.h"


extern uintptr _get_pc(void);


mmu_handle mm_mmu_h;


bool mm_kernel_is_relocated()
{
    uintptr pc = _get_pc();

    return ((pc >> 47) & 0x1FFFFUL) == 0x1FFFFUL;
}



void mm_dbg_print_mmu()
{
    mmu_debug_dump(&mm_mmu_h, MMU_TBL_LO);
    mmu_debug_dump(&mm_mmu_h, MMU_TBL_HI);
}
