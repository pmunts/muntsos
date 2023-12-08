# Makefile for packaging Free Pascal ARM cross-toolchain for MuntsOS

# Copyright (C)2017-2022, Philip Munts, President, Munts AM Corp.
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

MUNTSOS		?= ../..

include $(MUNTSOS)/include/$(BOARDNAME).mk

FPC_VERSION	= 3.2.2
FPC_SRCDIR	= fpc-$(FPC_VERSION)
FPC_TARBALL	= fpc-$(FPC_VERSION).source.tar.gz
FPC_SERVER	= https://downloads.sourceforge.net/project/freepascal/Source/$(FPC_VERSION)
FPC_URL		= $(FPC_SERVER)/$(FPC_TARBALL)
FPC_DIST	= $(TEMP)/$(FPC_TARBALL)

BUILDOPTS	= CPU_TARGET=$(ARCH) OS_TARGET=linux
BUILDOPTS	+= BINUTILSPREFIX=$(CONFIGURE_NAME)-
BUILDOPTS	+= CROSSBINDIR=$(TOOLCHAIN_DIR)/bin
ifeq ($(BOARDBASE), BeagleBone)
CPUOPTS		= -CaEABIHF -CpARMV7A -CfVFPV3
BUILDOPTS	+= OPT=-dFPC_ARMHF CROSSOPT="$(CPUOPTS)"
endif
ifeq ($(BOARDBASE), RaspberryPi)
CPUOPTS		= -CaEABIHF -CpARMV6 -CfVFPV2
BUILDOPTS	+= OPT=-dFPC_ARMHF CROSSOPT="$(CPUOPTS)"
endif
ifeq ($(BOARDBASE), RaspberryPi2)
CPUOPTS		= -CaEABIHF -CpARMV7A -CfVFPV3
BUILDOPTS	+= OPT=-dFPC_ARMHF CROSSOPT="$(CPUOPTS)"
endif
ifeq ($(BOARDBASE), RaspberryPi3)
ARCH		= aarch64
CPUOPTS		= -CpARMV8
BUILDOPTS	+= OPT=-dFPC_AARCH64 CROSSOPT="$(CPUOPTS)"
endif

BUILDNUM	?= 1
OSNAME		?= unknown
PKGNAME		:= fpc-$(TOOLCHAIN_NAME)
PKGVER		:= $(FPC_VERSION)-$(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		:= $(shell dpkg --print-architecture)
PKGSUFFIX	:= $(PKGVER)-$(OSNAME)-$(PKGARCH)
PKGDIR		:= $(PKGNAME)-$(PKGSUFFIX)
PKGFILE		:= $(PKGNAME)-$(PKGSUFFIX).deb

INSTALLDIR	:= $(shell pwd)/$(PKGDIR)/usr/local/$(PKGNAME)

default: package.deb

################################################################################

# Download the source distribution

$(FPC_DIST):
	wget -nv -O $@ $(FPC_URL)

################################################################################

# Unpack the source distribution

src.done: $(FPC_DIST)
	tar xzf $^
	cd $(FPC_SRCDIR) && patch -b -p1 <../freepascal.patch
	touch $@

################################################################################

# Build the cross compiler and libraries

build.done: src.done
	$(MAKE) -C $(FPC_SRCDIR) crossall $(BUILDOPTS)
	# Work around a bug in the Free Pascall build procedure
	-cp $(FPC_SRCDIR)/compiler/ppcarm $(FPC_SRCDIR)/compiler/ppcrossarm
	-cp $(FPC_SRCDIR)/compiler/ppca64 $(FPC_SRCDIR)/compiler/ppcrossa64
	touch $@

################################################################################

# Install the cross compiler and libraries

install.done: build.done
	$(MAKE) -C $(FPC_SRCDIR) crossinstall $(BUILDOPTS) INSTALL_PREFIX=$(INSTALLDIR)
ifeq ($(BOARDNAME), RaspberryPi3)
	ln -s ../lib/fpc/$(FPC_VERSION)/ppcrossa64	$(INSTALLDIR)/bin/fpc
else
	ln -s ../lib/fpc/$(FPC_VERSION)/ppcross$(ARCH)	$(INSTALLDIR)/bin/fpc
endif
	mkdir -p					$(INSTALLDIR)/etc
	install -cm 0644 fpc.cfg			$(INSTALLDIR)/etc
	sed -i s#@@ARCH@@#$(ARCH)#g			$(INSTALLDIR)/etc/fpc.cfg
	sed -i s#@@CROSSCOMPILE@@#$(CROSS_COMPILE)#g	$(INSTALLDIR)/etc/fpc.cfg
	sed -i s#@@INSTALLDIR@@#/usr/local/$(PKGNAME)#g	$(INSTALLDIR)/etc/fpc.cfg
	sed -i s#@@STARTUPDIR@@#$(shell dirname $(shell find $(TOOLCHAIN_DIR) -name crtbegin.o))#g $(INSTALLDIR)/etc/fpc.cfg
	sed -i s#@@SYSROOT@@#$(GCCSYSROOT)#g		$(INSTALLDIR)/etc/fpc.cfg
	sed -i s#@@VERSION@@#$(FPC_VERSION)#g		$(INSTALLDIR)/etc/fpc.cfg
	for c in $(CPUOPTS) ; do echo $$c >>		$(INSTALLDIR)/etc/fpc.cfg ; done
	ln -s ../../etc					$(INSTALLDIR)/lib/fpc/etc
	touch $@

################################################################################

# Create Debian package

package.deb: install.done
	mkdir -p					$(PKGDIR)/DEBIAN
	install -cm 0644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@BOARDNAME@@/$(BOARDBASE)/g		$(PKGDIR)/DEBIAN/control
	chmod -R ugo-w					$(PKGDIR)/usr/local/*
	fakeroot dpkg-deb --build			$(PKGDIR)
	chmod -R ugo+w					$(PKGDIR)

################################################################################

# Remove working files

clean:
	rm -rf install.done $(PKGDIR) $(PKGFILE)

reallyclean: clean
	rm -rf build.done src.done $(FPC_SRCDIR)

distclean: reallyclean
	-rm $(FPC_DIST)
