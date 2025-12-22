#pragma once

#include <lib/stdbool.h>
#include <lib/stdint.h>

typedef struct {
	bool fiq;
	bool irq;
	bool serror;
	bool debug;
} ARM_exception_status;

/// true means enabled
ARM_exception_status ARM_exceptions_get_status();

/// true means enable, false disable
void ARM_exceptions_set_status(ARM_exception_status status);

/// Enables exceptions on true. If a param is false, the current state of the
/// exception will be mantained, not disabled.
void ARM_exceptions_enable(bool fiq, bool irq, bool serror, bool debug);

/// Disables exceptions on true. If a param is false, the current state of the
/// exception will be mantained, not enabled.
void ARM_exceptions_disable(bool fiq, bool irq, bool serror, bool debug);

size_t ARM_get_exception_level();