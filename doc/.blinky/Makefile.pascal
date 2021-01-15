EMBLINUXBASE	?= $(HOME)/muntsos

include $(EMBLINUXBASE)/include/$(BOARDNAME).mk
include $(LIBSIMPLEIO)/pascal/include/pascal.mk
include $(LIBSIMPLEIO)/pascal/include/libsimpleio.mk

default: blinky

clean: pascal_mk_clean
	for F in *.pas ; do rm -f `basename $$F .pas` ; done

reallyclean: pascal_mk_reallyclean clean

distclean: pascal_mk_distclean reallyclean
