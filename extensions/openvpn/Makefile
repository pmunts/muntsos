# Makefile for building the openvpn package for MuntsOS

# Copyright (C)2020-2024, Philip Munts dba Munts Technologies.
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

BUILDOS		= --build=`uname -m`
TARGETOS	= --host=$(CONFIGURE_NAME)

SRCNAME		= openvpn
SRCVER		= 2.6.10
SRCDIR		= $(SRCNAME)-$(SRCVER)
SRCTARBALL	= $(SRCDIR).tar.gz
SRCSERVER	= https://github.com/OpenVPN/openvpn/releases/download/v$(SRCVER)
SRCURL		= $(SRCSERVER)/$(SRCTARBALL)
SRCDIST		= $(TEMP)/$(SRCTARBALL)

PKGNAME		= $(SRCNAME)
PKGVERSION	= $(SRCVER)-$(shell date +%Y.%j)
PKGARCH		= $(DEBARCH)
PKGDIR		= $(PKGNAME)-muntsos-$(BOARDARCH)
PKGFILE		= $(PKGDIR).deb

CONFIGFLAGS	= $(BUILDOS) $(TARGETOS)
CONFIGFLAGS	+= --disable-lzo
CONFIGFLAGS	+= --disable-lz4
CONFIGFLAGS	+= --disable-plugin-auth-pam
CONFIGFLAGS	+= --disable-pam-dlopen
CONFIGFLAGS	+= CC=$(CROSS_COMPILE)gcc
CONFIGFLAGS	+= PKG_CONFIG_LIBDIR=$(LIBSPKGCONFIG)

default: package.deb

# Download the source distribution

$(SRCDIST):
	wget -nv -P $(TEMP) $(SRCURL)

# Unpack the source distribution

src.done: $(SRCDIST)
	tar xzf $^
	touch $@

# Compile sources

build.done: src.done
	cd $(SRCDIR) ; ./configure $(CONFIGFLAGS)
	$(MAKE) -C $(SRCDIR)
	touch $@

# Build the Debian package file

$(PKGDIR): build.done
	mkdir -p					$(PKGDIR)/DEBIAN
	install -cm 0644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g		$(PKGDIR)/DEBIAN/control
	install -cm 0755 postinst			$(PKGDIR)/DEBIAN
	$(MAKE) -C $(SRCDIR) install DESTDIR=$(shell pwd)/$(PKGDIR)
	$(CROSS_COMPILE)strip				$(PKGDIR)/usr/local/sbin/*
	mkdir -p					$(PKGDIR)/usr/local/etc
	rm -rf						$(PKGDIR)/usr/local/include
	install -cm 0755 $(LIBSLIBDIR)/libcap-ng.so.0	$(PKGDIR)/usr/local/lib
	$(CROSS_COMPILE)strip				$(PKGDIR)/usr/local/lib/*.so*
	rm -rf						$(PKGDIR)/usr/local/share
	mkdir -p					$(PKGDIR)/etc/rc.d
	install -cm 0755 startup			$(PKGDIR)/etc/rc.d/S60-openvpn
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
	rm -rf build.done $(PKGDIR)
	if [ ! -f $(PKGFILE).downloaded ]; then rm -f $(PKGFILE) ; fi
	-$(MAKE) -C $(SRCDIR) distclean

reallyclean: clean
	rm -rf src.done $(SRCDIR) $(PKGFILE) $(PKGFILE).downloaded

distclean: reallyclean
	rm -rf $(SRCDIST)
