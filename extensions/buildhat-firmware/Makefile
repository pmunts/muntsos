# Makefile for building the Raspberry Pi Build HAT firmware package for MuntsOS

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

BOARDNAME	?= UNDEFINED
MUNTSOS		?= /usr/local/share/muntsos

default: package.deb

include $(MUNTSOS)/include/$(BOARDNAME).mk
include $(LIBSIMPLEIO)/include/dpkg.mk

PBHURL		= https://github.com/RaspberryPiFoundation/python-build-hat.git
PBHSRC		= python-build-hat

FWVERSION	= $(shell cat $(PBHSRC)/buildhat/data/version)

PKGNAME		= buildhat-firmware
PKGVERSION	= $(FWVERSION)-$(shell date +%Y.%j)
PKGARCH		= $(DEBARCH)
PKGDIR		= $(PKGNAME)-muntsos-$(BOARDARCH)
PKGFILE		= $(PKGDIR).deb

# Clone Raspberry Pi Build HAT Python Library source tree

$(PBHSRC):
	git clone $(PBHURL) $(PBHSRC)

python: $(PBHSRC)

# Compile Raspberry Pi Build HAT firmware loader program

loader:
	gprbuild -p $(GPRBUILDCONFIG) $@
	$(CROSS_COMPILE)strip $@

# Build the Debian package file

$(PKGDIR): python loader
	mkdir -p					$@/DEBIAN
	install -cm 0644 control			$@/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$@/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g			$@/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g		$@/DEBIAN/control
	install -cm 0755 postinst			$@/DEBIAN
	mkdir -p					$@/lib/firmware/buildhat
	install -cm 0644 $(PBHSRC)/buildhat/data/*	$@/lib/firmware/buildhat
	install -cm 0755 loader				$@/lib/firmware/buildhat
	touch $@

package.deb: $(PKGFILE)

# Upload package to repository

upload: $(PKGFILE)
	scp $^ $(REPOSITORY)

# Download prebuilt package

download_prebuilt: $(PKGFILE).downloaded

$(PKGFILE).downloaded:
	wget -q -nc $(DOWNLOADPREFIX)/extensions/$(PKGFILE)
	touch $(PKGFILE).downloaded

# Remove working files

clean:
	rm -rf loader obj $(PKGDIR)
	if [ ! -f $(PKGFILE).downloaded ]; then rm -f $(PKGFILE) ; fi

reallyclean: clean
	rm -rf $(PKGFILE) $(PKGFILE).downloaded

distclean: reallyclean
	rm -rf $(PBHSRC)
