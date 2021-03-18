.PHONY: default clean

LIBSIMPLEIO	?= /usr/local/share/libsimpleio
MUNTSOS		?= $(HOME)/muntsos
GPRBUILD	?= no

include $(LIBSIMPLEIO)/ada/include/ada.mk
include $(LIBSIMPLEIO)/ada/include/libsimpleio.mk

PROGRAMS	+= blinky

default: $(PROGRAMS)

clean: ada_mk_clean
	rm -f $(PROGRAMS)
