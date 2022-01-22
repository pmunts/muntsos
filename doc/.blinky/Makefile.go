.PHONY: default clean

LIBSIMPLEIO	?= /usr/local/share/libsimpleio
MUNTSOS		?= $(HOME)/muntsos

include $(LIBSIMPLEIO)/go/include/gccgo.mk
include $(LIBSIMPLEIO)/go/include/libsimpleio.mk

LDFLAGS		+= -static

PROGRAMS	+= blinky

default: $(PROGRAMS)

clean: go_mk_reallyclean
	rm -f $(PROGRAMS)
