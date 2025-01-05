# Makefile for building the expect package for MuntsOS

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

BUILDOS		= --build=`uname -m`
TARGETOS	= --host=$(CONFIGURE_NAME)

SRCNAME		= expect
SRCVER		= 5.45.4
SRCDIR		= $(SRCNAME)$(SRCVER)
SRCTARBALL	= $(SRCDIR).tar.gz
SRCSERVER	= https://sourceforge.net/projects/expect/files/Expect/5.45.4
SRCURL		= $(SRCSERVER)/$(SRCTARBALL)
SRCDIST		= $(TEMP)/$(SRCTARBALL)

TCLDIR		= $(shell pwd)/tcl

PKGNAME		= $(SRCNAME)
PKGVERSION	= $(SRCVER)-$(shell date +%Y.%j)
PKGARCH		= $(DEBARCH)
PKGDIR		= $(PKGNAME)-muntsos-$(BOARDARCH)
PKGFILE		= $(PKGDIR).deb

default: package.deb

# Download the source distribution

$(SRCDIST):
	wget -nv -P $(TEMP) $(SRCURL)

# Unpack the source distribution

src.done: $(SRCDIST)
	tar xzf $^
	cd $(SRCDIR) && patch -b -p0 <../expect.patch
	mv $(SRCDIR) src
	touch $@

# Build Tcl

tcl.done:
	$(MAKE) -C ../tclsh build.done
	$(MAKE) -C ../tclsh/src/unix install DESTDIR=$(TCLDIR)
	touch $@

# Compile sources

build.done: src.done tcl.done
	cd src ; ./configure $(BUILDOS) $(TARGETOS) CC=$(CROSS_COMPILE)gcc LDFLAGS=-L$(TCLDIR)/usr/local/lib --with-tcl=$(TCLDIR)/usr/local/lib
	$(MAKE) -C src
	touch $@

# Build the Debian package file

$(PKGDIR): build.done
	mkdir -p				$@/DEBIAN
	install -cm 0644 control		$@/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$@/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$@/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g	$@/DEBIAN/control
	mkdir -p				$@/usr/local/bin
	install -cm 755 src/expect		$@/usr/local/bin
	mkdir -p				$@/usr/local/lib
	install -cm 755 src/*.so		$@/usr/local/lib
	$(CROSS_COMPILE)strip			$@/usr/local/*/*
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
	rm -rf build.done src.done tcl.done src tcl $(SRCDIR) $(PKGFILE) $(PKGFILE).downloaded
	$(MAKE) -C ../tclsh reallyclean

distclean: reallyclean
	rm -f $(SRCDIST)
