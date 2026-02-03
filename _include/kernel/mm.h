#pragma once

#ifndef __ASSEMBLER__


#    include <arm/mmu/mmu.h>
#    include <lib/mem.h>
#    include <lib/stdbool.h>
#    include <lib/stdint.h>
#    include <lib/unit/mem.h>


void mm_early_init();

/// it expects to be provided the identity mapping handle. It will free it, and replace it by the
/// kernel mmu handle after relocation
void mm_init();


bool mm_kernel_is_relocated();

p_uintptr mm_kva_to_kpa(v_uintptr va);
#    define mm_kva_to_kpa_ptr(va) (void*)mm_kva_to_kpa((v_uintptr)(va))

v_uintptr mm_kpa_to_kva(p_uintptr pa);
#    define mm_kpa_to_kva_ptr(pa) (void*)mm_kpa_to_kva((p_uintptr)(pa))


#endif

#define KERNEL_BASE 0xFFFF800000000000
