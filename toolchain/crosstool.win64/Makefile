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

MUNTSOS    ?= ../..

include $(MUNTSOS)/include/$(BOARDNAME).mk

CTNG		?= ../crosstool-ng/bin/ct-ng
INSTALLDIR	:= gcc-$(CONFIGURE_NAME)

default: build.done

################################################################################

# Prepare the system for building a Crosstool-NG toolchain

prepare.done:
	$(MAKE) -C ../crosstool-ng
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
	echo "Building $(INSTALLDIR)"
	$(CTNG) build
	rm $(INSTALLDIR)/build.log.bz2
	touch $@

################################################################################

# Remove working files

clean:

reallyclean: clean
	-chmod -R u+w gcc*
	rm -rf .build .config* build* config* *.done gcc* include

distclean: reallyclean
	rm -rf distfiles
