.PHONY: default clean

LIBSIMPLEIO	?= /usr/local/share/libsimpleio
MUNTSOS		?= $(HOME)/muntsos

include $(LIBSIMPLEIO)/freepascal/include/pascal.mk
include $(LIBSIMPLEIO)/freepascal/include/libsimpleio.mk

PROGRAMS	+= blinky

default: $(PROGRAMS)

clean: pascal_mk_clean
	rm -f $(PROGRAMS)
