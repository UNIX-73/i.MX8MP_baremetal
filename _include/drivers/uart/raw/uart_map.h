#pragma once

#ifndef DRIVERS
#error "This header should only be imported by a driver"
#endif

#include <drivers/peripherals.h>
#include <lib/mmio/mmio_macros.h>

#define UART1_OFFSET 0x0060000UL
#define UART3_OFFSET 0x0080000UL
#define UART2_OFFSET 0x0090000UL
#define UART4_OFFSET 0x0260000UL

#define UART1_BASE (IMX8MP_MMIO_AIPS3_BASE + UART1_OFFSET)
#define UART2_BASE (IMX8MP_MMIO_AIPS3_BASE + UART2_OFFSET)
#define UART3_BASE (IMX8MP_MMIO_AIPS3_BASE + UART3_OFFSET)
#define UART4_BASE (IMX8MP_MMIO_AIPS3_BASE + UART4_OFFSET)

#define UART_DECLARE_BIT_FIELD_GETTER(reg_name, bf_name, RegValueStruct, T,   \
									  SHIFT, MASK)                            \
	MMIO_DECLARE_BIT_FIELD_GETTER(UART, reg_name, bf_name, RegValueStruct, T, \
								  SHIFT, MASK)

#define UART_DECLARE_BIT_FIELD_SETTER(reg_name, bf_name, RegValueStruct, T,   \
									  SHIFT, MASK)                            \
	MMIO_DECLARE_BIT_FIELD_SETTER(UART, reg_name, bf_name, RegValueStruct, T, \
								  SHIFT, MASK)
