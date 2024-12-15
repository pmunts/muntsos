# Makefile for building the Python 3 Runtime package for MuntsOS

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

.PHONY: default native cross package.deb upload download_prebuilt clean reallyclean distclean

BOARDNAME	?= UNDEFINED
LIBSIMPLEIO	?= /usr/local/share/libsimpleio
MUNTSOS		?= /usr/local/share/muntsos

include $(MUNTSOS)/include/$(BOARDNAME).mk
include $(LIBSIMPLEIO)/include/dpkg.mk

BUILDOS		:= --build=$(shell uname -m)
TARGETOS	:= --host=$(CONFIGURE_NAME)

MAJORVER	:= 3.13
MINORVER	:= 1

SRCNAME		:= python3
SRCVER		:= $(MAJORVER).$(MINORVER)
SRCDIR		:= Python-$(SRCVER)
SRCTARBALL	:= $(SRCDIR).tgz
SRCURL		:= https://www.python.org/ftp/python/$(SRCVER)/$(SRCTARBALL)
SRCDIST		:= $(TEMP)/muntsos/$(SRCTARBALL)

PKGNAME		:= $(SRCNAME)
PKGVERSION	:= $(SRCVER)-$(shell date +%Y.%j)
PKGARCH		:= $(DEBARCH)
PKGDIR		:= $(PKGNAME)-muntsos-$(BOARDARCH)
PKGFILE		:= $(PKGDIR).deb

NATIVEDIR	:= $(shell pwd)/native.d
NATIVEPYTHON	:= $(NATIVEDIR)/usr/local/bin/python3
NATIVECONFIG	+= --disable-ipv6

CROSSDIR	:= $(shell pwd)/cross-$(BOARDARCH).d
CROSSPYTHON	:= $(CROSSDIR)/usr/local/bin/python3
CROSSCONFIG	+= $(BUILDOS)
CROSSCONFIG	+= $(TARGETOS)
CROSSCONFIG	+= --disable-ipv6
CROSSCONFIG	+= --disable-test-modules
CROSSCONFIG	+= --disable-optimizations
CROSSCONFIG	+= --disable-bolt
CROSSCONFIG	+= --without-lto
CROSSCONFIG	+= --with-build-python=$(NATIVEPYTHON)
CROSSCONFIG	+= --with-ensurepip
CROSSCONFIG	+= AR=$(CROSS_COMPILE)ar
CROSSCONFIG	+= CC=$(CROSS_COMPILE)gcc
CROSSCONFIG	+= CXX=$(CROSS_COMPILE)g++
CROSSCONFIG	+= ac_cv_file__dev_ptc=no
CROSSCONFIG	+= ac_cv_file__dev_ptmx=no

default: package.deb

##############################################################################

# Download the source distribution

$(SRCDIST) :
	mkdir -p $(TEMP)/muntsos
	wget -nv -P $(TEMP)/muntsos $(SRCURL)

download: $(SRCDIST)

##############################################################################

# Compile native python3

$(NATIVEPYTHON) : $(SRCDIST)
	mkdir -p $(NATIVEDIR)
	cd $(NATIVEDIR) && tar xzf $(SRCDIST)
	cd $(NATIVEDIR) && $(SRCDIR)/configure $(NATIVECONFIG)
	cd $(NATIVEDIR) && $(MAKE)
	cd $(NATIVEDIR) && $(MAKE) install DESTDIR=$(NATIVEDIR)
	touch $@

native : $(NATIVEPYTHON)

##############################################################################

# Compile cross python3

