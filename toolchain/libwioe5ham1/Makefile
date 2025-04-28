# Copyright (C)2025, Philip Munts dba Munts Technologies.
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

LIBSIMPLEIO	?= /usr/local/share/libsimpleio

include $(LIBSIMPLEIO)/ada/include/ada.mk
include $(LIBSIMPLEIO)/ada/include/libsimpleio.mk
include $(LIBSIMPLEIO)/include/dpkg.mk

INSTALLDIR	:= gcc-$(TOOLCHAIN_NAME)
INCDIR		:= $(GCCSYSROOT)/usr/include
LIBDIR		:= $(GCCSYSROOT)/usr/lib

BUILDNUM	?= 1
PKGNAME		:= $(INSTALLDIR)-libwioe5ham1
PKGVER		:= $(GCCVER)-$(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		:= all
PKGDIR		:= $(PKGNAME)-$(PKGVER)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb

default: package.deb

###############################################################################

# Gather subordinates

subordinates:
	mkdir -p							$@
	cp $(LIBSIMPLEIO)/ada/bindings/errno.ads			$@
	cp $(LIBSIMPLEIO)/ada/bindings/liblinux.*			$@
	cp $(LIBSIMPLEIO)/ada/bindings/libserial.*			$@
	cp $(LIBSIMPLEIO)/ada/interfaces/logging.ads			$@
	cp $(LIBSIMPLEIO)/ada/devices/wio_e5.*				$@
	cp $(LIBSIMPLEIO)/ada/devices/wio_e5-ham1.*			$@
	cp $(LIBSIMPLEIO)/ada/objects/simpleio/logging-libsimpleio.*	$@
	touch $@

###############################################################################

# Build the shared library project

libwioe5ham1.so: subordinates
	$(GPRBUILD) $(GPRBUILDFLAGS)
	cp obj/lib/*.so .
	$(CROSS_COMPILE)strip *.so

###############################################################################

# Create Debian package file

$(PKGDIR): libwioe5ham1.so
	mkdir -p				$(PKGDIR)/DEBIAN
	install -cm 0644 control		$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g	$(PKGDIR)/DEBIAN/control
	sed -i s/@@BOARDNAME@@/$(BOARDNAME)/g	$(PKGDIR)/DEBIAN/control
	sed -i s/@@TOOLCHAIN@@/$(TOOLCHAIN_NAME)/g $(PKGDIR)/DEBIAN/control
	mkdir -p				$(PKGDIR)$(INCDIR)
	install -cm 0644 libwioe5ham1.h		$(PKGDIR)$(INCDIR)
	mkdir -p				$(PKGDIR)$(LIBDIR)
	install -cm 0755 libwioe5ham1.so	$(PKGDIR)$(LIBDIR)

package.deb: $(PKGFILE)

###############################################################################

# Build optional tests

test1: test1.c
	$(CROSS_COMPILE)gcc -Wall -o$@ $< -lwioe5ham1

###############################################################################

# Remove working files

clean:
	rm -rf obj subordinates *.so $(PKGDIR) $(PKGFILE)
