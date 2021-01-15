# Makefile for building crosstools-ng package for Debian

# Copyright (C)2017-2020, Philip Munts, President, Munts AM Corp.
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

CTNG_NAME	:= crosstool-ng
CTNG_VERSION	:= 1.24.0
CTNG_SRC	:= $(CTNG_NAME)-$(CTNG_VERSION)
CTNG_TARBALL	:= $(CTNG_SRC).tar.xz
CTNG_SERVER	:= http://crosstool-ng.org/download/crosstool-ng
CTNG_URL	:= $(CTNG_SERVER)/$(CTNG_TARBALL)
CTNG_DIST	:= $(TEMP)/$(CTNG_TARBALL)

OSNAME		?= unknown
PKGNAME		:= $(CTNG_NAME)
PKGVERSION	:= $(shell date +%Y.%j)
PKGARCH		:= $(shell dpkg --print-architecture)
PKGDIR		:= $(PKGNAME)-$(PKGVERSION)-$(OSNAME)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb

default: $(PKGFILE)

# Download source distribution

$(CTNG_DIST):
	wget -P $(TEMP) $(CTNG_URL)

# Unpack source distribution

src.done: $(CTNG_DIST)
	tar xJf $(CTNG_DIST)
	cd $(CTNG_SRC) ; patch -p0 <../remove.patch
	touch $@

# Build crosstool-ng

build.done: src.done
	cd $(CTNG_SRC) && ./configure
	$(MAKE) -C $(CTNG_SRC) MAKELEVEL=0
	touch $@

# Build Debian package file

$(PKGFILE): $(PKGDIR)
	chmod -R ugo-w $(PKGDIR)/usr
	fakeroot dpkg-deb --build $(PKGDIR)
	chmod -R u+w $(PKGDIR)/usr

$(PKGDIR): build.done
	mkdir -p $(PKGDIR)/DEBIAN
	install -cm 0444 control			$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g		$(PKGDIR)/DEBIAN/control
	$(MAKE) -C $(CTNG_SRC) install DESTDIR=$(shell pwd)/$(PKGDIR) MAKELEVEL=0

# Remove working files

clean:
	-rm -rf $(PKGFILE) $(PKGDIR)

reallyclean: clean
	-rm -rf *.done $(CTNG_SRC)

distclean: reallyclean
