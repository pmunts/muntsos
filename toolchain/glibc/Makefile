# Makefile for building glibc for a Debian cross-toolchain

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

# NOTE: The Debian cross-toolchain libc6 packages are incomplete, so we have
# to build the full glibc ourself.

include ../../include/$(BOARDNAME).mk

GLIBC_NAME		:= glibc
GLIBC_VER		:= 2.31
GLIBC_SRC		:= $(GLIBC_NAME)-$(GLIBC_VER)
GLIBC_TARBALL		:= $(GLIBC_NAME)-$(GLIBC_VER).tar.xz
GLIBC_SERVER		:= http://ftp.gnu.org/gnu/glibc
GLIBC_URL		:= $(GLIBC_SERVER)/$(GLIBC_TARBALL)
GLIBC_DIST		:= $(TEMP)/$(GLIBC_TARBALL)
GLIBC_BLD		:= $(GLIBC_NAME)-$(GLIBC_VER)-build

BOARDBASE		:= $(CONFIGURE_NAME)
BUILDOS			:= --build=`uname -m`
TARGETOS		:= --host=$(CONFIGURE_NAME)
INSTALLDIR		:= /usr/local/$(CONFIGURE_NAME)-muntsos-debian

CONFIGFLAGS		+= $(BUILDOS) $(TARGETOS)
CONFIGFLAGS		+= --prefix=$(INSTALLDIR)
CONFIGFLAGS		+= CC=$(CROSS_COMPILE)gcc
CONFIGFLAGS		+= $(EXTRACONFIGFLAGS)

BUILDNUM		?= 1
OSNAME			?= unknown
PKGNAME			= $(CONFIGURE_NAME)-muntsos-debian-glibc
PKGVER			= $(GLIBC_VER)-$(BUILDNUM)
PKGARCH			= all
PKGSUFFIX		= $(PKGVER)-$(OSNAME)-$(PKGARCH)
PKGDIR			= $(PKGNAME)-$(PKGSUFFIX)
PKGFILE			= $(PKGDIR).deb

DESTDIR			:= $(shell pwd)/$(PKGDIR)

default: package.deb

###############################################################################

# Download glibc source distribution

$(GLIBC_DIST):
	wget -nv -P $(TEMP) $(GLIBC_URL)

# Unpack glibc source

source.done: $(GLIBC_DIST)
	tar xJf $(GLIBC_DIST)
	touch $@

###############################################################################

# Build glibc

build.done: source.done
	mkdir -p $(GLIBC_BLD)
	cd $(GLIBC_BLD) && ../$(GLIBC_SRC)/configure $(CONFIGFLAGS)
	$(MAKE) -C $(GLIBC_BLD)
	touch $@

###############################################################################

# Create Debian package

package.deb: build.done
	mkdir -p					$(PKGDIR)/DEBIAN
	install -cm 0644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@BOARDNAME@@/$(BOARDBASE)/g		$(PKGDIR)/DEBIAN/control
	mkdir -p					$(PKGDIR)/usr/local
	$(MAKE) -C $(GLIBC_BLD) install DESTDIR=$(DESTDIR)
	chmod -R ugo-w					$(PKGDIR)/usr/*
	fakeroot dpkg-deb --build			$(PKGDIR)
	chmod -R u+w					$(PKGDIR)/usr/*

###############################################################################

# Remove working files

clean:
	rm -rf $(PKGDIR) $(PKGFILE)

reallyclean: clean
	rm -rf *.done $(GLIBC_SRC) $(GLIBC_BLD)

distclean: reallyclean
	rm -f $(GLIBC_DIST)
