# Makefile for building the gnuplot package for MuntsOS

# Copyright (C)2024, Philip Munts dba Munts Technologies.
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

SRCNAME		= gnuplot
SRCVER		= 6.0.0
SRCDIR		= $(SRCNAME)-$(SRCVER)
SRCTARBALL	= $(SRCDIR).tar.gz
SRCSERVER	= https://sourceforge.net/projects/gnuplot/files/gnuplot/$(SRCVER)
SRCURL		= $(SRCSERVER)/$(SRCTARBALL)
SRCDIST		= $(TEMP)/$(SRCTARBALL)

CONFIGFLAGS	+= --build=`uname -m`
CONFIGFLAGS	+= --host=$(CONFIGURE_NAME)
CONFIGFLAGS	+= --with-qt=no
CONFIGFLAGS	+= --without-aquaterm
CONFIGFLAGS	+= --without-bitmap-terminals
CONFIGFLAGS	+= --without-cairo
CONFIGFLAGS	+= --without-gpic
CONFIGFLAGS	+= --without-latex
CONFIGFLAGS	+= --without-lua
CONFIGFLAGS	+= --without-metafont
CONFIGFLAGS	+= --without-metapost
CONFIGFLAGS	+= --without-readline
CONFIGFLAGS	+= --without-regis
CONFIGFLAGS	+= --without-tektronix
CONFIGFLAGS	+= --without-tgif
CONFIGFLAGS	+= --without-x
CONFIGFLAGS	+= CC=$(CROSS_COMPILE)gcc
CONFIGFLAGS	+= CXX=$(CROSS_COMPILE)g++

PKGNAME		= $(SRCNAME)
PKGVERSION	= $(SRCVER)-$(shell date +%Y.%j)
PKGARCH		= $(DEBARCH)
PKGDIR		= $(PKGNAME)-muntsos-$(BOARDARCH)
PKGFILE		= $(PKGDIR).deb

GNUPLOTRC	= $(PKGDIR)/usr/local/share/gnuplot/6.0/gnuplotrc

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
	$(MAKE) -C $(SRCDIR)/docs CC=gcc
	$(MAKE) -C $(SRCDIR)/src bf_test CC=gcc
	$(MAKE) -C $(SRCDIR)
	touch $@

# Build the Debian package file

$(PKGDIR): build.done
	$(MAKE) -C $(SRCDIR) install DESTDIR=$(shell pwd)/$(PKGDIR)
	mkdir -p				$(PKGDIR)/DEBIAN
	install -cm 0644 control		$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g	$(PKGDIR)/DEBIAN/control
	install -cm 0755 postinst		$(PKGDIR)/DEBIAN
	mv $(GNUPLOTRC) $(GNUPLOTRC).default
	ln -s /usr/local/etc/gnuplotrc		$(GNUPLOTRC)
	# Remove unwanted stuff
	rm -rf					$(PKGDIR)/usr/local/libexec
	rm -rf					$(PKGDIR)/usr/local/share/gnuplot/6.0/js
	rm -rf					$(PKGDIR)/usr/local/share/gnuplot/6.0/lua
	rm -rf					$(PKGDIR)/usr/local/share/man
	$(CROSS_COMPILE)strip			$(PKGDIR)/usr/local/bin/*
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
	-$(MAKE) -C $(SRCDIR) distclean
	rm -rf build.done $(PKGDIR)
	if [ ! -f $(PKGFILE).downloaded ]; then rm -f $(PKGFILE) ; fi

reallyclean: clean
	rm -rf src.done $(SRCDIR) $(PKGFILE) $(PKGFILE).downloaded

distclean: reallyclean
	rm -rf $(SRCDIST)
