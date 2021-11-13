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

LIBSIMPLEIO	?= $(HOME)/libsimpleio
MUNTSOS		?= $(HOME)/muntsos

ifneq ($(BOARDNAME),)
# Build with MuntsOS Embedded Linux cross-toolchain
include ../../include/$(BOARDNAME).mk
INSTALLDIR	:= gcc-$(TOOLCHAIN_NAME)-libaws
else
# Build with Debian cross-toolchain, selected by CROSS_COMPILE=
CONFIGURE_NAME	:= $(shell echo $(CROSS_COMPILE) | rev | cut -c 2- | rev)
INSTALLDIR	:= $(CONFIGURE_NAME)-libaws
LIBDIR		:= /usr/local/lib/$(CONFIGURE_NAME)
endif

AR		:= $(CROSS_COMPILE)ar
CC		:= $(CROSS_COMPILE)gcc
RANLIB		:= $(CROSS_COMPILE)ranlib

CFLAGS		:= -Wall -fPIC -I$(shell pwd) $(DEBUGFLAGS)
OBJDIR		:= $(shell pwd)/obj

BUILDNUM	?= 1
OSNAME		?= unknown
PKGNAME		:= $(INSTALLDIR)
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
	rm -rf $(OBJDIR)
	mkdir $(OBJDIR)
	ln -s -f $(LIBSIMPLEIO)/c libsimpleio
	for F in $(LIBSIMPLEIO)/c/*.c ; do $(CC) $(CFLAGS) -c -o $(OBJDIR)/`basename $$F .c`.o $$F ; done
	rm libsimpleio
	touch $@

# Create static libarary

libsimpleio.a: compile.done
	$(AR) rcs $@ $(OBJDIR)/*.o
	$(RANLIB) $@

# Create shared library

libsimpleio.so: compile.done
	$(CC) -shared -o $@ $(OBJDIR)/*.o

# Precompile Ada library projects

libsimpleio.lib:
ifneq ($(BOARDNAME),)
	$(MAKE) -C adalib/muntsos BOARDNAME=$(BOARDNAME) LIBSIMPLEIO=$(LIBSIMPLEIO) build clean
else
	$(MAKE) -C adalib/cross CROSS_COMPILE=$(CROSS_COMPILE) LIBSIMPLEIO=$(LIBSIMPLEIO)
endif
	touch $@

# Create Debian package file

$(PKGDIR): libsimpleio.a libsimpleio.so libsimpleio.lib
	mkdir -p				$(PKGDIR)/DEBIAN
	install -cm 0644 control		$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g	$(PKGDIR)/DEBIAN/control
ifneq ($(BOARDNAME),)
	sed -i s/@@TARGET@@/$(BOARDBASE)/g	$(PKGDIR)/DEBIAN/control
	mkdir -p				$(PKGDIR)$(GCCSYSROOT)/usr/include/libsimpleio
	install -cm 0644 $(LIBSIMPLEIO)/c/*.h	$(PKGDIR)$(GCCSYSROOT)/usr/include/libsimpleio
	mkdir -p				$(PKGDIR)$(GCCSYSROOT)/usr/lib
	cp $(LIBSIMPLEIO)/COPYING		$(PKGDIR)$(GCCSYSROOT)/usr/lib/libsimpleio.COPYING
	install -cm 0644 libsimpleio.a		$(PKGDIR)$(GCCSYSROOT)/usr/lib
	install -cm 0755 adalib/muntsos/libsimpleio.gpr	$(PKGDIR)$(GCCSYSROOT)/usr/lib
	install -cm 0755 libsimpleio.so		$(PKGDIR)$(GCCSYSROOT)/usr/lib
	cp -R -P -p libsimpleio.lib		$(PKGDIR)$(GCCSYSROOT)/usr/lib
	mkdir -p				$(PKGDIR)$(GCCSYSROOT)/../../share/gpr
	ln -s $(GCCSYSROOT)/usr/lib/libsimpleio.gpr $(PKGDIR)$(GCCSYSROOT)/../../share/gpr/libsimpleio.gpr
else
	sed -i s/@@TARGET@@/$(CONFIGURE_NAME)/g	$(PKGDIR)/DEBIAN/control
	mkdir -p				$(PKGDIR)/usr/local/lib/$(CONFIGURE_NAME)
	install -cm 0644 $(LIBSIMPLEIO)/COPYING	$(PKGDIR)/usr/local/lib/$(CONFIGURE_NAME)/libsimpleio.COPYING
	install -cm 0644 libsimpleio.a		$(PKGDIR)/usr/local/lib/$(CONFIGURE_NAME)
	install -cm 0755 adalib/cross/libsimpleio.gpr	$(PKGDIR)/usr/local/lib/$(CONFIGURE_NAME)
	install -cm 0755 libsimpleio.so		$(PKGDIR)/usr/local/lib/$(CONFIGURE_NAME)
	cp -R -P -p $(LIBSIMPLEIO)/ada/lib/libsimpleio.lib	$(PKGDIR)/usr/local/lib/$(CONFIGURE_NAME)
	mkdir -p				$(PKGDIR)/usr/$(CONFIGURE_NAME)/share/gpr
	ln -s /usr/local/lib/$(CONFIGURE_NAME)/libsimpleio.gpr $(PKGDIR)/usr/$(CONFIGURE_NAME)/share/gpr
endif

package.deb: $(PKGFILE)

# Remove working files

clean:
ifneq ($(BOARDNAME),)
	$(MAKE) -C adalib/muntsos clean LIBSIMPLEIO=$(LIBSIMPLEIO)
else
	$(MAKE) -C adalib/cross clean LIBSIMPLEIO=$(LIBSIMPLEIO)
endif
	-rm -rf libsimpleio libsimpleio.lib obj *.done *.a *.gpr *.so $(PKGDIR) *.deb

reallyclean: clean

distclean: reallyclean
