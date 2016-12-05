#include <avr/io.h>
#include "../include/AVRSpecialRegs.inc"

        ;TIMER 1 register adresses
        .equ     _TIFR1,        0x16
        .equ     _TCCR1B,       0x81
        .equ     _TCNT1H,       0x85
        .equ     _TCNT1L,       0x84
        .equ    _OCR1AH,        0x89
        .equ    _OCR1AL,        0x88  
        

        ;Function declarations
        .section .text
        .global     init_ping   
        .global     ping      
        .global     toggle 
        .global         timer_16_delay
        .global         timer_16_init
        .global         timer_delay
        .global         timer_init  
        .org        0x0000

        ;C code debug values
        ;.extern         clkSelectBits   ;clock selet bits for 16bit timer
        


init_ping:
        ; set output pin to low
        sbi     _DDRD, 7                ;DDRB stands for Data DiRection sets PD7 to an output
                                        ;this is the digitial out 13 on the board
        sbi     _PORTD, 0               ;set all D ports to off
        rjmp    timer_16_init           ;prepare 16bit timer

        ;set trigger time counter value in us
        ldi     r16, 0x10
        sts     _OCR1AH, r16            ;set upper 8 bits of counter register trigger flag to 0
        ldi     r16, 0x10         
        sts     _OCR1AL, r16            ;set lower 8 bits to 10 (for 10us)

        ret

ping:
        eor     r24, r24        ; zero out return registers
        eor     r25, r25        ; zero out return registers
        rjmp    timer_16_reset  ; clear clock and flags
        ;ldi     r16, (1 << 7)   ; bit shift for bit 7 on port D (pin 13)
        ;out     _PORTD, r16     ; write the bits back to the port
trigger_delay:
        in      r16, _TIFR1     ; check the flags 
        sbrs    r16, OCF1A      ; skip if next instruction if trigger flag set
        rjmp    trigger_delay   ; loop till delay time ends
        ;ldi     r16, 0
        ;out     _PORTD, r16     ; pulse is over clear all ports

        ; set accumulator (return value) to 0
        ; enter listen mode
ping_listen:
        ;in      r16, _TIFR1              ;pull the clock flags
        ;sbrs    r16, TOV1               ;check the timer overflow flag bit
                                        ;sbrs = Skip Bit if Register Set
        ;rjmp    ping_listen             ;continue listen if timer has not flipped
        ;rjmp    toggle

        ;timer has flipped
        ;ldi     r16, 1 << TOV1          ;bit shift 1 into TOV1 position (timer overflow position)
        ;out     TIFR1, r16              ;clear rollover interrupt flag (yes, 1 clears flag)

ping_done:
        rjmp    toggle          ; TEST toggle on board light when clock triggers
        ldi     r24, 0x00       ; TEST currently returns static value
        ret

;FOR TESTING
toggle:
        in      r24, _PORTB                 ;get current state of the port output
        ldi     r25, (1 << 5)               ;sep pin 7 high
                                            ;this will toggle the light state
        eor     r24, r25                    ;flip the bit
        out     _PORTB, r24                 ;write the bits back to the port
        ret

timer_16_init:
        ldi     r16, 1                          ; run full speed
        sts     _TCCR1B, r16                    ; set timer clock 

        ;set trigger time counter value in us
        ldi     r16, 0xff
        sts     _OCR1AH, r16            ;set upper 8 bits of counter register trigger flag to 0
        ldi     r16, 0x10         
        sts     _OCR1AL, r16            ;set lower 8 bits to 10 (for 10us)

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
