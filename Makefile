#################################################
#						#
#	Foxtrot Group Project 2 Makefile	#
#						#
#################################################
# Make manual : 
# https://www.gnu.org/software/make/manual/make.html

# Begin Project variable definitions --------------------

# Export all variable and make them available
# to recursive make calls
export

# Directories to run make files for
# Only uses src dir for now
DIRS    = src
# Output directory to use for build
BIN	= bin


# Tools and Paths to be used for build
ARDUINO	= /usr/share/arduino
TOOLS	= $(ARDUINO)/hardware/tools/avr/bin
GCC	= $(TOOLS)/avr-gcc
OBJCOPY	= $(TOOLS)/avr-objcopy
OBJDUMP = $(TOOLS)/avr-objdump
RM      = rm -f 
DUDE    = $(TOOLS)/avrdude

BASEDIR		= $(ARDUINO)/hardware
INCLUDES	= -I"$(BASEDIR)/arduino/avr/variants/standard"
INCLUDES	+= -I"$(BASEDIR)/tools/avr/avr/include/avr"
DUDECNF     	= -C"$(BASEDIR)/tools/avr/etc/avrdude.conf"

# .c file compiler flags
CFLAGS      = -mmcu=$(MCU)
CFLAGS      += -DF_CPU=$(F_CPU)L
CFLAGS      += $(INCUDES)
CFLAGS      += -Os

# .S (assembly) file compiler flags
AFLAGS		= -mmcu=$(MCU)
AFLAGS		+= -x assembler-with-cpp
AFLAGS		+= -DF_CPU=$(F_CPU)L
AFLAGS		+= $(INCLUDES)

# Load flags (to push .hex file to arduino)
LFLAGS		= -v
LFLAGS		+= -p$(MCU) -carduino
LFLAGS		+= -P$(PORT)
LFLAGS		+= -b115200

# Arduino defintions
INTTBL	= FALSE
MCU	= atmega328p
F_CPU	= 16000000
PORT	= /dev/ttyACM0

# Begin Rule definitions-----------------------------------------
# Build project 
all:		compile
		$(MAKE) -C $(BIN) all;

# Generate assembly dump of program
dump:		compile
		$(MAKE) -C $(BIN) dump

# Remove build files
clean:
		$(MAKE) -C $(BIN) clean

# Load the .hex file onto the arduino
load:
		$(MAKE) -C $(BIN) load

# Generate all the object files
compile:
		@for dir in $(DIRS); do  \
			($(MAKE) -C $$dir compile); \
		done


