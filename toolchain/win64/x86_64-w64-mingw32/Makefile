# Makefile for building and packaging a crosstool-NG cross-toolchain targeting
# mingw64 (64-bit Windows)

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

CTNG		?= ct-ng

TUPLE		:= x86_64-w64-mingw32
INSTALLDIR	:= gcc-$(TUPLE)

default: build.done

################################################################################

# Configure the cross-toolchain

config.done:
	DEFCONFIG=$(TUPLE).config ct-ng defconfig
	$(CTNG) oldconfig
	DEFCONFIG=$(TUPLE).config ct-ng savedefconfig
	touch $@

menuconfig:
	DEFCONFIG=$(TUPLE).config ct-ng defconfig
	$(CTNG) menuconfig
	$(CTNG) oldconfig
	DEFCONFIG=$(TUPLE).config ct-ng savedefconfig
	touch config.done

upgradeconfig:
	DEFCONFIG=$(TUPLE).config ct-ng defconfig
	$(CTNG) upgradeconfig
	$(CTNG) oldconfig
	DEFCONFIG=$(TUPLE).config ct-ng savedefconfig
	touch config.done

################################################################################

# Download source distributions

source.done: config.done
	mkdir -p distfiles
	$(CTNG) source
	rm -f wget-log*
	touch $@

################################################################################

# Build the cross-toolchain

build.done: source.done
	echo "Building $(INSTALLDIR)"
	$(CTNG) build
	touch $@

################################################################################

# Create optional Debian package

BUILDNUM	?= 1
GCCVER		= $(shell awk -F '"' '/CT_GCC_VERSION=/ { print $$2 }' .config)
PKGNAME		= gcc-$(shell echo $(TUPLE) | sed 's/_/-/g')
PKGVER		= $(GCCVER)-$(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		= $(shell dpkg --print-architecture)
PKGSUFFIX	= $(PKGVER)-$(PKGARCH)
PKGDIR		= $(PKGNAME)-$(PKGSUFFIX)
PKGFILE		= $(PKGNAME)-$(PKGSUFFIX).deb
TOOLCHAINDIR	= /usr/local/$(PKGNAME)

package.done : build.done
	mkdir -p				$(PKGDIR)/DEBIAN
	install -cm 0644 control		$(PKGDIR)/DEBIAN
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g	$(PKGDIR)/DEBIAN/control
	mkdir -p				$(PKGDIR)$(TOOLCHAINDIR)
	cp -R -P -p $(INSTALLDIR)/*		$(PKGDIR)$(TOOLCHAINDIR)
	rm					$(PKGDIR)$(TOOLCHAINDIR)/build.log.bz2
	chmod -R ugo-w				$(PKGDIR)/usr
	fakeroot dpkg-deb -Zxz --build		$(PKGDIR)
	chmod -R u+w				$(PKGDIR)/usr
	touch $@

################################################################################

# Remove working files

clean:
	-chmod -R u+w $(PKGDIR)
	rm -rf package.done $(PKGDIR) $(PKGFILE)

reallyclean: clean
	-chmod -R u+w gcc*
	rm -rf .build .config* build* config* *.done gcc* include

distclean: reallyclean
	rm -rf distfiles
