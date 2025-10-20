# Makefile for building and packaging a crosstool-NG cross-toolchain

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

# Note: Set CT_EXTRA_CFLAGS_FOR_HOST="-mcpu=cortex-a7 -mfpu=neon-vfpv4" in
# each target configuration file when building for 32-bit Raspberry Pi OS.

MUNTSOS    ?= ../..

TOOLCHAIN_BUILDER := crosstool

include $(MUNTSOS)/include/$(BOARDNAME).mk

CTNG		?= ct-ng

GCCVER		:= $(shell awk -F '"' '/CT_GCC_VERSION=/ { print $$2 }' .config)
INSTALLDIR	:= gcc-$(CONFIGURE_NAME)

BUILDNUM	?= 1
PKGNAME		:= gcc-$(TOOLCHAIN_NAME)
PKGVER		:= $(GCCVER)-$(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		:= $(shell dpkg --print-architecture)
PKGSUFFIX	:= $(PKGVER)-$(PKGARCH)
PKGDIR		:= $(PKGNAME)-$(PKGSUFFIX)
PKGFILE		:= $(PKGNAME)-$(PKGSUFFIX).deb

GPRBUILDVER	:= 25.0.1
ifeq ($(PKGARCH), amd64)
GPRBUILDDIST	:= $(HOME)/.local/share/alire/toolchains/gprbuild_25.0.1_9a2e6cfb
endif
ifeq ($(PKGARCH), arm64)
GPRBUILDDIST	:= $(HOME)/.local/share/alire/toolchains/gprbuild_25.0.1_5e58c08e
endif
GPRBUILDDIR	:= libexec/gprbuild-alire$(GPRBUILDVER)
GPRBUILDDEST	:= $(PKGDIR)$(TOOLCHAIN_DIR)/$(GPRBUILDDIR)

default: package.deb

################################################################################

# Prepare the system for building a Crosstool-NG toolchain

prepare:
	sudo apt -y install autoconf bison build-essential curl flex gcc-14 g++-14 gm2-14 gnat-14 m4 zlib1g-dev

################################################################################

# Configure the cross-toolchain

config.done:
	DEFCONFIG=$(BOARDNAME).config ct-ng defconfig
	$(CTNG) oldconfig
	DEFCONFIG=$(BOARDNAME).config ct-ng savedefconfig
	touch $@

menuconfig:
	DEFCONFIG=$(BOARDNAME).config ct-ng defconfig
	$(CTNG) menuconfig
	$(CTNG) oldconfig
	DEFCONFIG=$(BOARDNAME).config ct-ng savedefconfig
	touch config.done

upgradeconfig:
	DEFCONFIG=$(BOARDNAME).config ct-ng defconfig
	$(CTNG) upgradeconfig
	$(CTNG) oldconfig
	DEFCONFIG=$(BOARDNAME).config ct-ng savedefconfig
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
	$(CTNG) build
	rm $(INSTALLDIR)/build.log.bz2
	# Rearrange sysroot directory tree
	rsync -avc $(INSTALLDIR)/$(CONFIGURE_NAME)/debug-root/usr/ $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr
	rsync -avc $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/etc/       $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/etc
	rsync -avc $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/sbin/      $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/bin
	rsync -avc $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/sbin/  $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/bin
	rm -rf $(INSTALLDIR)/$(CONFIGURE_NAME)/debug-root
	rm -rf $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/etc
	rm -rf $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/sbin
	rm -rf $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/sbin
	rm -rf $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/var
	ln -s ../../../lib/gcc/$(CONFIGURE_NAME)/$(GCCVER)/adalib/libgnat.so  $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/lib/libgnat.so
	ln -s ../../../lib/gcc/$(CONFIGURE_NAME)/$(GCCVER)/adalib/libgnarl.so $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/lib/libgnarl.so
	cd $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/lib && for F in ../../lib/* ; do ln -s -f $$F ; done
	touch $@

################################################################################

# Reconstitute previous build from installed files

reconstitute:
	sudo apt purge 'gcc-$(GCCARCH)-muntsos*lib*'
	cp -R -P -p $(TOOLCHAIN_DIR) $(INSTALLDIR)
	chmod -R u+w $(INSTALLDIR)
	rm -rf $(INSTALLDIR)/bin/gpr* $(INSTALLDIR)/libexec/gprbuild* $(INSTALLDIR)/share/gpr
	touch build.done

################################################################################

# Create Debian package

package.deb: build.done
	mkdir -p					$(PKGDIR)/DEBIAN
	install -cm 0644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@BOARDNAME@@/$(BOARDNAME)/g		$(PKGDIR)/DEBIAN/control
	mkdir -p					$(PKGDIR)/usr/local
	cp -R -P -p gcc-$(CONFIGURE_NAME)		$(PKGDIR)$(TOOLCHAIN_DIR)
	mkdir -p					$(GPRBUILDDEST)
	cp -R -P -p $(GPRBUILDDIST)/*			$(GPRBUILDDEST)
	rm -rf						$(GPRBUILDDEST)/alire*
	rm -rf						$(GPRBUILDDEST)/doinstall
	rm -rf						$(GPRBUILDDEST)/share
	cd $(GPRBUILDDEST)/bin && for P in * ; do ln -s ../$(GPRBUILDDIR)/bin/$$P ../../../bin/$$P ; done
	mkdir -p					$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's:@@GPRBUILD_DIR@@:$(GPRBUILDDIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@TARGET_NAME@@/$(CONFIGURE_NAME)/g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@TOOLCHAIN_VERN@@/$(GCCVER)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@TOOLCHAIN_VERS@@/$(shell $(INSTALLDIR)/bin/$(CONFIGURE_NAME)-gcc --version | head -n 1)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	chmod -R ugo-w					$(PKGDIR)/usr
	fakeroot dpkg-deb -Zxz --build			$(PKGDIR)
	chmod -R u+w					$(PKGDIR)/usr

################################################################################

# Remove working files

clean:
	-chmod -R u+w $(PKGDIR)
	rm -rf $(PKGDIR) $(PKGFILE)

reallyclean: clean
	-chmod -R u+w gcc*
	rm -rf .config* build* config* *.done gcc* include

distclean: reallyclean
	rm -rf distfiles
