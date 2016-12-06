#include <avr/io.h>
#include "../include/AVRSpecialRegs.inc"

#define LED_PIN     5
#define LED_DIR     _DDRB
#define LED_PORT    _PORTB

#define TRIG_PIN    4
#define TRIG_PORT   _PORTB


;TIMER 1 register adresses
 .equ     _TIFR1,        0x16
 .equ     _TCCR1B,       0x81
 .equ     _TCNT1H,       0x85
 .equ     _TCNT1L,       0x84
 .equ    _OCR1AH,        0x89
 .equ    _OCR1AL,        0x88  