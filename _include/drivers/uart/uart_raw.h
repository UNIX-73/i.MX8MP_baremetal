#pragma once

#ifndef DRIVERS
#error "This header should only be imported by a driver"
#endif

#include <drivers/uart/raw/uart_map.h>
#include <lib/stdint.h>

static const uintptr UART_N_BASE[] = {
	UART1_BASE,
	UART2_BASE,
	UART3_BASE,
	UART4_BASE,
};

#include <drivers/uart/raw/uart_utxd.h>