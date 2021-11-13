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
LIBNAME		:= gcc-$(TOOLCHAIN_NAME)-libaws
GPRDIR		:= $(PKGDIR)$(GCCSYSROOT)/../../share/gpr
LIBDIR		:= $(GCCSYSROOT)/usr/lib
TARGET		:= $(BOARDBASE)
else
# Build with Debian cross-toolchain, selected by CROSS_COMPILE=
CONFIGURE_NAME	:= $(shell echo $(CROSS_COMPILE) | rev | cut -c 2- | rev)
LIBNAME		:= $(CONFIGURE_NAME)-libaws
GPRDIR		:= /usr/$(CONFIGURE_NAME)/share/gpr
LIBDIR		:= /usr/local/lib/$(CONFIGURE_NAME)
TARGET	 	:= $(CONFIGURE_NAME)
endif

AR		:= $(CROSS_COMPILE)ar
CC		:= $(CROSS_COMPILE)gcc
RANLIB		:= $(CROSS_COMPILE)ranlib

BUILDNUM	?= 1
OSNAME		?= unknown
PKGNAME		:= $(LIBNAME)
PKGVERSION	:= $(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		:= all
PKGDIR		:= $(PKGNAME)-$(PKGVERSION)-$(OSNAME)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb

include $(LIBSIMPLEIO)/ada/include/ada.mk
include $(LIBSIMPLEIO)/include/dpkg.mk

default: package.deb

# Compile C and C++ source files

compile.done:
	rm -rf obj
	mkdir obj
	ln -s -f $(LIBSIMPLEIO)/c libsimpleio
	for F in $(LIBSIMPLEIO)/c/*.c ; do $(CC) -Wall -fPIC -I$(shell pwd) -c -o obj/`basename $$F .c`.o $$F ; done
	touch $@

# Create static libarary

libsimpleio.a: compile.done
	$(AR) rcs $@ obj/*.o
	$(RANLIB) $@

# Create shared library

libsimpleio.so: compile.done
	$(CC) -shared -o $@ obj/*.o

# Precompile the Ada library project

libsimpleio.lib:
	LIBSIMPLEIO=$(LIBSIMPLEIO) $(GPRBUILD) $(GPRBUILDFLAGS) -P build
	touch $@

# Create Debian package file

$(PKGDIR): libsimpleio.a libsimpleio.so libsimpleio.lib
	mkdir -p				$(PKGDIR)/DEBIAN
	install -cm 0644 control		$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g	$(PKGDIR)/DEBIAN/control
	sed -i s/@@TARGET@@/$(TARGET)/g		$(PKGDIR)/DEBIAN/control
	mkdir -p				$(PKGDIR)$(LIBDIR)
	cp $(LIBSIMPLEIO)/COPYING		$(PKGDIR)$(LIBDIR)/libsimpleio.COPYING
	install -cm 0644 libsimpleio.a		$(PKGDIR)$(LIBDIR)
	install -cm 0755 libsimpleio.gpr	$(PKGDIR)$(LIBDIR)
	sed -i 's:@@LIBDIR@@:$(LIBDIR):g'	$(PKGDIR)$(LIBDIR)/libsimpleio.gpr
	install -cm 0755 libsimpleio.so		$(PKGDIR)$(LIBDIR)
	cp -R -P -p libsimpleio.lib		$(PKGDIR)$(LIBDIR)
	mkdir -p				$(PKGDIR)$(GPRDIR)
	ln -s $(LIBDIR)/libsimpleio.gpr		$(PKGDIR)$(GPRDIR)/libsimpleio.gpr

package.deb: $(PKGFILE)

# Remove working files

clean:
	-rm -rf compile.done libsimpleio libsimpleio.a libsimpleio.lib libsimpleio.so obj $(PKGDIR) *.deb

reallyclean: clean

distclean: reallyclean
