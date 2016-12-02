#include <avr/io.h>
#include "../include/AVRSpecialRegs.inc"

        .section .text
        .global     ping         
        .org        0x0000

ping:
        ret
