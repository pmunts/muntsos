# Makefile for building crosstool-ng package for Debian

# Copyright (C)2017-2025, Philip Munts dba Munts Technologies.
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

CTNG_VERSION	?= 1.28.0
CTNG_BRANCH	:= -b crosstool-ng-$(CTNG_VERSION)
CTNG_URL	:= https://github.com/crosstool-ng/crosstool-ng.git
CTNG_SRC	:= crosstool-ng.src

DEPENDENCIES	+= autoconf
DEPENDENCIES	+= automake
DEPENDENCIES	+= bison
DEPENDENCIES	+= build-essential
DEPENDENCIES	+= curl
DEPENDENCIES	+= flex
DEPENDENCIES	+= gawk
DEPENDENCIES	+= git
DEPENDENCIES	+= help2man
DEPENDENCIES	+= libncurses5-dev
DEPENDENCIES	+= libtool-bin
DEPENDENCIES	+= texinfo
DEPENDENCIES	+= zip
DEPENDENCIES	+= zlib1g-dev

OSNAME		?= unknown
PKGNAME		:= crosstool-ng
PKGVERSION	:= $(CTNG_VERSION)
PKGARCH		:= $(shell dpkg --print-architecture)
PKGDIR		:= $(PKGNAME)-$(PKGVERSION)-$(OSNAME)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb

default: $(PKGFILE)

# Install dependencies

apt.done:
	sudo apt -y install $(DEPENDENCIES)
	touch $@
# Clone source distribution

src.done:
	git clone --depth 1 $(CTNG_BRANCH) $(CTNG_URL) $(CTNG_SRC)
	touch $@

# Build crosstool-ng

build.done: apt.done src.done
	cd $(CTNG_SRC) && ./bootstrap
	cd $(CTNG_SRC) && ./configure
	$(MAKE) -C $(CTNG_SRC) MAKELEVEL=0
	touch $@

# Build Debian package file

$(PKGFILE): $(PKGDIR)
	chmod -R ugo-w $(PKGDIR)/usr
	fakeroot dpkg-deb --build $(PKGDIR)
	chmod -R u+w $(PKGDIR)/usr

$(PKGDIR): build.done
	mkdir -p $(PKGDIR)/DEBIAN
	install -cm 0444 control			$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g		$(PKGDIR)/DEBIAN/control
	$(MAKE) -C $(CTNG_SRC) install DESTDIR=$(shell pwd)/$(PKGDIR) MAKELEVEL=0

# Remove working files

clean:
	-rm -rf $(PKGFILE) $(PKGDIR)

reallyclean: clean
	-rm -rf *.done $(CTNG_SRC)

distclean: reallyclean
