# Build Munts OS Embedded Linux cross-toolchain using Linaro ABE

# Copyright (C)2023, Philip Munts dba Munts Technologies.
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
DESTFILES	:= cross/builds/destdir/x86_64-pc-linux-gnu
ifeq ($(BOARDNAME), RaspberryPi3)
MANIFEST	:= AArch64.manifest
else
MANIFEST	:= $(BOARDNAME).manifest
endif

BUILDNUM	?= 1
OSNAME		?= unknown
PKGNAME		:= gcc-$(TOOLCHAIN_NAME)
PKGVER		:= $(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		:= $(shell dpkg --print-architecture)
PKGSUFFIX	:= $(PKGVER)-$(OSNAME)-$(PKGARCH)
PKGDIR		:= $(PKGNAME)-$(PKGSUFFIX)
PKGFILE		:= $(PKGNAME)-$(PKGSUFFIX).deb

default: package.deb

################################################################################

# Clone ABE

abe.done:
	git clone $(ABEURL)
	touch $@

################################################################################

# Build cross-toolchain

cross.done: abe.done
	test -x /usr/local/bin/git-new-workdir
	test ! -d cross && mkdir cross && cd cross && ../abe/configure
	cd cross && ../abe/abe.sh --snapshots $(DISTFILES) --manifest ../$(MANIFEST) --build all
	touch $@

################################################################################

# Reconstitute previous build from installed files

reconstitute:
	mkdir -p $(DESTFILES)
	rmdir $(DESTFILES)
	cp -R -P -p $(TOOLCHAIN_DIR) $(DESTFILES)
	chmod -R u+w $(DESTFILES)
	rm -rf $(DESTFILES)/share/gpr
	touch abe.done cross.done

################################################################################

# Create Debian package

package.deb: cross.done
	mkdir -p					$(PKGDIR)/DEBIAN
	install -cm 0644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g		$(PKGDIR)/DEBIAN/control
ifeq ($(BOARDNAME), RaspberryPi3)
	sed -i s/@@BOARDNAME@@/AArch64/g		$(PKGDIR)/DEBIAN/control
else
	sed -i s/@@BOARDNAME@@/$(BOARDBASE)/g		$(PKGDIR)/DEBIAN/control
endif
	mkdir -p					$(PKGDIR)$(TOOLCHAIN_DIR)
	rmdir						$(PKGDIR)$(TOOLCHAIN_DIR)
	cp -R -P -p $(DESTFILES)			$(PKGDIR)$(TOOLCHAIN_DIR)
	mkdir -p					$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
ifeq ($(BOARDNAME), RaspberryPi3)
	ln -s $(CONFIGURE_NAME).cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi3.cgpr
	ln -s $(CONFIGURE_NAME).cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi4.cgpr
else
	ln -s $(CONFIGURE_NAME).cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(BOARDBASE).cgpr
endif
	find $(PKGDIR)/usr/local/$(PKGNAME) -type f -executable -exec strip {} ";" 2>&1 | grep -v recognize | grep -v recognise ; true
	chmod -R ugo-w					$(PKGDIR)$(TOOLCHAIN_DIR)
	fakeroot dpkg-deb --build			$(PKGDIR)
	chmod -R ugo+w					$(PKGDIR)

################################################################################

# Remove working files

clean:
	rm -rf $(PKGNAME)*

reallyclean: clean
	rm -rf cross*

distclean: reallyclean
	rm -rf abe* $(DISTFILES)
