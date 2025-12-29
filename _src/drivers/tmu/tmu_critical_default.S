.section .text

.align 4
.global _TMU_critical_hang
_TMU_critical_hang:
    wfe
    b _TMU_critical_hang
