# Makefile for building libcrypt for a Debian cross-toolchain

# Copyright (C)2022, Philip Munts, President, Munts AM Corp.
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

include ../../include/$(BOARDNAME).mk

LIBXCRYPT_NAME		:= libxcrypt
LIBXCRYPT_VER		:= 4.4.27
LIBXCRYPT_SRC		:= $(LIBXCRYPT_NAME)-$(LIBXCRYPT_VER)
LIBXCRYPT_TARBALL	:= $(LIBXCRYPT_SRC).tar.xz
LIBXCRYPT_SERVER	:= https://github.com/besser82/libxcrypt/releases/download/v$(LIBXCRYPT_VER)
LIBXCRYPT_URL		:= $(LIBXCRYPT_SERVER)/$(LIBXCRYPT_TARBALL)
LIBXCRYPT_DIST		:= $(TEMP)/$(LIBXCRYPT_TARBALL)

BOARDBASE		:= $(CONFIGURE_NAME)
BUILDOS			:= --build=`uname -m`
TARGETOS		:= --host=$(CONFIGURE_NAME)
INSTALLDIR		:= $(CONFIGURE_NAME)-muntsos-debian
DESTDIR			:= $(shell pwd)
FINALDIR		:= /usr/local/$(INSTALLDIR)

BUILDNUM		?= 1
OSNAME			?= unknown
PKGNAME			= $(CONFIGURE_NAME)-muntsos-debian-libcrypt
PKGVER			= $(LIBXCRYPT_VER)-$(BUILDNUM)
PKGARCH			= all
PKGSUFFIX		= $(PKGVER)-$(OSNAME)-$(PKGARCH)
PKGDIR			= $(PKGNAME)-$(PKGSUFFIX)
PKGFILE			= $(PKGDIR).deb

default: package.deb

###############################################################################

# Download libxcrypt source distribution

$(LIBXCRYPT_DIST):
	wget -nv -P $(TEMP) $(LIBXCRYPT_URL)

# Unpack libxcrypt source

$(LIBXCRYPT_SRC): $(LIBXCRYPT_DIST)
	tar xJf $(LIBXCRYPT_DIST)
	touch $@

source: $(LIBXCRYPT_SRC)

###############################################################################

# Build libxcrypt

$(INSTALLDIR)/lib/libcrypt.a: $(LIBXCRYPT_SRC)
	cd $(LIBXCRYPT_SRC) && ./configure $(BUILDOS) $(TARGETOS) --prefix=/$(INSTALLDIR) --disable-xcrypt-compat-files CC=$(CROSS_COMPILE)gcc
	$(MAKE) -C $(LIBXCRYPT_SRC)
	$(MAKE) -C $(LIBXCRYPT_SRC) install DESTDIR=$(DESTDIR)
	rm -f $(INSTALLDIR)/lib/libowcrypt.*
	rm -rf $(INSTALLDIR)/lib/pkgconfig
	cp $(LIBXCRYPT_SRC)/COPYING.LIB $(INSTALLDIR)/lib/libcrypt.COPYING

build: $(INSTALLDIR)/lib/libcrypt.a

###############################################################################

# Create Debian package

package.deb: $(INSTALLDIR)/lib/libcrypt.a
	mkdir -p					$(PKGDIR)/DEBIAN
	install -cm 0644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@BOARDNAME@@/$(BOARDBASE)/g		$(PKGDIR)/DEBIAN/control
	mkdir -p					$(PKGDIR)/usr/local
	cp -R -P -p $(INSTALLDIR)			$(PKGDIR)/usr/local
	chmod -R ugo-w					$(PKGDIR)/usr/*
	fakeroot dpkg-deb --build			$(PKGDIR)
	chmod -R u+w					$(PKGDIR)/usr/*

###############################################################################

# Remove working files

clean:
	rm -rf $(LIBXCRYPT_SRC) $(INSTALLDIR) $(PKGDIR) $(PKGFILE)

reallyclean: clean

distclean: reallyclean
