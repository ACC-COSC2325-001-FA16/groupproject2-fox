#include <avr/io.h>
#include "../include/AVRSpecialRegs.inc"

        .section .text
        .global     init_ping   
        .global     ping         
        .org        0x0000

init_ping:
        
        ; setup clock
        ; set output pin to low
        ret

ping:
        eor     r24, r24        ; zero out return registers
        eor     r25, r25        ; zero out return registers
        ; set clock counter to 0
        ; set trigger to high
        ; delay for 10us
        ; set trigger to low
        ; set accumulator (return value) to 0
        ; enter listen mode
ping_listen:
        ; is clock at 60ms?
        ; yes, jump to ping_done
        ; no, read echo pin
        ; tick the clock
        ; is the echo pin high?
        ; yes, add to accumulator
        ; jump to ping_listen

ping_done:
        ldi     r24, 0x01
        ret
