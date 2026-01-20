#pragma once
#include <lib/mem.h>
#include <lib/stdbool.h>
#include <lib/stdint.h>

/// MMU page descriptor
typedef struct
{
    uint64 v;
} mmu_hw_pd;


/// MMU table
typedef struct
{
    mmu_hw_pd* pds;
} mmu_tbl;


typedef enum
{
    MMU_TBL_LV0 = 0,
    MMU_TBL_LV1,
    MMU_TBL_LV2,
    MMU_TBL_LV3,
} mmu_tbl_level;


typedef enum
{
    MMU_PD_BLOCK = 0,
    MMU_PD_TABLE = 1,
} mmu_pd_type;


typedef enum
{
    MMU_SHAREABILITY_NON_SHAREABLE = 0b00,
    MMU_SHAREABILITY_RESERVED = 0b01,
    MMU_SHAREABILITY_OUTER_SHAREABLE = 0b10,
    MMU_SHAREABILITY_INNER_SHAREABLE = 0b11,
} mmu_shareability;


typedef struct
{
    bool valid;
    p_uintptr next_tbl;
} pd_tbl_cfg;
