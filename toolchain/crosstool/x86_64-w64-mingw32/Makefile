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

TUPLE		:= x86_64-w64-mingw32
INSTALLDIR	:= gcc-$(TUPLE)
BUILDPATH	:= $(HOME)/.local/share/alire/toolchains/gnat_native_15.2.1_4640d4b3/bin
BUILDPATH	:= $(BUILDPATH):/usr/bin
CTNG		:= PATH=$(BUILDPATH) ./ctng/bin/ct-ng

default: build.done

################################################################################

# Prepare the system for building a Crosstool-NG toolchain

prepare.done:
	PATH=$(BUILDPATH) $(MAKE) -f Makefile.ctng
	touch $@

################################################################################

# Configure the cross-toolchain

config.done:
	DEFCONFIG=$(TUPLE).config $(CTNG) defconfig
	$(CTNG) oldconfig
	DEFCONFIG=$(TUPLE).config $(CTNG) savedefconfig
	touch $@

menuconfig:
	DEFCONFIG=$(TUPLE).config $(CTNG) defconfig
	$(CTNG) menuconfig
	$(CTNG) oldconfig
	DEFCONFIG=$(TUPLE).config $(CTNG) savedefconfig
	touch config.done

upgradeconfig:
	DEFCONFIG=$(TUPLE).config $(CTNG) defconfig
	$(CTNG) upgradeconfig
	$(CTNG) oldconfig
	DEFCONFIG=$(TUPLE).config $(CTNG) savedefconfig
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
	touch $@

################################################################################

# Remove working files

clean:

reallyclean: clean
	-chmod -R u+w gcc*
	rm -rf .config* build* config* gcc*

distclean: reallyclean
	$(MAKE) -f Makefile.ctng clean
	rm -rf distfiles include prepare.done source.done
