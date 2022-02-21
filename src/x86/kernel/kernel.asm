bits 32
extern _start
global _kentry

_kentry: 
    call _start
    hlt
