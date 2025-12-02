#pragma once

#ifdef _STDBOOL_H
#error "C std lib stdbool used instead of custom baremetal implementation"
#endif

#define _STDBOOL_H 1

#include <stdbool.h>
/// Standard bool type
#if defined(__cplusplus) && __cplusplus < 201103L

#error "Imported custom stdbool inside a cpp file"

#else

#define true 1
#define false 0

#endif