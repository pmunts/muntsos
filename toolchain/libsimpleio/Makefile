# Makefile to build the Linux Simple I/O Library for MuntsOS Embedded Linux

# Copyright (C)2021, Philip Munts, President, Munts AM Corp.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

undefine AR
undefine CC
undefine RANLIB

LIBSIMPLEIO	?= $(HOME)/src/libsimpleio
MUNTSOS		?= $(HOME)/muntsos

include $(MUNTSOS)/include/$(BOARDNAME).mk

AR		:= $(CROSS_COMPILE)ar
CC		:= $(CROSS_COMPILE)gcc
RANLIB		:= $(CROSS_COMPILE)ranlib

CFLAGS		= -Wall -fPIC -I. -I.. $(DEBUGFLAGS)

BUILDNUM	?= 1
OSNAME		?= unknown
PKGNAME		:= gcc-$(TOOLCHAIN_NAME)-libsimpleio
PKGVERSION	:= $(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		:= all
PKGDIR		:= $(PKGNAME)-$(PKGVERSION)-$(OSNAME)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb

include $(LIBSIMPLEIO)/include/dpkg.mk

default: package.deb

SIMPLEIO_COMPONENTS	= errmsg.o libevent.o libgpio.o libhidraw.o libi2c.o
SIMPLEIO_COMPONENTS	+= libserial.o libspi.o liblinux.o liblinx.o
SIMPLEIO_COMPONENTS	+= libpwm.o libipv4.o libstream.o libwatchdog.o
SIMPLEIO_COMPONENTS	+= libadc.o

# Compile C and C++ source files

compile.done:
	ln -s $(LIBSIMPLEIO)/c
	rm -rf obj
	mkdir obj
	for F in c/*.c ; do $(CC) $(CFLAGS) -c -o obj/`basename $$F .c`.o $$F ; done
	touch $@

# Create static libarary

libsimpleio.a: compile.done
	$(AR) rcs $@ obj/*.o
	$(RANLIB) $@

# Create shared library

libsimpleio.so: compile.done
	$(CC) -shared -o $@ obj/*.o

# Create GNAT library project

libsimpleio.gpr:
	cp $(LIBSIMPLEIO)/ada/lib/muntsos/libsimpleio.gpr .
	sed -i '/LIBSIMPLEIO :=/,+1 d'		$@
	sed -i '/Object_Dir/,+1 d'		$@
	sed -i 's:false:true:g'			$@
	sed -i 's:LIBSIMPLEIO & "/ada/lib:"$(GCCSYSROOT)/usr/lib:g' $@
	sed -i 's:LIBSIMPLEIO & "/ada:"/usr/local/share/libsimpleio/ada:g' $@

# Precompile Ada library projects

adalibs.done:
	$(MAKE) -C $(LIBSIMPLEIO)/ada/lib/muntsos BOARDNAME=$(BOARDNAME) LIBSIMPLEIO=$(LIBSIMPLEIO)
	touch $@

# Create Debian package file

$(PKGDIR): libsimpleio.a libsimpleio.so libsimpleio.gpr adalibs.done
	mkdir -p				$(PKGDIR)/DEBIAN
	install -cm 0644 control.muntsos	$(PKGDIR)/DEBIAN/control
	sed -i s/@@BOARDNAME@@/$(BOARDBASE)/g	$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g	$(PKGDIR)/DEBIAN/control
	mkdir -p				$(PKGDIR)$(GCCSYSROOT)/usr/include/libsimpleio
	install -cm 0644 c/*.h			$(PKGDIR)$(GCCSYSROOT)/usr/include/libsimpleio
	mkdir -p				$(PKGDIR)$(GCCSYSROOT)/usr/lib
	cp $(LIBSIMPLEIO)/COPYING		$(PKGDIR)$(GCCSYSROOT)/usr/lib/libsimpleio.COPYING
	install -cm 0644 libsimpleio.a		$(PKGDIR)$(GCCSYSROOT)/usr/lib
	install -cm 0755 libsimpleio.gpr	$(PKGDIR)$(GCCSYSROOT)/usr/lib
	install -cm 0755 libsimpleio.so		$(PKGDIR)$(GCCSYSROOT)/usr/lib
	cp -R -P -p $(LIBSIMPLEIO)/ada/lib/libsimpleio.lib	$(PKGDIR)$(GCCSYSROOT)/usr/lib
	mkdir -p				$(PKGDIR)$(GCCSYSROOT)/../../share/gpr
	ln -s $(GCCSYSROOT)/usr/lib/libsimpleio.gpr $(PKGDIR)$(GCCSYSROOT)/../../share/gpr/libsimpleio.gpr

package.deb: $(PKGFILE)

# Remove working files

clean:
	$(MAKE) -C $(LIBSIMPLEIO)/ada/lib/muntsos clean LIBSIMPLEIO=$(LIBSIMPLEIO)
	-rm -rf c libsimpleio obj *.done *.a *.gpr *.so $(PKGDIR) *.deb

reallyclean: clean

distclean: reallyclean
