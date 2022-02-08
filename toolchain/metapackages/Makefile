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
MUNTSOS		?= ../..
BOARDNAME	?= RaspberryPi

include $(MUNTSOS)/include/$(BOARDNAME).mk

BOARDNAMES	:= BeagleBone RaspberryPi1 RaspberryPi2
BOARDNAMELC	:= $(shell echo $(BOARDNAME) | tr A-Z a-z)

PKGVERSION1	:= 1.0
PKGVERSION2	:= 1.0
PKGVERSION3	:= 1.0

# Build metapackages for all platforms

default:
	$(MAKE) allplatforms PKGVERSION=$(PKGVERSION1)
	for P in $(BOARDNAMES) ; do $(MAKE) oneplatform BOARDNAME=$$P CONTROL=control.template2 PKGVERSION=$(PKGVERSION2); done
	$(MAKE) oneplatform BOARDNAME=AArch64 CONFIGURE_NAME=aarch64-linux-gnu CONTROL=control.template3 PKGVERSION=$(PKGVERSION3)
	-rm *.buildinfo *.changes

# Build a metapackage for all platforms

allplatforms:
	cp control.template1 control.everything
	sed -i 's/@@VERSION@@/$(PKGVERSION)/g' control.everything
	equivs-build control.everything
	rm control.everything
	mv muntsos-dev_$(PKGVERSION)_all.deb muntsos-dev-$(PKGVERSION)-$(OSNAME)-all.deb

# Build a metapackage for a single platform

oneplatform:
	cp $(CONTROL) control.$(BOARDNAME)
	sed -i 's/@@BOARDNAME@@/$(BOARDNAMELC)/g' control.$(BOARDNAME)
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' control.$(BOARDNAME)
	sed -i 's/@@VERSION@@/$(PKGVERSION)/g' control.$(BOARDNAME)
	equivs-build control.$(BOARDNAME)
	rm control.$(BOARDNAME)
	mv muntsos-dev-$(BOARDNAMELC)_$(PKGVERSION)_all.deb muntsos-dev-$(BOARDNAMELC)-$(PKGVERSION)-$(OSNAME)-all.deb

# Remove working files

clean:
	rm -f muntsos*
