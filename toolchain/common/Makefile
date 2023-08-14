# Makefile to build the MuntsOS Embedded Linux Common Files package

# Copyright (C)2022-2023, Philip Munts dba Munts Technologies.
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

LIBSIMPLEIO	?= /usr/local/share/libsimpleio
MUNTSOS		?= ../..

BUILDNUM	?= 1
OSNAME		?= unknown
PKGNAME		:= muntsos-common
PKGVER		:= $(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		:= all
PKGDIR		:= $(PKGNAME)-$(PKGVER)-$(OSNAME)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb

include $(LIBSIMPLEIO)/ada/include/ada.mk
include $(LIBSIMPLEIO)/include/dpkg.mk

default: package.deb

# Create Debian package file

$(PKGDIR):
	mkdir -p				$(PKGDIR)/DEBIAN
	install -cm 0644 control		$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g	$(PKGDIR)/DEBIAN/control
	sed -i s/@@TARGET@@/$(TARGET)/g		$(PKGDIR)/DEBIAN/control
	mkdir -p				$(PKGDIR)/usr/local/share/muntsos
	cp -R -P -p $(MUNTSOS)/doc		$(PKGDIR)/usr/local/share/muntsos
	cp -R -P -p $(MUNTSOS)/examples		$(PKGDIR)/usr/local/share/muntsos
	cp -R -P -p $(MUNTSOS)/include		$(PKGDIR)/usr/local/share/muntsos
	cp $(MUNTSOS)/COPYING			$(PKGDIR)/usr/local/share/muntsos/doc
	rm -rf					$(PKGDIR)/usr/local/share/muntsos/doc/.blinky
	rm -rf					$(PKGDIR)/usr/local/share/muntsos/doc/.rawhid
	rm -rf					$(PKGDIR)/usr/local/share/muntsos/examples/README.*
	rm -rf					$(PKGDIR)/usr/local/share/muntsos/examples/firmware
	rm -rf					$(PKGDIR)/usr/local/share/muntsos/examples/ada/freemodbus
	sed -i 's@$$(HOME)/muntsos@/usr/local/share/muntsos@g' $(PKGDIR)/usr/local/share/muntsos/examples/*/*/Makefile

package.deb: $(PKGFILE)

###############################################################################

# Remove working files

clean:
	-rm -rf $(PKGDIR) $(PKGFILE)

reallyclean: clean

distclean: reallyclean
