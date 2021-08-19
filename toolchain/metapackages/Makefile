# Makefile for building a metapackages for all MuntsOS cross-toolchain
# packages

# Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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

OSNAME		?= unknown
MUNTSOS		?= ../..
BOARDNAME	?= RaspberryPi

include $(MUNTSOS)/include/$(BOARDNAME).mk

BOARDNAMES	= BeagleBone RaspberryPi1 RaspberryPi2
TOOLCHAIN	= Crosstool

BOARDNAMELC	:= $(shell echo $(BOARDNAME) | tr A-Z a-z)
TOOLCHAINLC	:= $(shell echo $(TOOLCHAIN) | tr A-Z a-z)

PKGNAME		:= muntsos-$(TOOLCHAINLC)-$(BOARDNAMELC)
PKGVERSION	:= 1.3
PKGFILE		:= $(PKGNAME)-$(PKGVERSION)-$(OSNAME)-all.deb

# Build metapackages for all platforms

default:
	cp control.template1 control.everything
	sed -i 's/@@TOOLCHAIN@@/$(TOOLCHAINLC)/g' control.everything
	equivs-build control.everything
	rm control.everything
	mv muntsos-$(TOOLCHAINLC)_$(PKGVERSION)_all.deb muntsos-$(TOOLCHAINLC)-all.deb
	for P in $(BOARDNAMES) ; do $(MAKE) package BOARDNAME=$$P CONTROL=control.template2 ; done
	$(MAKE) package BOARDNAME=AArch64 CONFIGURE_NAME=aarch64-linux-gnu CONTROL=control.template3

# Generate the control file for a single platform

$(PKGFILE):
	cp $(CONTROL) control.$(BOARDNAME)
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' control.$(BOARDNAME)
	sed -i 's/@@BOARDNAME@@/$(BOARDNAMELC)/g' control.$(BOARDNAME)
	sed -i 's/@@TOOLCHAIN@@/$(TOOLCHAINLC)/g' control.$(BOARDNAME)
	equivs-build control.$(BOARDNAME)
	rm control.$(BOARDNAME)
	mv muntsos-$(TOOLCHAINLC)-$(BOARDNAMELC)_$(PKGVERSION)_all.deb $(PKGFILE)

package: $(PKGFILE)

# Remove working files

clean:
	rm -f muntsos*
