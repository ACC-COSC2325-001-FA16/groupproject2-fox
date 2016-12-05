#include <avr/io.h>
#include <util/delay.h>

#define LED_PIN         5
#define LED_ON          (PORTB |= (1<<LED_PIN))
#define LED_OFF         (PORTB &= ~(1<<LED_PIN))

#define LED_CONFIG      (DDRB |= (1<<LED_PIN))
//do clock setup in assembly
#define CPU_PRESCALE(n) (CLKPR = 0x80, CLKPR = (n))

// BEGIN DEBUG VARIABLES : used as bools in c and assembly code
//unsigned char clkSelectBits = 5;    // Default should be 1.  
                                    // Divide down 16bit counter to make it easier to debug
                                    // http://www.co-pylit.org/courses/cosc2325/Arduino/Timers/index.html#setting-the-prescaler

// END DEBUG VARIABLES

int main(void) {
    // do clock setup in assembly
    CPU_PRESCALE(4); // 4 = 1/16th speed http://playground.arduino.cc/Code/Prescaler
    
    LED_CONFIG;
    LED_OFF;

    //init_ping();
    timer_16_init();

    while(1){
        
	    //int x = return_test(0);
        //int x = ping();
        //if (x > 0) { LED_ON; }
        //else { LED_OFF; }
        toggle();
        timer_16_delay();
    }
	
}


// FOR ASSEMBLY TEST OUTPUT
int return_test(int i){
return i;}
