#include <arm/cpu.h>
#include <boot/panic.h>
#include <kernel/lib/smp.h>

uint64 get_core_id()
{
    ARM_cpu_affinity affinity = ARM_get_cpu_affinity();

#ifdef TEST
    if (!(affinity.aff0 < 4))
        PANIC("Invalid core id");
#endif

    return affinity.aff0;
}
