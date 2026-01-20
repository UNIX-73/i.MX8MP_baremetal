#include "arm/mmu/mmu.h"

#include <lib/lock/spinlock.h>
#include <lib/math.h>
#include <lib/mem.h>
#include <lib/stdint.h>
#include <lib/stdmacros.h>

#include "boot/panic.h"
#include "mmu_helpers.h"
#include "mmu_pd.h"
#include "mmu_types.h"


void mmu_init(mmu_handle* h, mmu_granularity g, mmu_alloc alloc, mmu_free free)
{
    mmu_tbl tbl0 = alloc_tbl(alloc, g, true, NULL);

    *h = (mmu_handle) {
        .g_ = g,
        .alloc_ = alloc,
        .free_ = free,
        .tbl0_ = (void*)tbl0.pds,
    };

    spinlock_init(&h->slock_);
}


mmu_cfg mmu_cfg_new(uint8 attr_index, mmu_access_permission ap, uint8 shareability, bool non_secure,
                    bool access_flag, bool pxn, bool uxn, uint8 sw)
{
    return (mmu_cfg) {
        .attr_index = attr_index,
        .ap = ap,
        .shareability = shareability,
        .non_secure = non_secure,
        .access_flag = access_flag,
        .pxn = pxn,
        .uxn = uxn,
        .sw = sw,
    };
}


void mmu_activate(mmu_handle h, bool d_cache, bool i_cache, bool align_trap);


static void UNLOCKED_free_subtree(mmu_handle h, mmu_tbl tbl)
{
    mmu_granularity g = h.g_;

    for (size_t i = 0; i < tbl_entries_(g); i++)
        if (pd_get_valid(tbl.pds[i]) && pd_get_type(tbl.pds[i]) == MMU_PD_TABLE)
            UNLOCKED_free_subtree(h, tbl_from_td(tbl.pds[i], g));

    h.free_(tbl.pds);
}


static bool UNLOCKED_map_(mmu_handle h, v_uintptr virt, p_uintptr phys, size_t size, mmu_cfg cfg,
                          mmu_map_ctx* ctx)
{
#ifdef DEBUG
    if (ctx)
        ctx->recursion_depth += 1;
#endif

    if (size == 0)
        return true;


    mmu_granularity g = h.g_;
    mmu_tbl tbl0 = tbl0_from_handle(h);
    mmu_alloc alloc = h.alloc_;

    if (size % g != 0 || virt % g != 0 || phys % g != 0)
        return false;


    mmu_tbl_level target_lvl;
    size_t cover;
    for (target_lvl = MMU_TBL_LV1; target_lvl <= max_level(g); target_lvl++)
    {
        cover = bd_cover_bytes_(g, target_lvl);

        if (size >= bd_cover_bytes_(g, target_lvl) && virt % cover == 0 && phys % cover == 0)
            break;
    }

    DEBUBG_ASSERT(virt % cover == 0);
    DEBUBG_ASSERT(phys % cover == 0);


    // the main loop of the fn, finds the actual table of the target level
    size_t i;
    mmu_tbl tbl = tbl0;
    for (mmu_tbl_level l = MMU_TBL_LV0; l <= target_lvl; l++)
    {
        i = table_index(virt, g, l);

        mmu_hw_pd pd = mmu_tbl_get_pd(tbl, i);

        // not invalid
        if (!pd_get_valid(pd))
        {
            // --- invalid descriptor ---
            // allocate a new table
            mmu_tbl next = alloc_tbl(alloc, g, true, ctx);

            // link the new allocated table in the current table level
            tbl.pds[i] = td_build(next, g);
            tbl = next;

            continue;
        }

        switch (pd_get_type(pd))
        {
            case MMU_PD_BLOCK:
                tbl = split_block(h, tbl, i, l, ctx);
                continue;
            case MMU_PD_TABLE:
                tbl = tbl_from_ptr(pd_get_output_address(pd, g), g);
                continue;
            default:
                PANIC("mmu_map: err");
        }
    }


    // build the block descriptor
    mmu_hw_pd old = tbl.pds[i];

    tbl.pds[i] = bd_build(cfg, phys, g);

    // if it was a table, free it (and all the subtables)
    if (pd_get_type(old) == MMU_PD_TABLE)
        UNLOCKED_free_subtree(h, tbl_from_td(old, g));

    // recurse until covering all the bytes
    return UNLOCKED_map_(h, virt + cover, phys + cover, size - cover, cfg, ctx);
}


bool mmu_map(mmu_handle h, v_uintptr virt, p_uintptr phys, size_t size, mmu_cfg cfg,
             mmu_map_ctx* ctx)
{
    bool result;

    if (ctx)
        *ctx = (mmu_map_ctx) {
#ifdef DEBUG
            .recursion_depth = 0,
#endif
            .alocated_tbls = 0,
        };


    spin_lock(&h.slock_);
    result = UNLOCKED_map_(h, virt, phys, size, cfg, ctx);
    spin_unlock(&h.slock_);

    return result;
}
