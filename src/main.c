#include <avr/io.h>
#include <util/delay.h>

#define LED_PIN         5
#define LED_ON          (PORTB |= (1<<LED_PIN))
#define LED_OFF         (PORTB &= ~(1<<LED_PIN))

#define LED_CONFIG      (DDRB |= (1<<LED_PIN))
#define CPU_PRESCALE(n) (CLKPR = 0x80, CLKPR = (n))

int main(void) {

    CPU_PRESCALE(0);
    LED_CONFIG;
    LED_OFF;

    init_ping();

    while(1){
        
	    //int x = return_test(0);
        int x = ping();
        if (x > 0) { LED_ON; }
        else { LED_OFF; }
    }
	
}

// FOR ASSEMBLY TEST OUTPUT
int return_test(int i){
return i;}
