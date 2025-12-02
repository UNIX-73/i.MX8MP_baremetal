include make/Folders.mk

OPT_LEVEL   ?= -O2
DEFINES     ?=

MARCH       ?= armv8.2-a
MCPU        ?= cortex-a76

ASM_FLAGS   = $(DEFINES)
C_FLAGS     = $(OPT_LEVEL) $(DEFINES) -std=gnu23 -Wall -Wextra -Werror -ffreestanding -nostdlib -nostartfiles -I$(INCLUDE_DIR) -march=$(MARCH) -mcpu=$(MCPU)
CPP_FLAGS   = $(C_FLAGS) -std=c++20 -fno-exceptions -fno-rtti
LD_FLAGS    = -T linker.ld -Map $(MAP)

