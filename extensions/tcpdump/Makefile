# Makefile for building the tcpdump package for MuntsOS

# Copyright (C)2016-2021, Philip Munts, President, Munts AM Corp.
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
MUNTSOS		?= $(shell pwd)/../..

include $(MUNTSOS)/include/$(BOARDNAME).mk
include $(LIBSIMPLEIO)/include/dpkg.mk

BUILDOS		= --build=`uname -m`
TARGETOS	= --host=$(CONFIGURE_NAME)

SRCNAME		= tcpdump
SRCVER		= 4.99.1
SRCDIR		= $(SRCNAME)-$(SRCVER)
SRCTARBALL	= $(SRCDIR).tar.gz
SRCSERVER	= http://www.tcpdump.org/release
SRCURL		= $(SRCSERVER)/$(SRCTARBALL)
SRCDIST		= $(TEMP)/$(SRCTARBALL)

OSNAME		= muntsos-$(BOARDBASE)
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
	cd $(SRCDIR) ; ./configure $(BUILDOS) $(TARGETOS) --without-smi --with-system-libpcap CC=$(CROSS_COMPILE)gcc
	$(MAKE) -C $(SRCDIR)
	touch $@

# Build the Debian package file

$(PKGDIR): build.done
	mkdir -p						$(PKGDIR)/DEBIAN
	mkdir -p						$(PKGDIR)/usr/local/bin
	mkdir -p						$(PKGDIR)/usr/local/lib
	install -cm 0644 control				$(PKGDIR)/DEBIAN
	install -cm 0755 postinst				$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g				$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g				$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g			$(PKGDIR)/DEBIAN/control
	install -cm 0755 $(SRCDIR)/tcpdump			$(PKGDIR)/usr/local/bin
	install -cm 0755 $(GCCSYSROOT)/usr/lib/libpcap.so.1	$(PKGDIR)/usr/local/lib
	$(CROSS_COMPILE)strip					$(PKGDIR)/usr/local/bin/*
	$(CROSS_COMPILE)strip					$(PKGDIR)/usr/local/lib/*
	find $(PKGDIR) -type f -name '*.py' -exec chmod 0644 {} ";"
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
