# Makefile for building metapackages for all MuntsOS cross-toolchains

# Copyright (C)2018-2022, Philip Munts, President, Munts AM Corp.
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
#MUNTSOS		?= ../..
CONFIGNAME	?= unknown

#include $(MUNTSOS)/include/$(CONFIGNAME).mk

CONFIGNAMES	:= aarch64-linux-gnu arm-linux-gnueabihf
TOOLCHAIN	:= debian

PKGVERSION1	:= 1.0
PKGVERSION2	:= 1.0

# Build metapackages for all platforms

default:
	$(MAKE) allplatforms
	for C in $(CONFIGNAMES) ; do $(MAKE) oneplatform CONFIGNAME=$$C ; done

# Build a metapackage for all platforms

allplatforms:
	cp control.template1 control.everything
	sed -i 's/@@TOOLCHAIN@@/$(TOOLCHAIN)/g' control.everything
	sed -i 's/@@VERSION@@/$(PKGVERSION1)/g' control.everything
	equivs-build control.everything
	rm control.everything *.buildinfo *.changes
	mv muntsos-$(TOOLCHAIN)_$(PKGVERSION1)_all.deb muntsos-$(TOOLCHAIN)-$(PKGVERSION1)-$(OSNAME)-all.deb

# Build a metapackage for a single platform

oneplatform:
	cp control.template2 control.$(CONFIGNAME)
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGNAME)/g' control.$(CONFIGNAME)
	sed -i 's/@@TOOLCHAIN@@/$(TOOLCHAIN)/g' control.$(CONFIGNAME)
	sed -i 's/@@VERSION@@/$(PKGVERSION2)/g' control.$(CONFIGNAME)
	equivs-build control.$(CONFIGNAME)
	#rm control.$(CONFIGNAME) *.buildinfo *.changes
	mv muntsos-$(TOOLCHAIN)-$(CONFIGNAME)_$(PKGVERSION2)_all.deb muntsos-$(TOOLCHAIN)-$(CONFIGNAME)-$(PKGVERSION2)-$(OSNAME)-all.deb

# Remove working files

clean:
	rm -f muntsos*
