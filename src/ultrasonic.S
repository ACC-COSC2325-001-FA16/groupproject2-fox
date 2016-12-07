; ultrasonic.S 
;
; function for sending pings from ultrasonic shield


#include "config.inc"

        .section .text
        .global         init_ping   
        .global         ping      
        .global         copy_counter
        .org            0x0000

init_ping:
        ; set output TRIGGER PIN to low
        sbi     USHIELD_DIR,TRIG_PIN    ; DDRB stands for Data DiRection sets PD7 to an output
                                        ; see config.inc for define names
        clr     r16                     ; zero out r16
        sts     USHIELD_PORT, r16       ; set all pins on shild port to low

        ;set trigger time counter value to 19 microseconds
        ldi     r16, 0x00               ; prep 0 in r16
        sts     _OCR1AH, r16            ; set upper 8 bits of counter register trigger flag to 0
        ldi     r16, 0x0a               ; prep 10 in r16
        sts     _OCR1AL, r16            ; set lower 8 bits to 10 (for 10us)

        ;prepare 16bit timer
        call    timer_16_init           
        ret

ping:
        clr     r24                     ; zero out return registers
        clr     r25                     ; zero out return registers
        call    timer_16_reset          ; clear clock and flags
        sbi     USHIELD_PORT, TRIG_PIN  ; set triger pin high
trigger_pulse:
        in      r16, _TIFR1             ; check the clock flags 
        sbrs    r16, OCF1A              ; skip next instruction if trigger time flag set
        rjmp    trigger_pulse           ; loop till trigger time delay ends
        cbi     USHIELD_PORT, TRIG_PIN  ; clear tigger pin (set low)
echo_listen:
        sbis    USHIELD_PINS, ECHO_PIN  ; skip if counter copy if echo pin is low
        call    copy_counter            ; copy counter value (only if echo pin is high)
        in      r16, _TIFR1             ; check clock the flags 
        sbrs    r16, TOV1               ; skip next instruction if clock overflow flag set
        rjmp    echo_listen             ; loop till delay time ends
ping_done:
        ret

copy_counter:
        ; copy counter values into return registers
        lds      r24, _TCNT1L
        lds      r25, _TCNT1H
        ret