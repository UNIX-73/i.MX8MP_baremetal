#pragma once

#include <kernel/irq/interrupts.h>

#include "device.h"
#include "drivers.h"

// List of available devices
const kernel_device UART1_DEVICE = {
	.id = IMX8MP_IRQ_UART1,
	.name = "uart1",
	.irqid = IMX8MP_IRQ_UART1,
	.drv = &UART1_DRIVER,
};

const kernel_device UART2_DEVICE = {
	.id = IMX8MP_IRQ_UART2,
	.name = "uart2",
	.irqid = IMX8MP_IRQ_UART2,
	.drv = &UART2_DRIVER,
};

const kernel_device UART3_DEVICE = {
	.id = IMX8MP_IRQ_UART3,
	.name = "uart3",
	.irqid = IMX8MP_IRQ_UART3,
	.drv = &UART3_DRIVER,
};

const kernel_device UART4_DEVICE = {
	.id = IMX8MP_IRQ_UART4,
	.name = "uart4",
	.irqid = IMX8MP_IRQ_UART4,
	.drv = &UART4_DRIVER,
};