#pragma once

#include <drivers/imx8mp.h>

#define GICV3_DECLARE_BIT_FIELD_GETTER(reg_name, bf_name, RegValueStruct, T,   \
									   SHIFT, MASK)                            \
	MMIO_DECLARE_BIT_FIELD_GETTER(GICV3, reg_name, bf_name, RegValueStruct, T, \
								  SHIFT, MASK)

#define GICV3_DECLARE_BIT_FIELD_SETTER(reg_name, bf_name, RegValueStruct, T,   \
									   SHIFT, MASK)                            \
	MMIO_DECLARE_BIT_FIELD_SETTER(GICV3, reg_name, bf_name, RegValueStruct, T, \
								  SHIFT, MASK)

/*
	--- GIC DISTRIBUTOR ---
*/
// Arm Generic Interrupt Controller Architecture Specification GIC architecture
// version 3 and version 4
//
// 12.8 533
#define GICV3_DISTRIBUTOR_OFFSET 0x0UL
#define GICV3_DISTRIBUTOR_BASE (IMX8MP_A53_GIC_BASE + GICV3_DISTRIBUTOR_OFFSET)

/*
	--- GIC REDISTRIBUTOR ---
*/
// 12.10 634
// NOTE: This base and offset is for redistributor 0, then the stride should be
// applied for each processor ID. For the imx8mp the redistributor banks are in
// order for their cpuid. I checked it with GDB.
#define GICV3_REDISTRIBUTOR_OFFSET 0x80000UL
#define GICV3_REDISTRIBUTOR_BASE \
	(IMX8MP_A53_GIC_BASE + GICV3_REDISTRIBUTOR_OFFSET)

#define GICV3_REDISTRIBUTOR_STRIDE 0x20000UL
#define GICV3_REDISTRIBUTOR_N_BASE(n) \
	(GICV3_REDISTRIBUTOR_BASE + (n * GICV3_REDISTRIBUTOR_STRIDE))
