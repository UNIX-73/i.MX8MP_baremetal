#pragma once

#ifndef DRIVERS
#error "This header should only be imported by a driver"
#endif

#include <lib/mmio/mmio_macros.h>
#include <lib/stdbool.h>

#include "gicv3_macros.h"

#define GICR_WAKER_OFFSET 0x14UL

#define GICR_WAKER_VALUE_STRUCT_NAME GicrWaker

MMIO_DECLARE_REG32_VALUE_STRUCT(GICR_WAKER_VALUE_STRUCT_NAME);

MMIO_DECLARE_REG32_GETTER_N_BASE(GICV3, GICR_WAKER,
								 GICR_WAKER_VALUE_STRUCT_NAME,
								 GICV3_REDISTRIBUTOR_N_BASE, GICR_WAKER_OFFSET);
MMIO_DECLARE_REG32_SETTER_N_BASE(GICV3, GICR_WAKER,
								 GICR_WAKER_VALUE_STRUCT_NAME,
								 GICV3_REDISTRIBUTOR_N_BASE, GICR_WAKER_OFFSET);

/* Helper */
#define GICR_WAKER_DECLARE_BIT_FIELD_GETTER(bf_name, T)             \
	GICV3_DECLARE_BIT_FIELD_GETTER(GICR_WAKER, bf_name,             \
								   GICR_WAKER_VALUE_STRUCT_NAME, T, \
								   bf_name##_SHIFT, bf_name##_MASK) \
	GICV3_DECLARE_BIT_FIELD_SETTER(GICR_WAKER, bf_name,             \
								   GICR_WAKER_VALUE_STRUCT_NAME, T, \
								   bf_name##_SHIFT, bf_name##_MASK)

// IMPLEMENTTATION DEFINED 31
#define GICR_WAKER_BIT31_SHIFT 31
#define GICR_WAKER_BIT31_MASK (1UL << GICR_WAKER_BIT31_SHIFT)
GICR_WAKER_DECLARE_BIT_FIELD_GETTER(GICR_WAKER_BIT31, bool);

// ChildrenAsleep 2
#define ChildrenAsleep_SHIFT 2
#define ChildrenAsleep_MASK (1UL << ChildrenAsleep_SHIFT)
GICR_WAKER_DECLARE_BIT_FIELD_GETTER(ChildrenAsleep, bool);

// ProcessorSleep
#define ProcessorSleep_SHIFT 1
#define ProcessorSleep_MASK (1UL << ProcessorSleep_SHIFT)
GICR_WAKER_DECLARE_BIT_FIELD_GETTER(ProcessorSleep, bool);

// IMPLEMENTTATION DEFINED 0
#define GICR_WAKER_BIT0_SHIFT 0
#define GICR_WAKER_BIT0_MASK (1UL << GICR_WAKER_BIT31_SHIFT)
GICR_WAKER_DECLARE_BIT_FIELD_GETTER(GICR_WAKER_BIT0, bool);