$(CROSSPYTHON) : $(NATIVEPYTHON)
	mkdir -p $(CROSSDIR)
	cd $(CROSSDIR) && tar xzf $(SRCDIST)
	cd $(CROSSDIR) && cd $(SRCDIR) && patch -b -p0 <../../python3.patch
	cd $(CROSSDIR) && $(SRCDIR)/configure $(CROSSCONFIG)
	cd $(CROSSDIR) && $(MAKE)
	cd $(CROSSDIR) && $(MAKE) install DESTDIR=$(CROSSDIR)
	# Remove stuff that doesn't belong in a MuntsOS extension package
	rm $(CROSSDIR)/usr/local/bin/idle3*
	rm $(CROSSDIR)/usr/local/bin/pydoc3*
	rm $(CROSSDIR)/usr/local/bin/python3
	rm $(CROSSDIR)/usr/local/bin/python3*config
	rm -rf $(CROSSDIR)/usr/local/include
	rm -rf $(CROSSDIR)/usr/local/lib/*.a
	rm -rf $(CROSSDIR)/usr/local/lib/pkgconfig
	rm -rf $(CROSSDIR)/usr/local/lib/python$(MAJORVER)/config-*
	rm -rf $(CROSSDIR)/usr/local/lib/python$(MAJORVER)/idlelib
	rm -rf $(CROSSDIR)/usr/local/lib/python$(MAJORVER)/lib2to3
	rm -rf $(CROSSDIR)/usr/local/lib/python$(MAJORVER)/sqlite3
	rm -rf $(CROSSDIR)/usr/local/lib/python$(MAJORVER)/tkinter
	rm -rf $(CROSSDIR)/usr/local/lib/python$(MAJORVER)/turtledemo
	rm -rf $(CROSSDIR)/usr/local/lib/python$(MAJORVER)/unittest
	rm -rf $(CROSSDIR)/usr/local/lib/python$(MAJORVER)/lib-dynload/audioop*
	rm -rf $(CROSSDIR)/usr/local/lib/python$(MAJORVER)/lib-dynload/ossaudio*
	rm -rf $(CROSSDIR)/usr/local/share
	mv $(CROSSDIR)/usr/local/bin/python$(MAJORVER) $(CROSSDIR)/usr/local/bin/python3
	$(CROSS_COMPILE)strip $(CROSSDIR)/usr/local/bin/python3
	$(CROSS_COMPILE)strip $(CROSSDIR)/usr/local/lib/python$(MAJORVER)/lib-dynload/*.so
	touch $@

cross : $(CROSSPYTHON)

##############################################################################

# Build the Debian package file

PYLIBDIR	:= /usr/local/lib/python$(MAJORVER)
PYETCDIR	:= /usr/local/etc/python$(MAJORVER)

$(PKGDIR) : $(CROSSPYTHON)
	mkdir -p					$(PKGDIR)/DEBIAN
	install -cm 0644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g		$(PKGDIR)/DEBIAN/control
	install -cm 0755 postinst			$(PKGDIR)/DEBIAN
	sed -i s/@@MAJORVER@@/$(MAJORVER)/g		$(PKGDIR)/DEBIAN/postinst
	mkdir -p					$(PKGDIR)/$(PYETCDIR)/site-packages
	cp -R -P -p $(CROSSDIR)/usr			$(PKGDIR)
	cp -R -P -p $(LIBSIMPLEIO)/python/packages/munts $(PKGDIR)/$(PYLIBDIR)
	rm -rf						$(PKGDIR)/$(PYLIBDIR)/site-packages
	ln -s -f $(PYETCDIR)/site-packages		$(PKGDIR)/$(PYLIBDIR)/site-packages
	find $(PKGDIR) -name __pycache__ -exec rm -rf {} ";" >/dev/null 2>&1 ; true
	install -cm 0755 $(LIBSLIBDIR)/libffi.so.8	$(PKGDIR)/usr/local/lib
	$(CROSS_COMPILE)strip				$(PKGDIR)/usr/local/lib/*.so.*
	touch $@

cross: $(CROSSDIR)

package.deb: $(PKGFILE)

# Upload package to repository

upload: $(PKGFILE)
	scp $^ $(REPOSITORY)

# Download prebuilt package

download_prebuilt: $(PKGFILE).downloaded

$(PKGFILE).downloaded:
	wget -q -nc $(DOWNLOADPREFIX)/extensions/$(PKGFILE)
	touch $(PKGFILE).downloaded

##############################################################################

# Remove working files

clean:
	rm -rf $(PKGDIR)
	if [ ! -f $(PKGFILE).downloaded ]; then rm -f $(PKGFILE) ; fi

reallyclean: clean
	rm -rf $(CROSSDIR) $(PKGFILE) $(PKGFILE).downloaded

distclean: reallyclean
	rm -rf $(NATIVEDIR) $(SRCDIST)
