.section .text.boot
.global _start

_start:
    // disable irq
    msr daifset, #0xf

    // Init EL2 stack
    ldr x0, =__stack_el2_top
    mov sp, x0
    
    // Init El1 stack
    ldr x0, =__stack_el1_top
    msr SP_EL1, x0

    // Clean bss
/*
    ldr x1, =_bss_start
    ldr x2, =_bss_end
1:
    cmp x1, x2
    b.eq 2f
    str xzr, [x1], #8
    b 1b
2:
*/

#ifdef OPENOCD
    ldr x0, =1
3:  nop
    cbnz x0, 3b
#endif

    bl kernel_entry

hang:
    wfe
    b hang