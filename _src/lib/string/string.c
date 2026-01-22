#include <boot/panic.h>
#include <lib/stdbool.h>
#include <lib/stdint.h>
#include <lib/string.h>

void strcopy(char* dst, const char* src, uint64 max_size)
{
    for (uint64 i = 0; i < max_size - 1; i++)
    {
        dst[i] = src[i];

        if (src[i] == '\0')
            return;
    }

    dst[max_size - 1] = '\0';
}

