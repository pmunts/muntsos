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

ifeq ($(shell uname -o), Cygwin)
# Build with Alire GNAT Native
BUILDPATH	:= $(HOME)/AppData/Local/alire/cache/toolchains/gnat_native_15.2.1_346e2e00
BUILDPATH	:= $(BUILDPATH):/usr/bin
endif

ifeq ($(shell uname), Darwin)
## Build with Alire GNAT Native
BUILDPATH	:= $(HOME)/.local/share/alire/toolchains/gnat_native_15.1.2_60748c54/bin
## Force certain Homebrew programs to replace MacOS counterparts
BREW_PREFIX	:= $(shell brew --prefix)
BUILDPATH	:= $(BUILDPATH):$(BREW_PREFIX)/bin
BUILDPATH	:= $(BUILDPATH):$(BREW_PREFIX)/opt/binutils/bin
BUILDPATH	:= $(BUILDPATH):$(BREW_PREFIX)/opt/bison/bin
BUILDPATH	:= $(BUILDPATH):$(BREW_PREFIX)/opt/libtool/libexec/gnubin
BUILDPATH	:= $(BUILDPATH):/bin:/usr/bin
CPPFLAGS	:= -I$(BREW_PREFIX)/include -I$(BREW_PREFIX)/opt/binutils/include -I$(BREW_PREFIX)/opt/ncurses/include
LDFLAGS		:= -L$(BREW_PREFIX)/opt/binutils/lib -L$(BREW_PREFIX)/opt/bison/lib -L$(BREW_PREFIX)/opt/ncurses/lib
PKG_CONFIG_PATH	:= $(BREW_PREFIX)/share/pkgconfig
endif

ifeq ($(shell uname), Linux)
ifeq ($(shell uname -m), aarch64)
# Build with Alire GNAT Native 
BUILDPATH	:= $(HOME)/.local/share/alire/toolchains/gnat_native_15.2.1_54b1000a/bin
BUILDPATH	:= $(BUILDPATH):/usr/bin
endif
ifeq ($(shell uname -m), x86_64)
# Build with Alire GNAT Native
BUILDPATH	:= $(HOME)/.local/share/alire/toolchains/gnat_native_15.2.1_4640d4b3/bin
BUILDPATH	:= $(BUILDPATH):/usr/bin
endif
endif

ifeq ($(shell uname -o), Msys2)
# Build with Alire GNAT Native, and exclude Windows system directories
BUILDPATH	:= $(HOME)/AppData/Local/alire/cache/toolchains/gnat_native_15.2.1_346e2e00
BUILDPATH	:= $(BUILDPATH):/usr/bin
endif

CTNG		:= PATH=$(BUILDPATH) ./ctng/bin/ct-ng
INSTALLDIR	:= gcc-$(CONFIGURE_NAME)

default: build.done

################################################################################

# Prepare the system for building a Crosstool-NG toolchain

prepare.done:
	PATH=$(BUILDPATH) $(MAKE) -f Makefile.ctng
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

# Reconstitute previous build from installed files

reconstitute:
	sudo apt purge 'gcc-$(GCCARCH)-muntsos*lib*'
	cp -R -P -p $(TOOLCHAIN_DIR) $(INSTALLDIR)
	chmod -R u+w $(INSTALLDIR)
	rm -rf $(INSTALLDIR)/bin/gpr* $(INSTALLDIR)/libexec/gprbuild* $(INSTALLDIR)/share/gpr
	touch build.done

################################################################################

# Remove working files

clean:

reallyclean: clean
	-chmod -R u+w gcc*
	rm -rf .config* build* config* gcc* include

distclean: reallyclean
	$(MAKE) -f Makefile.ctng clean
	rm -rf distfiles
