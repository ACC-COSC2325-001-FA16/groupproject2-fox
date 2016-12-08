# bin makefile

TARGET	= ultrasonic

# list of all .o files to compile
OBJS 	= $(wildcard *.o)

# Rule definitions -----------------------------------------
all:	$(TARGET).hex

dump:	$(TARGET).lst

#elf:	$(TARGET).elf #Used for debugging in Atmel Studio

clean:
	$(RM) *.o *.hex *.eep *.elf *.map *.lst

load:   $(TARGET).hex
	$(DUDE) $(DUDECNF) $(LFLAGS) -Uflash:w:$(TARGET).hex:i

# Implicit rule definitions --------------------------------

%.hex:  %.elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

%.elf:  $(OBJS)
	$(GCC) -w -Os -mmcu=$(MCU) -o $@ $^ -lm

%.lst:   %.elf
	$(OBJDUMP) -d $< > $@
