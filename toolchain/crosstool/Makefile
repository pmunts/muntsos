# Makefile for building and packaging a crosstool-NG cross-toolchain

# Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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

GCCVER		:= $(shell awk -F '"' '/CT_GCC_VERSION=/ { print $$2 }' $(BOARDNAME).config)
GCCMAJOR	:= $(shell echo $(GCCVER) | head -c 2)
INSTALLDIR	:= gcc-$(CONFIGURE_NAME)

BUILDNUM	?= 1
PKGNAME		:= gcc-$(TOOLCHAIN_NAME)
PKGVER		:= $(GCCVER)-$(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		:= $(shell dpkg --print-architecture)
PKGSUFFIX	:= $(PKGVER)-$(PKGARCH)
PKGDIR		:= $(PKGNAME)-$(PKGSUFFIX)
PKGFILE		:= $(PKGNAME)-$(PKGSUFFIX).deb

default: package.deb

################################################################################

# Prepare the system for building a Crosstool-NG toolchain

prepare:
	@echo "GCCVER   => $(GCCVER)"
	@echo "GCCMAJOR => $(GCCMAJOR)"
	sudo apt -y install autoconf bison build-essential curl flex gcc-13 g++-13 gm2-13  gnat-13 m4 zlib1g-dev

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

upgradeconfig:
	cp $(BOARDBASE).config .config
	$(CTNG) upgradeconfig
	cp .config $(BOARDBASE).config
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
	cp -R -P -p $(TOOLCHAIN_DIR) $(INSTALLDIR)
	chmod -R u+w $(INSTALLDIR)
	rm -rf $(INSTALLDIR)/share/gpr
	touch build.done

################################################################################

# Create Debian package

package.deb: build.done
	mkdir -p					$(PKGDIR)/DEBIAN
	install -cm 0644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@BOARDNAME@@/$(BOARDBASELC)/g		$(PKGDIR)/DEBIAN/control
	mkdir -p					$(PKGDIR)/usr/local
	cp -R -P -p gcc-$(CONFIGURE_NAME)		$(PKGDIR)$(TOOLCHAIN_DIR)
	mkdir -p					$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@TARGET_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@TOOLCHAIN_VERN@@/$(TOOLCHAIN_VERN)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@TOOLCHAIN_VERS@@/$(TOOLCHAIN_VERS)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(BOARDNAME).cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(BOARDNAME).cgpr
	sed -i 's/@@TARGET_NAME@@/$(BOARDNAME)/g'	 $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(BOARDNAME).cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(BOARDNAME).cgpr
	sed -i 's/@@TOOLCHAIN_VERN@@/$(TOOLCHAIN_VERN)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(BOARDNAME).cgpr
	sed -i 's/@@TOOLCHAIN_VERS@@/$(TOOLCHAIN_VERS)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(BOARDNAME).cgpr
ifeq ($(BOARDNAME), BeagleBone)
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/PocketBeagle.cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/PocketBeagle.cgpr
	sed -i 's/@@TARGET_NAME@@/PocketBeagle/g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/PocketBeagle.cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/PocketBeagle.cgpr
	sed -i 's/@@TOOLCHAIN_VERN@@/$(TOOLCHAIN_VERN)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/PocketBeagle.cgpr
	sed -i 's/@@TOOLCHAIN_VERS@@/$(TOOLCHAIN_VERS)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/PocketBeagle.cgpr
endif
ifeq ($(BOARDNAME), RaspberryPi3)
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/OrangePiZero2W.cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/OrangePiZero2W.cgpr
	sed -i 's/@@TARGET_NAME@@/OrangePiZero2W/g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/OrangePiZero2W.cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/OrangePiZero2W.cgpr
	sed -i 's/@@TOOLCHAIN_VERN@@/$(TOOLCHAIN_VERN)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/OrangePiZero2W.cgpr
	sed -i 's/@@TOOLCHAIN_VERS@@/$(TOOLCHAIN_VERS)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/OrangePiZero2W.cgpr
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi4.cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi4.cgpr
	sed -i 's/@@TARGET_NAME@@/RaspberryPi4/g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi4.cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi4.cgpr
	sed -i 's/@@TOOLCHAIN_VERN@@/$(TOOLCHAIN_VERN)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi4.cgpr
	sed -i 's/@@TOOLCHAIN_VERS@@/$(TOOLCHAIN_VERS)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi4.cgpr
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi5.cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi5.cgpr
	sed -i 's/@@TARGET_NAME@@/RaspberryPi5/g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi5.cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi5.cgpr
	sed -i 's/@@TOOLCHAIN_VERN@@/$(TOOLCHAIN_VERN)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi5.cgpr
	sed -i 's/@@TOOLCHAIN_VERS@@/$(TOOLCHAIN_VERS)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi5.cgpr
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPiZero2W.cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPiZero2W.cgpr
	sed -i 's/@@TARGET_NAME@@/RaspberryPiZero2W/g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPiZero2W.cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPiZero2W.cgpr
	sed -i 's/@@TOOLCHAIN_VERN@@/$(TOOLCHAIN_VERN)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPiZero2W.cgpr
	sed -i 's/@@TOOLCHAIN_VERS@@/$(TOOLCHAIN_VERS)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPiZero2W.cgpr
endif
	chmod -R ugo-w					$(PKGDIR)/usr
	fakeroot dpkg-deb --build			$(PKGDIR)
	chmod -R u+w					$(PKGDIR)/usr

################################################################################

# Remove working files

clean:
	-chmod -R u+w $(PKGDIR)
	rm -rf $(PKGDIR) $(PKGFILE)

reallyclean: clean
	-chmod -R u+w gcc*
	rm -rf .build .config* build* config* *.done gcc* include

distclean: reallyclean
	rm -rf distfiles
