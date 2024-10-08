# Build a Munts OS Embedded Linux cross-toolchain using Linaro ABE and
# Arm GNU Toolchain manifest

# Copyright (C)2023-2024, Philip Munts dba Munts Technologies.
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

TOOLCHAIN_BUILDER := arm-gnu

include $(MUNTSOS)/include/$(BOARDNAME).mk

ABEURL		= http://git.linaro.org/git/toolchain/abe.git
DISTFILES	= $(shell pwd)/distfiles
DESTFILES	= cross/builds/destdir/x86_64-pc-linux-gnu
MANIFEST	= $(BOARDNAME).manifest

TOOLCHAIN_VERS	= $(shell $(DESTFILES)/bin/$(CONFIGURE_NAME)-gcc --version | awk '/muntsos/ { print $$0 }')
TOOLCHAIN_VERN	= $(shell $(DESTFILES)/bin/$(CONFIGURE_NAME)-gcc --version | awk '/muntsos/ { print $$3 }')

BUILDNUM	?= 1
OSNAME		?= unknown
PKGNAME		= gcc-$(TOOLCHAIN_NAME)
PKGVER		= $(TOOLCHAIN_VERN)-$(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		= $(shell dpkg --print-architecture)
PKGSUFFIX	= $(PKGVER)-$(OSNAME)-$(PKGARCH)
PKGDIR		= $(PKGNAME)-$(PKGSUFFIX)
PKGFILE		= $(PKGNAME)-$(PKGSUFFIX).deb

default: cross.done

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

# Create Debian package

package.deb: cross.done
	mkdir -p					$(PKGDIR)/DEBIAN
	install -cm 0644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@BOARDNAME@@/$(BOARDBASE)/g		$(PKGDIR)/DEBIAN/control
	mkdir -p					$(PKGDIR)$(TOOLCHAIN_DIR)
	rmdir						$(PKGDIR)$(TOOLCHAIN_DIR)
	cp -R -P -p $(DESTFILES)			$(PKGDIR)$(TOOLCHAIN_DIR)
	# Massage the sysroot directory tree
	rm -rf						$(PKGDIR)$(GCCSYSROOT)/etc
	rm -rf						$(PKGDIR)$(GCCSYSROOT)/var
	cd $(PKGDIR)$(LIBSBINDIR) ; for F in ../../sbin/* ; do ln -s -f $$F ; done
	cd $(PKGDIR)$(LIBSLIBDIR) ; for F in ../../lib/* ; do ln -s -f $$F ; done
	# Install .cgpr files
	mkdir -p					$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@TARGET_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@TOOLCHAIN_VERN@@/$(TOOLCHAIN_VERN)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	sed -i 's/@@TOOLCHAIN_VERS@@/$(TOOLCHAIN_VERS)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(BOARDNAME).cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(BOARDNAME).cgpr
	sed -i 's/@@TARGET_NAME@@/$(BOARDNAME)/g'	 $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(BOARDNAME).cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(BOARDNAME).cgpr
	sed -i 's/@@TOOLCHAIN_VERN@@/$(TOOLCHAIN_VERN)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(BOARDNAME).cgpr
	sed -i 's/@@TOOLCHAIN_VERS@@/$(TOOLCHAIN_VERS)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/$(BOARDNAME).cgpr
ifeq ($(BOARDNAME), AArch64)
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/OrangePiZero2W.cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/OrangePiZero2W.cgpr
	sed -i 's/@@TARGET_NAME@@/OrangePiZero2W/g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/OrangePiZero2W.cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/OrangePiZero2W.cgpr
	sed -i 's/@@TOOLCHAIN_VERN@@/$(TOOLCHAIN_VERN)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/OrangePiZero2W.cgpr
	sed -i 's/@@TOOLCHAIN_VERS@@/$(TOOLCHAIN_VERS)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/OrangePiZero2W.cgpr
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi3.cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi3.cgpr
	sed -i 's/@@TARGET_NAME@@/RaspberryPi3/g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi3.cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi3.cgpr
	sed -i 's/@@TOOLCHAIN_VERN@@/$(TOOLCHAIN_VERN)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi3.cgpr
	sed -i 's/@@TOOLCHAIN_VERS@@/$(TOOLCHAIN_VERS)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi3.cgpr
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi4.cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi4.cgpr
	sed -i 's/@@TARGET_NAME@@/RaspberryPi4/g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi4.cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi4.cgpr
	sed -i 's/@@TOOLCHAIN_VERN@@/$(TOOLCHAIN_VERN)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi4.cgpr
	sed -i 's/@@TOOLCHAIN_VERS@@/$(TOOLCHAIN_VERS)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi4.cgpr
	install -cm 0644 template.cgpr			$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi5.cgpr
	sed -i 's/@@CONFIGURE_NAME@@/$(CONFIGURE_NAME)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi5.cgpr
	sed -i 's/@@TARGET_NAME@@/RaspberryPi5/g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi5.cgpr
	sed -i 's:@@TOOLCHAIN_DIR@@:$(TOOLCHAIN_DIR):g'	$(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi5.cgpr
	sed -i 's/@@TOOLCHAIN_VERN@@/$(TOOLCHAIN_VERN)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi5.cgpr
	sed -i 's/@@TOOLCHAIN_VERS@@/$(TOOLCHAIN_VERS)/g' $(PKGDIR)$(TOOLCHAIN_DIR)/share/gpr/RaspberryPi5.cgpr
endif
	find $(PKGDIR)/usr/local/$(PKGNAME) -type f -executable -exec strip {} ";" 2>&1 | grep -v recognize | grep -v recognise ; true
	chmod -R ugo-w					$(PKGDIR)$(TOOLCHAIN_DIR)
	fakeroot dpkg-deb --build			$(PKGDIR)
	chmod -R ugo+w					$(PKGDIR)

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

# Build and upload Debian package files for all targets.  Note this is an all
# night job!

SERVERDIR	?= $(HOME)
PLATFORMS	:= AArch64

upload: package.deb
	scp *.deb $(SERVERDIR)

allplatforms:
	for P in $(PLATFORMS) ; do $(MAKE) upload distclean BOARDNAME=$$P ; done

################################################################################

# Remove working files

clean:
	rm -rf gcc*

reallyclean: clean
	rm -rf cross*

distclean: reallyclean
	rm -rf abe* $(DISTFILES)
