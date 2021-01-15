EMBLINUXBASE	?= $(HOME)/muntsos

GPRBUILD	?= no

include $(EMBLINUXBASE)/include/$(BOARDNAME).mk
include $(LIBSIMPLEIO)/ada/include/ada.mk
include $(LIBSIMPLEIO)/ada/include/libsimpleio.mk

default: blinky

clean: ada_mk_clean
	for F in *.adb ; do rm -f `basename $$F .adb` ; done

reallyclean: clean ada_mk_reallyclean

distclean: reallyclean ada_mk_distclean
