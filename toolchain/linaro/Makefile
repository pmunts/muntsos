# Makefile for building a Linaro ARM cross-toolchain

# Copyright (C)2015-2021, Philip Munts, President, Munts AM Corp.
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

ABEURL		= http://git.linaro.org/git/toolchain/abe.git

DISTFILES	:= $(shell pwd)/distfiles
NATIVEBIN	:= $(shell pwd)/native/builds/destdir/x86_64-unknown-linux-gnu/bin

OSNAME		?= unknown
PKGNAME		= gcc-$(TOOLCHAIN_NAME)
PKGVER		= $(shell date +%Y.%j)
PKGARCH		= $(shell dpkg --print-architecture)
PKGSUFFIX	= $(PKGVER)-$(OSNAME)-$(PKGARCH)
PKGDIR		= $(PKGNAME)-$(PKGSUFFIX)
PKGFILE		= $(PKGNAME)-$(PKGSUFFIX).deb

default: package.deb

################################################################################

abe.done:
	git clone --depth 1 $(ABEURL)
	patch -b -p0 <languages.patch
	patch -b -p0 <noqemu.patch
	if [ -f $(BOARDBASE).patch ]; then patch -b -p0 <$(BOARDBASE).patch ; fi
	touch $@

################################################################################

native.done: abe.done
	mkdir -p native
	cd native && ../abe/configure --with-local-snapshots=$(DISTFILES) && ../abe/abe.sh --build all
	touch $@

################################################################################

cross.done: abe.done
	mkdir -p cross
	env PATH=$(NATIVEBIN)':'$(PATH) sh -c "cd cross && ../abe/configure --with-local-snapshots=$(DISTFILES) && ../abe/abe.sh --target $(CONFIGURE_NAME) --build all"
	touch $@

################################################################################

# Create Debian package

package.deb: cross.done
	mkdir -p					$(PKGDIR)/DEBIAN
	mkdir -p					$(PKGDIR)/usr/local/$(PKGNAME)
	install -cm 0644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@BOARDNAME@@/$(BOARDBASE)/g		$(PKGDIR)/DEBIAN/control
	cp -R -P -p cross/builds/destdir/*/*		$(PKGDIR)/usr/local/$(PKGNAME)
	mkdir -p					$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	find $(PKGDIR)/usr/local/$(PKGNAME) -type f -executable -exec strip {} ";" 2>&1 | grep -v recognize | grep -v recognise ; true
	chmod -R ugo-w					$(PKGDIR)/usr/local/*
	fakeroot dpkg-deb --build			$(PKGDIR)
	chmod -R ugo+w					$(PKGDIR)

################################################################################

# Remove working files

clean:
	rm -rf abe abe.done cross cross.done $(PKGNAME)*

reallyclean: clean
	rm -rf native native.done

distclean: reallyclean
	rm -rf distfiles
