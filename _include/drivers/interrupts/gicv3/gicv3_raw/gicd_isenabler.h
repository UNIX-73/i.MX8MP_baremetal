#pragma once

#ifndef DRIVERS
#error "This header should only be imported by a driver"
#endif

#include <kernel/panic.h>
#include <lib/mmio/mmio_macros.h>
#include <lib/stdbool.h>
#include <lib/stdint.h>

#include "gicv3_map.h"

#define GICD_ISENABLER_OFFSET(n) (0x100UL + (4UL * n))

static inline void GICV3_GICD_ISENABLER_set_bit(uint32 n, uint32 bit)
{
	if (bit > 31) PANIC("GICD_ISENABLER: bit must be <= 31");

	*((reg32_ptr)(GICV3_DISTRIBUTOR_BASE + GICD_ISENABLER_OFFSET(n))) =
		(1UL << bit);
}