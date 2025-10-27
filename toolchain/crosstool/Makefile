# Makefile for building a crosstool-NG cross-toolchain

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

MUNTSOS		?= ../..

include $(MUNTSOS)/include/$(BOARDNAME).mk

CTNG		:= ctng/bin/ct-ng
INSTALLDIR	:= gcc-$(CONFIGURE_NAME)

ifeq ($(shell uname), Darwin)
# Force using certain Homebrew programs instead of MacOS counterparts
BUILDPATH	:= /opt/homebrew/Cellar/binutils/2.45/bin
BUILDPATH	:= $(BUILDPATH):/opt/homebrew/Cellar/m4/1.4.20/bin/m4
BUILDPATH	:= $(BUILDPATH):/opt/homebrew/opt/bison/bin:$(PATH)
CTNG		:= PATH=$(BUILDPATH) $(CTNG)
endif

default: build.done

################################################################################

# Prepare the system for building a Crosstool-NG toolchain

prepare.done:
ifeq ($(shell uname), Linux)
	sudo apt -y install autoconf bison build-essential curl flex m4 zlib1g-dev
endif
	$(MAKE) -f Makefile.ctng
	touch $@

################################################################################

# Configure the cross-toolchain

config.done: prepare.done
	DEFCONFIG=$(BOARDNAME).config $(CTNG) defconfig
	$(CTNG) oldconfig
	DEFCONFIG=$(BOARDNAME).config $(CTNG) savedefconfig
	touch $@

menuconfig: prepare.done
	DEFCONFIG=$(BOARDNAME).config $(CTNG) defconfig
	$(CTNG) menuconfig
	$(CTNG) oldconfig
	DEFCONFIG=$(BOARDNAME).config $(CTNG) savedefconfig
	touch config.done

upgradeconfig: prepare.done
	DEFCONFIG=$(BOARDNAME).config $(CTNG) defconfig
	$(CTNG) upgradeconfig
	$(CTNG) oldconfig
	DEFCONFIG=$(BOARDNAME).config $(CTNG) savedefconfig
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
	ln -s ../../../lib/gcc/$(CONFIGURE_NAME)/$(shell awk -F '"' '/CT_GCC_VERSION=/ { print $$2 }' .config)/adalib/libgnat.so  $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/lib/libgnat.so
	ln -s ../../../lib/gcc/$(CONFIGURE_NAME)/$(shell awk -F '"' '/CT_GCC_VERSION=/ { print $$2 }' .config)/adalib/libgnarl.so $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/lib/libgnarl.so
	cd $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/lib && for F in ../../lib/* ; do ln -s -f $$F ; done
	touch $@

################################################################################

# Remove working files

clean:

reallyclean: clean
	-chmod -R u+w gcc*
	rm -rf .config* build* config* *.done gcc* include

distclean: reallyclean
	$(MAKE) -f Makefile.ctng clean
	rm -rf distfiles
