.PHONY: default clean

LIBSIMPLEIO	?= /usr/local/share/libsimpleio
MUNTSOS		?= /usr/local/share/muntsos

include $(LIBSIMPLEIO)/c++/include/c++.mk
include $(LIBSIMPLEIO)/c++/include/libsimpleio.mk

PROGRAMS	+= blinky

default: $(PROGRAMS)

clean: cxx_mk_reallyclean
	rm -f $(PROGRAMS)
