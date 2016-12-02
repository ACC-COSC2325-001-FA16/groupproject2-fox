#include <avr/io.h>
#include <util/delay.h>

int main(void) {

    while(1){
        ping();
        _delay_ms(500);
    }
	
}
