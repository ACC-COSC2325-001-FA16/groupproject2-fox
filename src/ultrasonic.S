#include <avr/io.h>
#include "../include/AVRSpecialRegs.inc"
#include "../include/timer1.inc"

        .section .text
        .global     init_ping   
        .global     ping      
        .global     toggle 
        .org        0x0000

init_ping:
        ; set output pin to low
        ;sbi     _DDRD, 7                ;DDRB stands for Data DiRection sets PD7 to an output
                                        ;this is the digitial out 13 on the board
        ;sbi     _PORTD, 0               ;set all D ports to off

        ;set trigger time counter value in us
        ldi     r16, 0x0f
        sts     _OCR1AH, r16            ;set upper 8 bits of counter register trigger flag to 0
        ldi     r16, 0x10         
        sts     _OCR1AL, r16            ;set lower 8 bits to 10 (for 10us)

        call    timer_16_init           ;prepare 16bit timer
        ret

ping:
        ;call timer_16_delay
        ;ret
        ;eor     r24, r24        ; zero out return registers
        ;eor     r25, r25        ; zero out return registers
        call    timer_16_reset  ; clear clock and flags
        ;ldi     r16, (1 << 7)   ; bit shift for bit 7 on port D (pin 13)
        ;out     _PORTD, r16     ; write the bits back to the port
trigger_delay:
        in      r16, _TIFR1     ; check the flags 
        sbrs    r16, OCF1A      ; skip if next instruction if trigger flag set
        rjmp    trigger_delay   ; loop till delay time ends
        ;ldi     r16, 0
        ;out     _PORTD, r16     ; pulse is over clear all ports
        call    toggle
echo_delay:
        in      r16, _TIFR1     ; check the flags 
        sbrs    r16, TOV1      ; skip if next instruction if trigger flag set
        rjmp    echo_delay   ; loop till delay time ends
ping_done:
        call    toggle          ; TEST toggle on board light when clock triggers
        ;ldi     r24, 0x00       ; TEST currently returns static value
        ret

;FOR TESTING
toggle:
        in      r24, _PORTB                 ;get current state of the port output
        ldi     r25, (1 << 5)               ;sep pin 7 high
                                            ;this will toggle the light state
        eor     r24, r25                    ;flip the bit
        out     _PORTB, r24                 ;write the bits back to the port
        ret

