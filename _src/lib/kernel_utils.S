.section .text
.global _currentEL
.type   _currentEL, %function


_currentEL:
    mrs x0, CurrentEL
    lsr x0, x0, #2
    ret
