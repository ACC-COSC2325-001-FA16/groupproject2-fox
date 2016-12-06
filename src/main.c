#include <avr/io.h>
#include <util/delay.h>

#define LED_PIN         5
#define LED_ON          (PORTB |= (1<<LED_PIN))
#define LED_OFF         (PORTB &= ~(1<<LED_PIN))

#define LED_CONFIG      (DDRB |= (1<<LED_PIN))
#define CPU_PRESCALE(n) (CLKPR = 0x80, CLKPR = (n))

int main(void) {
    CPU_PRESCALE(4); // 4 = 1/16th speed http://playground.arduino.cc/Code/Prescaler
    
    LED_CONFIG;
    LED_OFF;

    init_ping();

    while(1){
        int x = ping();
        x /= 58;
        //int x = pin_high();
        if (x > 5) { LED_ON; }
        else { LED_OFF; }
        _delay_ms(100);
    }
	
}

