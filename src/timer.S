; timer.S 
;
; clock utility functions

#include "config.inc"

        .section .text
        .global         timer_16_reset
        .global         timer_16_init 
        .org            0x0000

timer_16_init:
        ldi     r16,(1<<CS10)           ; run full speed
        sts     _TCCR1B, r16            ; apply settings to timer clock 
        rjmp    timer_16_reset          ; reset the clock
        ret

timer_16_reset:
        ldi     r16, (1 << TOV1)| (1 << OCF1A)  ; prep to clear the interrupt flags
        out     _TIFR1, r16                     ; apply clear the interrupt flag
        clr     r16                             ; clear r16
        sts     _TCNT1H,r16                     ; apply clear to upper 8bits of counter 1
        sts     _TCNT1L,r16                     ; apply clear to lower 8bits of counter 1
        ret