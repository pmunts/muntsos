.PHONY: default clean

MUNTSOS		?= $(HOME)/muntsos

include $(MUNTSOS)/include/$(BOARDNAME).mk
include $(LIBSIMPLEIO)/pascal/include/pascal.mk
include $(LIBSIMPLEIO)/pascal/include/libsimpleio.mk

PROGRAMS	+= blinky

default: $(PROGRAMS)

clean: pascal_mk_clean
	rm -f $(PROGRAMS)
