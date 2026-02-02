#define KERNEL_BASE 0xFFFF800000000000

.section .text
.align 4

.global _jmp_to_with_offset
// _Noreturn void _jmp_to_with_offset(void* to, size_t offset);
_jmp_to_with_offset:
    add x0, x0, x1 // to += offset
    br  x0


.global _reloc_reconfigure_regs
_reloc_reconfigure_regs:
    msr daifset, #0xF
    isb

    bl _reset_stack_el1 // gets the pa of a resetted stack

    mov x0, sp  //  (p_uintptr pa)
    bl mm_remap //  return pa + KERNEL_BASE
    mov sp, x0  //  sp = remap res


    mrs x0, VBAR_EL1
    bl mm_remap
    msr VBAR_EL1, x0

    msr daifclr, #0xF
    isb

    adr lr, kernel_entry // lr to kernel_entry remapped

    isb
    ret
