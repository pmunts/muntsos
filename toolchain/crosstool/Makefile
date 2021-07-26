# Makefile for building and packaging a Crosstool-NG cross-toolchain

# Copyright (C)2017-2021, Philip Munts, President, Munts AM Corp.
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

# Note: Set CT_EXTRA_CFLAGS_FOR_HOST="-mcpu=cortex-a7 -mfpu=neon-vfpv4" in
# each target configuration file when building for 32-bit Raspberry Pi OS.

MUNTSOS    ?= ../..

include $(MUNTSOS)/include/$(BOARDNAME).mk

CTNG		?= ct-ng

OSNAME		?= unknown
PKGNAME		:= gcc-$(TOOLCHAIN_NAME)
PKGVER		:= $(shell date +%Y.%j)
PKGARCH		:= $(shell dpkg --print-architecture)
PKGSUFFIX	:= $(PKGVER)-$(OSNAME)-$(PKGARCH)
PKGDIR		:= $(PKGNAME)-$(PKGSUFFIX)
PKGFILE		:= $(PKGNAME)-$(PKGSUFFIX).deb

GCCVER		:= $(shell awk -F '"' '/CT_GCC_VERSION=/ { print $$2 }' $(BOARDNAME).config)
GCCMAJOR	:= $(shell echo $(GCCVER) | head -c 1)

default: package.deb

################################################################################

# Configure the cross-toolchain

config.done:
	cp $(BOARDBASE).config .config
	$(CTNG) oldconfig
	cp .config $(BOARDBASE).config
	touch $@

menuconfig:
	cp $(BOARDBASE).config .config
	$(CTNG) menuconfig
	$(CTNG) oldconfig
	cp .config $(BOARDBASE).config
	touch config.done

################################################################################

# Download source distributions

source.done: config.done
	mkdir -p distfiles
	$(CTNG) source
	touch $@

################################################################################

# Build the cross-toolchain

build.done: source.done
	$(CTNG) build
	touch $@

################################################################################

# Reconstitute previous build from installed files

reconstitute:
	cp -R -P -p $(TOOLCHAIN_DIR) gcc-$(CONFIGURE_NAME)
	chmod -R u+w gcc-$(CONFIGURE_NAME)
	rm -f gcc-$(CONFIGURE_NAME)/$(CONFIGURE_NAME)/lib/libgnat.so
	rm -f gcc-$(CONFIGURE_NAME)/share/gpr/$(BOARDBASE).cgpr
	touch gcc-$(CONFIGURE_NAME)/build.log.bz2
	touch build.done

################################################################################

# Create Debian package

package.deb: build.done
	mkdir -p					$(PKGDIR)/DEBIAN
	install -cm 0644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@BOARDNAME@@/$(BOARDBASE)/g		$(PKGDIR)/DEBIAN/control
	mkdir -p					$(PKGDIR)/usr/local
	cp -R -P -p gcc-$(CONFIGURE_NAME)		$(PKGDIR)$(TOOLCHAIN_DIR)
	ln -s ../../lib/gcc/$(CONFIGURE_NAME)/$(GCCVER)/adalib/libgnat.so $(PKGDIR)$(GCCLIBDIR)/libgnat.so
	rm						$(PKGDIR)$(TOOLCHAIN_DIR)/build.log.bz2
	mkdir -p					$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@GCCVER@@/$(GCCVER)/g' 		$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@GCCMAJOR@@/$(GCCMAJOR)/g' 		$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	ln -s $(CONFIGURE_NAME).cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(BOARDBASE).cgpr
	chmod -R ugo-w					$(PKGDIR)/usr
	fakeroot dpkg-deb --build			$(PKGDIR)
	chmod -R u+w					$(PKGDIR)/usr

################################################################################

# Remove working files

clean:
	rm -rf $(PKGDIR) $(PKGFILE)

reallyclean: clean
	-chmod -R u+w gcc-$(CONFIGURE_NAME)
	rm -rf .build .config* build* config* *.done gcc-$(CONFIGURE_NAME)

distclean: reallyclean
	rm -rf distfiles
