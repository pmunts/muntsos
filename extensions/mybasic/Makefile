# Makefile for building the MY-BASIC package for MuntsOS
# including bindings for libsimpleio

# Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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

LIBSIMPLEIO	?= $(GCCSYSROOT)/usr/share/libsimpleio

SRCURL		= https://github.com/paladin-t/my_basic.git
SRCDIR		= my_basic

OSNAME		= muntsos-$(BOARDNAME)
PKGNAME		= mybasic
PKGVERSION	= $(shell date +%Y.%j)
PKGARCH		= $(DEBARCH)
PKGDIR		= $(PKGNAME)-$(OSNAME)
PKGFILE		= $(PKGDIR).deb

SOURCEFILES	+= $(SRCDIR)/core/my_basic.c
SOURCEFILES	+= $(SRCDIR)/shell/main.c
SOURCEFILES	+= $(LIBSIMPLEIO)/basic/bindings/libsimpleio.c

CFLAGS		+= -Wall
CFLAGS		+= -I$(SRCDIR)/core
LDFLAGS		+= -lm -lsimpleio

default: package.deb

# Clone source repo

src.done:
	git clone $(SRCURL)
	patch -b -p0 <$(LIBSIMPLEIO)/basic/bindings/libsimpleio.patch
	touch $@

# Compile sources

build.done: src.done
	$(CROSS_COMPILE)gcc $(CFLAGS) -o basic $(SOURCEFILES) $(LDFLAGS)
	$(CROSS_COMPILE)strip basic
	touch $@

# Build the Debian package file

$(PKGDIR): build.done
	mkdir -p				$(PKGDIR)/DEBIAN
	install -cm 0644 control		$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g	$(PKGDIR)/DEBIAN/control
	mkdir -p				$(PKGDIR)/usr/local/bin
	install -cm 0755 basic			$(PKGDIR)/usr/local/bin
	touch $@

package.deb: $(PKGFILE)

# Download prebuilt package

download_prebuilt: $(PKGFILE).downloaded

$(PKGFILE).downloaded:
	wget -q -nc $(DOWNLOADPREFIX)/extensions/$(PKGFILE)
	touch $(PKGFILE).downloaded

# Remove working files

clean:
	rm -rf build.done basic $(PKGDIR)
	if [ ! -f $(PKGFILE).downloaded ]; then rm -f $(PKGFILE) ; fi

reallyclean: clean
	rm -rf src.done $(SRCDIR) $(PKGFILE) $(PKGFILE).downloaded

distclean: reallyclean
