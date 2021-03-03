.PHONY: default clean

MUNTSOS		?= $(HOME)/muntsos

include $(MUNTSOS)/include/$(BOARDNAME).mk
include $(LIBSIMPLEIO)/c++/include/c++.mk
include $(LIBSIMPLEIO)/c++/include/libsimpleio.mk

PROGRAMS	+= blinky

default: subordinates.a $(PROGRAMS)

clean: cxx_mk_reallyclean
	rm -f $(PROGRAMS)
