# Makefile for building the E-MailRelay package for MuntsOS

# Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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
EMBLINUXBASE	?= $(shell pwd)/../..

include $(EMBLINUXBASE)/include/$(BOARDNAME).mk
include $(LIBSIMPLEIO)/include/dpkg.mk

BUILDOS		= --build=`uname -m`
TARGETOS	= --host=$(CONFIGURE_NAME)

SRCNAME		= emailrelay
SRCVER		= 2.1
SRCDIR		= $(SRCNAME)-$(SRCVER)
SRCTARBALL	= $(SRCDIR)a-src.tar.gz
SRCSERVER	= https://sourceforge.net/projects/emailrelay/files/emailrelay/2.1
SRCURL		= $(SRCSERVER)/$(SRCTARBALL)
SRCDIST		= $(TEMP)/$(SRCTARBALL)

OSNAME		= muntsos-$(BOARDNAME)
PKGNAME		= $(SRCNAME)
PKGVERSION	= $(SRCVER)-$(shell date +%Y.%j)
PKGARCH		= $(DEBARCH)
PKGDIR		= $(PKGNAME)-$(OSNAME)
PKGFILE		= $(PKGDIR).deb

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
	cd $(SRCDIR) ; ./configure $(BUILDOS) $(TARGETOS) --disable-ipv6 CXX=$(CROSS_COMPILE)g++
	$(MAKE) -C $(SRCDIR)
	touch $@

# Build the Debian package file

$(PKGDIR): build.done
	mkdir -p						$(PKGDIR)/DEBIAN
	mkdir -p						$(PKGDIR)/etc/rc.d
	mkdir -p						$(PKGDIR)/usr/local/libexec
	install -cm 0644 control				$(PKGDIR)/DEBIAN
	install -cm 0755 postinst				$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g				$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g				$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g			$(PKGDIR)/DEBIAN/control
	install -cm 0755 startup				$(PKGDIR)/etc/rc.d/S50-emailrelay
	install -cm 0755 $(SRCDIR)/src/main/emailrelay		$(PKGDIR)/usr/local/libexec
	$(CROSS_COMPILE)strip					$(PKGDIR)/usr/local/libexec/*
	touch $@

package.deb: $(PKGFILE)

# Download prebuilt package

download_prebuilt: $(PKGFILE).downloaded

$(PKGFILE).downloaded:
	wget -q -nc $(DOWNLOADPREFIX)/extensions/$(PKGFILE)
	touch $(PKGFILE).downloaded

# Remove working files

clean:
	-$(MAKE) -C $(SRCDIR) distclean
	rm -rf build.done $(PKGDIR)
	if [ ! -f $(PKGFILE).downloaded ]; then rm -f $(PKGFILE) ; fi

reallyclean: clean
	rm -rf src.done $(SRCDIR) $(PKGFILE) $(PKGFILE).downloaded

distclean: reallyclean
	rm -rf $(SRCDIST)
