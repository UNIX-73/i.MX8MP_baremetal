.section .text.boot
.global _start

_start:
    nop
    //  disable DAIF exceptions
    msr daifset, #0xf

#ifdef TEST
    mrs x0, CurrentEL
    lsr x0, x0, #2 // x0 = x0 >> 2
    cmp x0, #2
    b.ne hang
#endif

    mrs x0, MPIDR_EL1
    and x0, x0, #0xFF // core Aff0

    ldr x3, =__NUM_CORES
    cmp x0, x3
    b.hi hang // if (coreid >= __NUM_CORES) hang

    ldr x1, =__EL2_STACK_SIZE
    ldr x2, =__stacks_el2_end

    mul x0, x0, x1  // x0 = coreid * stack size
    sub x0, x2, x0  // x0 = stack end - coreid * stack size
    
    mov sp, x0

    bl _setup_stack_el1
    bl _el2_init_vector //  Set EL2 vector table
    bl _clean_bss
    bl init_panic

    bl _switch_to_el1

hang:
    wfe
    b hang
