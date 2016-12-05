; timer.S 
; programmer : Daniel Valey

#include <avr/io.h>
#include "../include/AVRSpecialRegs.inc"
#include "../include/timer1.inc"

        

        ;Function declarations
        .section .text
        .global         timer_16_reset
        .global         timer_16_delay
        .global         timer_16_init 
        .org        0x0000

timer_16_init:
        ldi     r16, (1<<CS11)|(1<<CS10)                          ; run full speed
        sts     _TCCR1B, r16                    ; set timer clock 

        rjmp    timer_16_reset
        ret

timer_16_reset:
        ldi     r16, (1 << TOV1)| (1 << OCF1A)            ; TOV1 clear the interrupt flag
        out     _TIFR1, r16                 ; clear the interrupt flag
        clr     r16                             ;clear r16
        sts     _TCNT1H,r16                     ;clear upper 8bits of counter 1
        sts     _TCNT1L,r16                     ;clear lower 8bits of counter 1
        ret

timer_16_delay:
        in      r16, _TIFR1              ; check the flag 
        ;sbrs    r16, TOV1                    ; skip if overflow set to 0!
        sbrs    r16, OCF1A                    ; skip if overflow set to 0!
        rjmp    timer_16_delay                 ; wait for it
        ;ldi     r16, 1 << TOV1             ; clear the interrupt flag
        ldi     r16, 1 << OCF1A             ; clear the interrupt flag
        out     _TIFR1, r16                 ; clear the interrupt flag
        clr     r16                    ; clear r16
        sts     _TCNT1H,r16             ;lear upper 8bits of counter 1
        sts     _TCNT1L,r16     ;clear lower 8bits of counter 
        rjmp toggle
        ret 