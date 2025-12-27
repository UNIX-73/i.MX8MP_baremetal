#pragma once

#ifndef DRIVERS
#error "This header should only be imported by a driver"
#endif

#include <drivers/peripherals.h>
#include <lib/mmio/mmio_macros.h>

#define TMU_OFFSET 0x260000UL

#define TMU_BASE (IMX8MP_MMIO_AIPS1_BASE + TMU_OFFSET)

#define TMU_DECLARE_BIT_FIELD_GETTER(reg_name, bf_name, RegValueStruct, T,   \
									 SHIFT, MASK)                            \
	MMIO_DECLARE_BIT_FIELD_GETTER(TMU, reg_name, bf_name, RegValueStruct, T, \
								  SHIFT, MASK)

#define TMU_DECLARE_BIT_FIELD_SETTER(reg_name, bf_name, RegValueStruct, T,  \
									 SHIFT, MASK)                           \
	MMIO_DECLARE_BIT_FIELD_SETTER(TMU, reg_name, bf_name, RegValueStruct, T, \
								 SHIFT, MASK)