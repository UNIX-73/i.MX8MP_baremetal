.section .text
.align 4

// FIXME:
.global __switch_to_el1
__switch_to_el1:
    mrs x0, CurrentEL
    lsr x0, x0, #2
    cmp x0, #2
    b.ne hang

    ldr x0, =__stack_el1_top
    msr SP_EL1, x0

    /* EL1 AArch64 */
    mov x0, #(1 << 31)
    msr HCR_EL2, x0


    mrs x0, SCTLR_EL1
    bic x0, x0, #(1 << 2)   // C
    bic x0, x0, #(1 << 12)  // I
    msr SCTLR_EL1, x0

    adr x0, _el1_vector_table
    msr VBAR_EL1, x0

    mov x0, #0x3c5
    msr SPSR_EL2, x0

    ldr x0, =_el1_entry
    msr ELR_EL2, x0

    adr x0, _el1_entry

// 1. Limpiar D-cache hasta PoU (Point of Unification)
    dc cvau, x0

    dsb ish

// 2. Invalidar I-cache para esa dirección
    ic ivau, x0

    dsb ish
    isb


    dsb sy
    isb
    eret

hang:
    wfe
    b hang



.align 4
.global __el1_entry
__el1_entry:
    nop
    mov x0, #1
    msr spsel, x0

    bl kernel_entry
    