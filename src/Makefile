# src makefile

CSRCS 	= $(wildcard *.c)
ASRCS 	= $(wildcard *.S)

# generated files (cleaned)
OBJS    = $(CSRCS:.c=.o)
OBJS    += $(ASRCS:.S=.o)

# Rules definitions -------------------------------

compile:	$(OBJS)

# Implicit rules ----------------------------------

# Output .o files to bin folder
%.o:    %.c
	$(GCC) -g -c $(CFLAGS) $< -o ../$(BIN)/$@

%.o:    %.S
	$(GCC) -g -c $(AFLAGS) $< -o ../$(BIN)/$@

