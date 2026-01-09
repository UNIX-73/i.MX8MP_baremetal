.section .text

.align 4

.global _smc_call
// x0 = uint32 fid, x1 = uint64 arg1, x2 = uint64 arg2, x3 = uint64 arg3, 
// x4 = uint64 arg4, x5 = uint64 arg5, x6 = uint64 arg6, x7 = uint64 arg7
_smc_call:
    smc #0
    ret