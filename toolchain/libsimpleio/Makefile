# Makefile to build the Linux Simple I/O Library for MuntsOS Embedded Linux

# Copyright (C)2021-2024, Philip Munts dba Munts Technologies.
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

LIBSIMPLEIO	?= $(shell pwd)/../../../libsimpleio
MUNTSOS		?= $(shell pwd)/../..

include $(MUNTSOS)/include/$(BOARDNAME).mk

INSTALLDIR	:= gcc-$(TOOLCHAIN_NAME)
BINDIR		:= $(GCCSYSROOT)/usr/libexec
INCDIR		:= $(GCCSYSROOT)/usr/include
LIBDIR		:= $(GCCSYSROOT)/usr/lib
GPRDIR		:= $(GCCSYSROOT)/../../share/gpr

AR		:= $(CROSS_COMPILE)ar
CC		:= $(CROSS_COMPILE)gcc
RANLIB		:= $(CROSS_COMPILE)ranlib
STRIP		:= $(CROSS_COMPILE)strip

BUILDNUM	?= 1
PKGNAME		:= $(INSTALLDIR)-libsimpleio
PKGVER		:= $(GCCVER)-$(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		:= all
PKGDIR		:= $(PKGNAME)-$(PKGVER)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb

include $(LIBSIMPLEIO)/ada/include/ada.mk
include $(LIBSIMPLEIO)/include/dpkg.mk

default: package.deb

###############################################################################

# Compile C and C++ source files

compile.done:
	rm -rf obj
	mkdir obj
	ln -s -f $(LIBSIMPLEIO)/c libsimpleio
	for F in $(LIBSIMPLEIO)/c/*.c ; do $(CC) -Wall -fPIC -I$(shell pwd) -c -o obj/`basename $$F .c`.o $$F ; done
	touch $@

###############################################################################

# Create static libarary

libsimpleio.a: compile.done
	$(AR) rcs $@ obj/*.o
	$(RANLIB) $@

###############################################################################

# Create shared library

libsimpleio.so: compile.done
	$(CC) -shared -o $@ obj/*.o

###############################################################################

# Build the precompiled Ada package library for MuntsOS

libsimpleio.lib:
	LIBSIMPLEIO=$(LIBSIMPLEIO) $(GPRBUILD) $(GPRBUILDFLAGS) -P build
	touch $@

###############################################################################

# Compile link-gpiochip

link-gpiochip: libsimpleio.a
	$(CC) -Wall -I. -o$@ $(LIBSIMPLEIO)/hotplug/linux/link-gpiochip.c libsimpleio.a
	$(STRIP) $@

###############################################################################

# Create Debian package file

$(PKGDIR): libsimpleio.a libsimpleio.so libsimpleio.lib link-gpiochip
	mkdir -p				$(PKGDIR)/DEBIAN
	install -cm 0644 control		$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g	$(PKGDIR)/DEBIAN/control
	sed -i s/@@TARGET@@/$(TARGET)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@TOOLCHAIN@@/$(TOOLCHAIN_NAME)/g $(PKGDIR)/DEBIAN/control
	mkdir -p				$(PKGDIR)$(BINDIR)
	install -cm 0755 link-gpiochip		$(PKGDIR)$(BINDIR)
	mkdir -p				$(PKGDIR)$(INCDIR)
	ln -s /usr/local/include/libsimpleio	$(PKGDIR)$(INCDIR)/libsimpleio
	mkdir -p				$(PKGDIR)$(LIBDIR)
	install -cm 0644 $(LIBSIMPLEIO)/COPYING	$(PKGDIR)$(LIBDIR)/libsimpleio.COPYING
	install -cm 0644 libsimpleio.a		$(PKGDIR)$(LIBDIR)
	install -cm 0755 libsimpleio.so		$(PKGDIR)$(LIBDIR)
	cp -R -P -p libsimpleio.lib		$(PKGDIR)$(LIBDIR)
	mkdir -p				$(PKGDIR)$(GPRDIR)
	install -cm 0644 libsimpleio.gpr	$(PKGDIR)$(GPRDIR)
	sed -i 's@LIBDIR@$(LIBDIR)@g'		$(PKGDIR)$(GPRDIR)/libsimpleio.gpr
	touch $@

package.deb: $(PKGFILE)

###############################################################################

# Remove working files

clean:
	-rm -rf $(PKGDIR) $(PKGFILE)
	-rm -rf compile.done libsimpleio libsimpleio.a libsimpleio.lib libsimpleio.obj libsimpleio.so link-gpiochip obj

reallyclean: clean

distclean: reallyclean
