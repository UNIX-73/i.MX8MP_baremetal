#include <arm/cpu.h>
#include <arm/sysregs.h>

#include "lib/stdint.h"

CpuAffinity ARM_get_cpu_affinity()
{
	uint64 v = _ARM_MPIDR_EL1();
	CpuAffinity cpuid = {
		.aff0 = (v & 0xFFUL),
		.aff1 = ((v >> 8) & 0xFFUL),
		.aff2 = ((v >> 16) & 0xFFUL),
		.aff3 = ((v >> 32) & 0xFFUL),
	};

	return cpuid;
}

