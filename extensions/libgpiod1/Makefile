# Makefile for building the libgpiod package for MuntsOS

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

BOARDNAME	?= UNDEFINED
MUNTSOS		?= /usr/local/share/muntsos

include $(MUNTSOS)/include/$(BOARDNAME).mk
include $(LIBSIMPLEIO)/include/dpkg.mk

PKGNAME		= libgpiod1
PKGVERSION	= $(shell date +%Y.%j)
PKGARCH		= $(DEBARCH)
PKGDIR		= $(PKGNAME)-muntsos-$(BOARDARCH)
PKGFILE		= $(PKGDIR).deb

default: package.deb

###############################################################################

LIBGPIOD_NAME	= libgpiod
LIBGPIOD_VER	= 1.6.5
LIBGPIOD_SRC	= $(LIBGPIOD_NAME)-$(LIBGPIOD_VER)
LIBGPIOD_TARBALL = $(LIBGPIOD_NAME)-$(LIBGPIOD_VER).tar.gz
LIBGPIOD_SERVER	= https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/snapshot
LIBGPIOD_URL	= $(LIBGPIOD_SERVER)/$(LIBGPIOD_TARBALL)
LIBGPIOD_DIST	= $(TEMP)/$(LIBGPIOD_TARBALL)

CONFIG_FLAGS	+= --build=`uname -m`
CONFIG_FLAGS	+= --host=$(CONFIGURE_NAME)
CONFIG_FLAGS	+= --enable-tools
CONFIG_FLAGS	+= --disable-bindings-cxx
CONFIG_FLAGS	+= --disable-bindings-python
CONFIG_FLAGS	+= --prefix=/usr/local CC=$(CROSS_COMPILE)gcc

DESTDIR		= $(shell pwd)/$(LIBGPIOD_SRC)

# Download libgpiod source distribution

$(LIBGPIOD_DIST):
	wget -nv -P $(TEMP) $(LIBGPIOD_URL)

# Unpack libgpiod source distribution

$(LIBGPIOD_SRC): $(LIBGPIOD_DIST)
	tar xzf $^
	cd $(LIBGPIOD_SRC) && patch -b -p0 <../libgpiod1.patch

# Build libgpiod

$(LIBGPIOD_SRC)/usr/local/lib/libgpiod.so.2: $(LIBGPIOD_SRC)
	cd $(LIBGPIOD_SRC) && ./autogen.sh
	cd $(LIBGPIOD_SRC) && ./configure $(CONFIG_FLAGS)
	$(MAKE) -C $(LIBGPIOD_SRC)
	$(MAKE) -C $(LIBGPIOD_SRC) install DESTDIR=$(DESTDIR)

libgpiod1: $(LIBGPIOD_SRC)/usr/local/lib/libgpiod.so.2

###############################################################################

# Build the Debian package file

$(PKGDIR): libgpiod1
	mkdir -p						$@/DEBIAN
	install -cm 0644 control				$@/DEBIAN
	install -cm 0755 postinst				$@/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g				$@/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g				$@/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g			$@/DEBIAN/control
	mkdir -p						$@/usr/local/bin
	install -cm 0755 $(LIBGPIOD_SRC)/usr/local/bin/*	$@/usr/local/bin
	$(CROSS_COMPILE)strip					$@/usr/local/bin/*
	mkdir -p						$@/usr/local/lib
	install -cm 0755 $(LIBGPIOD_SRC)/usr/local/lib/*.so.2	$@/usr/local/lib
	$(CROSS_COMPILE)strip					$@/usr/local/lib/*
	touch $@

package.deb: $(PKGFILE)

# Upload package to repository

upload: $(PKGFILE)
	scp $^ $(REPOSITORY)

# Download prebuilt package

download_prebuilt: $(PKGFILE).downloaded

$(PKGFILE).downloaded:
	wget -q -nc $(DOWNLOADPREFIX)/extensions/$(PKGFILE)
	touch $(PKGFILE).downloaded

# Remove working files

clean:
	rm -rf $(PKGDIR)
	if [ ! -f $(PKGFILE).downloaded ]; then rm -f $(PKGFILE) ; fi

reallyclean: clean
	rm -rf $(PKGFILE) $(PKGFILE).downloaded
	rm -rf $(LIBGPIOD_SRC)

distclean: reallyclean
	rm -rf $(LIBGPIOD_DIST)
