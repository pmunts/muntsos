# Makefile for building metapackages for all MuntsOS cross-toolchains

# Copyright (C)2018-2024, Philip Munts dba Munts Technologies.
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
BOARDNAME	?= BeagleBone

include $(MUNTSOS)/include/$(BOARDNAME).mk

ifeq ($(TOOLCHAIN_BUILDER), crosstool)
FLAVOR		:= ctng
else ifeq ($(TOOLCHAIN_BUILDER), arm-gnu)
FLAVOR		:= abe
endif

BOARDNAMES	:= BeagleBone RaspberryPi1 RaspberryPi2 RaspberryPi3
BOARDNAMELC	:= $(shell echo $(BOARDNAME) | tr A-Z a-z)

PKGVERSION1	:= 9.3
PKGVERSION2	:= 9.3
PKGVERSION3	:= 9.3
PKGVERSION4	:= 9.3

default:
	$(MAKE) allplatforms
	for P in $(BOARDNAMES) ; do $(MAKE) oneplatform BOARDNAME=$$P ; done

# Build a metapackage for all platforms

allplatforms:
	cp control.template1 control.everything
	sed -i 's/@@VERSION@@/$(PKGVERSION1)/g' control.everything
	equivs-build control.everything
	rm control.everything
	mv muntsos-dev_$(PKGVERSION1)_all.deb muntsos-dev-$(PKGVERSION1)-all.deb
	-rm *.buildinfo *.changes

# Build a metapackage for a single platform

oneplatform:
ifeq ($(BOARDNAME), RaspberryPi1)
	cp control.template4					control.$(BOARDNAME)
	sed -i 's/@@BOARDNAME@@/$(BOARDNAME)/g'			control.$(BOARDNAME)
	sed -i 's/@@BOARDNAMELC@@/$(BOARDNAMELC)/g'		control.$(BOARDNAME)
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g'	control.$(BOARDNAME)
	sed -i 's/@@VERSION@@/$(PKGVERSION4)/g'			control.$(BOARDNAME)
	equivs-build						control.$(BOARDNAME)
	rm							control.$(BOARDNAME)
	mv muntsos-dev-$(BOARDNAMELC)_$(PKGVERSION4)_all.deb muntsos-dev-$(BOARDNAMELC)-$(PKGVERSION4)-all.deb
else ifeq ($(BOARDNAME), RaspberryPi3)
	cp control.template3					control.aarch64
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g'	control.aarch64
	sed -i 's/@@FLAVOR@@/$(FLAVOR)/g'			control.aarch64
	sed -i 's/@@VERSION@@/$(PKGVERSION3)/g'			control.aarch64
	equivs-build						control.aarch64
	rm							control.aarch64
	mv muntsos-dev-aarch64_$(PKGVERSION3)_all.deb muntsos-dev-aarch64-$(PKGVERSION3)-all.deb
else
	cp control.template2					control.$(BOARDNAME)
	sed -i 's/@@BOARDNAME@@/$(BOARDNAME)/g'			control.$(BOARDNAME)
	sed -i 's/@@BOARDNAMELC@@/$(BOARDNAMELC)/g'		control.$(BOARDNAME)
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g'	control.$(BOARDNAME)
	sed -i 's/@@FLAVOR@@/$(FLAVOR)/g'			control.$(BOARDNAME)
	sed -i 's/@@VERSION@@/$(PKGVERSION2)/g'			control.$(BOARDNAME)
	equivs-build						control.$(BOARDNAME)
	rm							control.$(BOARDNAME)
	mv muntsos-dev-$(BOARDNAMELC)_$(PKGVERSION2)_all.deb muntsos-dev-$(BOARDNAMELC)-$(PKGVERSION2)-all.deb
endif
	-rm *.buildinfo *.changes

# Remove working files

clean:
	rm -f muntsos*
