OUTPUT_FORMAT("elf64-littleaarch64")
ENTRY(_start)

SECTIONS {
    . = 0x40000000;

    .text : ALIGN(16) {
        KEEP(*(.text.boot))
        *(.text*)
        . = ALIGN(16);
    }

    .rodata : ALIGN(16) {
        *(.rodata*)
        . = ALIGN(16);
    }

    .data : ALIGN(16) {
        *(.data*)
        . = ALIGN(16);
    }

    .bss : ALIGN(16) {
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        __bss_end = .;
        . = ALIGN(16);
    }

    .stacks (NOLOAD) : ALIGN(4096) {

        /* EL0 */
        __stack_el0_bottom = .;
        . += 0x500000;
        __stack_el0_top = .;

        /* EL1 */
        . = ALIGN(16);
        __stack_el1_bottom = .;
        . += 0x500000;
        __stack_el1_top = .;

        /* EL2 */
        . = ALIGN(16);
        __stack_el2_bottom = .;
        . += 0x500000;
        __stack_el2_top = .;
    }

    PROVIDE(_bss_start = __bss_start);
    PROVIDE(_bss_end   = __bss_end);

    PROVIDE(_stack_el0_top    = __stack_el0_top);
    PROVIDE(_stack_el0_bottom = __stack_el0_bottom);
    PROVIDE(_stack_el1_top    = __stack_el1_top);
    PROVIDE(_stack_el1_bottom = __stack_el1_bottom);
    PROVIDE(_stack_el2_top    = __stack_el2_top);
    PROVIDE(_stack_el2_bottom = __stack_el2_bottom);
}
