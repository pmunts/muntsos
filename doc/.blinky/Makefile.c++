.PHONY: default clean

MUNTSOS		?= $(HOME)/muntsos

include $(MUNTSOS)/include/$(BOARDNAME).mk
include $(LIBSIMPLEIO)/c++/include/c++.mk
include $(LIBSIMPLEIO)/c++/include/libsimpleio.mk

#CXXFLAGS	+= -I$(MUNTSOS)/examples/c++/lib

PROGRAMS	+= blinky

default: subordinates.a $(PROGRAMS)

clean: cxx_mk_reallyclean
	rm -f $(PROGRAMS)
