.global _secondary_core_entry
_secondary_core_entry:
    mrs x0, MPIDR_EL1
    and x0, x0, #0xFFFF
    cmp x0, #0
    b.eq hang
// TODO: 
    
    

hang:
    wfe
    b hang
