# Makefile definitions for building GNAT Ada application programs

# Copyright (C)2017-2021, Philip Munts, President, Munts AM Corp.
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
include $(MUNTSOS)/include/$(BOARDNAME).mk

BUILDNUM	?= 1

OSNAME		?= unknown
PKGNAME		= gcc-$(TOOLCHAIN_NAME)-libaws
PKGVER		= $(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		= all
PKGSUFFIX	= $(PKGVER)-$(OSNAME)-$(PKGARCH)
PKGDIR		= $(PKGNAME)-$(PKGSUFFIX)
PKGFILE		= $(PKGDIR).deb

default: package.deb

###############################################################################

# Compile the Ada Web Server packages

libaws.a:
	rm -rf obj
	mkdir -p obj
	cd src && ln -s aws-os_lib.ads-$(BOARDNAME) aws-os_lib.ads
	$(CROSS_COMPILE)gcc -Wall -c -o obj/wrappers.o src/wrappers.c
	$(CROSS_COMPILE)gnatmake -Wall -D obj -gnat2012 -c src/with_everything.adb
	rm obj/with_everything.ali obj/with_everything.o
	$(CROSS_COMPILE)ar cr $@ obj/*.o

###############################################################################

# Create Debian package

package.deb: libaws.a
	mkdir -p					$(PKGDIR)/DEBIAN
	install -cm 0644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@BOARDNAME@@/$(BOARDBASE)/g		$(PKGDIR)/DEBIAN/control
	mkdir -p					$(PKGDIR)/$(TOOLCHAIN_DIR)/share/gpr
	install -cm 0644 aws.gpr			$(PKGDIR)/$(TOOLCHAIN_DIR)/share/gpr
	sed -i s@SYSROOT@$(GCCSYSROOT)@g		$(PKGDIR)/$(TOOLCHAIN_DIR)/share/gpr/aws.gpr
	mkdir -p					$(PKGDIR)/$(GCCSYSROOT)/usr/include/aws
	install -cm 0644 src/*.ads src/*.adb		$(PKGDIR)/$(GCCSYSROOT)/usr/include/aws
	rm						$(PKGDIR)/$(GCCSYSROOT)/usr/include/aws/with_everything.adb
	mkdir -p					$(PKGDIR)/$(GCCSYSROOT)/usr/lib/aws
	install -cm 0644 *.a obj/*.ali			$(PKGDIR)/$(GCCSYSROOT)/usr/lib/aws
	chmod -R ugo-w					$(PKGDIR)/usr
	fakeroot dpkg-deb --build			$(PKGDIR)
	chmod -R ugo+w					$(PKGDIR)/usr

###############################################################################

clean:
	rm -rf *.a obj $(PKGDIR) $(PKGFILE) src/aws-os_lib.ads
