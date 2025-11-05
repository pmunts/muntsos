# Makefile to build the Linux Simple I/O Library for MuntsOS Embedded Linux

# Copyright (C)2021-2025, Philip Munts dba Munts Technologies.
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
PKGVER		:= $(GCCVER)-$(shell date +%Y.%j)-$(BUILDNUM)
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

# Build the precompiled GNU Modula-2 module library for MuntsOS

libsimpleiogm2.a:
	$(MAKE) -R -C $(LIBSIMPLEIO)/gm2/lib LIBSIMPLEIO=$(LIBSIMPLEIO) LIBSIMPLEIOGM2=`pwd`/libsimpleiogm2.a

###############################################################################

# Build Ada source and C API shared libraries

libwioe5ham1.so:
	$(MAKE) -C $(LIBSIMPLEIO)/ada/shared-libs/libwioe5ham1
	cp $(LIBSIMPLEIO)/ada/shared-libs/libwioe5ham1/lib/libwioe5ham1.so .
	$(STRIP) $@

libwioe5ham2.so:
	$(MAKE) -C $(LIBSIMPLEIO)/ada/shared-libs/libwioe5ham2
	cp $(LIBSIMPLEIO)/ada/shared-libs/libwioe5ham2/lib/libwioe5ham2.so .
	$(STRIP) $@

libwioe5p2p.so:
	$(MAKE) -C $(LIBSIMPLEIO)/ada/shared-libs/libwioe5p2p
	cp $(LIBSIMPLEIO)/ada/shared-libs/libwioe5p2p/lib/libwioe5p2p.so .
	$(STRIP) $@

###############################################################################

# Create Debian package file

$(PKGDIR): libsimpleio.a libsimpleio.so libsimpleio.lib libsimpleiogm2.a libwioe5ham1.so libwioe5ham2.so libwioe5p2p.so
	mkdir -p				$(PKGDIR)/DEBIAN
	install -cm 0644 control.template	$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g	$(PKGDIR)/DEBIAN/control
	sed -i s/@@BOARDNAME@@/$(BOARDNAME)/g	$(PKGDIR)/DEBIAN/control
	sed -i s/@@TOOLCHAIN@@/$(TOOLCHAIN_NAME)/g $(PKGDIR)/DEBIAN/control
	mkdir -p				$(PKGDIR)$(BINDIR)
	mkdir -p				$(PKGDIR)$(INCDIR)
	ln -s /usr/local/include/libsimpleio	$(PKGDIR)$(INCDIR)/libsimpleio
	install -cm 0644 $(LIBSIMPLEIO)/ada/shared-libs/libwioe5ham1/libwioe5ham1.h $(PKGDIR)$(INCDIR)
	install -cm 0644 $(LIBSIMPLEIO)/ada/shared-libs/libwioe5ham2/libwioe5ham2.h $(PKGDIR)$(INCDIR)
	install -cm 0644 $(LIBSIMPLEIO)/ada/shared-libs/libwioe5p2p/libwioe5p2p.h $(PKGDIR)$(INCDIR)
	mkdir -p				$(PKGDIR)$(LIBDIR)
	install -cm 0644 $(LIBSIMPLEIO)/COPYING	$(PKGDIR)$(LIBDIR)/libsimpleio.COPYING
	install -cm 0644 *.a			$(PKGDIR)$(LIBDIR)
	install -cm 0755 *.so			$(PKGDIR)$(LIBDIR)
	cp -R -P -p *.lib			$(PKGDIR)$(LIBDIR)
	mkdir -p				$(PKGDIR)$(GPRDIR)
	install -cm 0644 libsimpleio.gpr	$(PKGDIR)$(GPRDIR)
	sed -i 's@LIBDIR@$(LIBDIR)@g'		$(PKGDIR)$(GPRDIR)/libsimpleio.gpr
	touch $@

package.deb: $(PKGFILE)

###############################################################################

# Remove working files

clean:
	-rm -rf compile.done obj libsimpleio $(PKGDIR) $(PKGFILE)
	-rm -rf *.a *.lib *.obj *.so
	$(MAKE) -C $(LIBSIMPLEIO)/ada/shared-libs/libwioe5ham1 clean
	$(MAKE) -C $(LIBSIMPLEIO)/ada/shared-libs/libwioe5ham2 clean
	$(MAKE) -C $(LIBSIMPLEIO)/ada/shared-libs/libwioe5p2p  clean

reallyclean: clean

distclean: reallyclean
