
#include "config.inc"

        .section .text
        .global         init_ping   
        .global         ping      
        .global         toggle 
        .global         copy_counter
        .org        0x0000

init_ping:
        ; set output pin to low
        sbi     _DDRD,7                ;DDRB stands for Data DiRection sets PD7 to an output
        ldi     r16, 0x00
        sts     _PORTD, r16

        ;set trigger time counter value in us
        ldi     r16, 0x00
        sts     _OCR1AH, r16            ;set upper 8 bits of counter register trigger flag to 0
        ldi     r16, 0x0a         
        sts     _OCR1AL, r16            ;set lower 8 bits to 10 (for 10us)

        call    timer_16_init           ;prepare 16bit timer
        ret

ping:
        clr     r24       ; zero out return registers
        clr     r25       ; zero out return registers
        call    timer_16_reset  ; clear clock and flags
        sbi     _PORTD, 7
trigger_pulse:
        in      r16, _TIFR1     ; check the flags 
        sbrs    r16, OCF1A      ; skip next instruction if trigger flag set
        rjmp    trigger_pulse   ; loop till delay time ends
        cbi     _PORTD, 7
echo_listen:
        sbis    _PIND, 6        ; skip if bit in register is set
        call    copy_counter
        in      r16, _TIFR1     ; check the flags 
        sbrs    r16, TOV1      ; skip if next instruction if trigger flag set
        rjmp    echo_listen   ; loop till delay time ends
ping_done:
        ret

copy_counter:
        ; copy counter values
        lds      r24, _TCNT1L
        lds      r25, _TCNT1H
        ret