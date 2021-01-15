EMBLINUXBASE	?= $(HOME)/muntsos

include $(EMBLINUXBASE)/include/$(BOARDNAME).mk
include $(LIBSIMPLEIO)/c++/include/c++.mk
include $(LIBSIMPLEIO)/c++/include/libsimpleio.mk

CXXFLAGS	+= -I$(EMBLINUXBASE)/examples/c++/lib

default: blinky

clean: cxx_mk_clean libsimpleio_mk_clean
	for F in *.cpp ; do rm -f `basename $$F .cpp` ; done

reallyclean: clean cxx_mk_reallyclean libsimpleio_mk_reallyclean

distclean: reallyclean cxx_mk_distclean libsimpleio_mk_distclean
