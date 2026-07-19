# Makefile for building the openvpn package for MuntsOS

# Copyright (C)2020-2024, Philip Munts dba Munts Technologies.
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

include $(MUNTSOS)/include/$(BOARDNAME).mk
include $(LIBSIMPLEIO)/include/dpkg.mk

PKGNAME		= noip2
PKGVERSION	= 2.1.9-$(shell date +%Y.%j)
PKGARCH		= $(DEBARCH)
PKGDIR		= $(PKGNAME)-muntsos-$(BOARDARCH)
PKGFILE		= $(PKGDIR).deb

default: package.deb

# Build the Debian package file

$(PKGDIR):
	mkdir -p					$(PKGDIR)/DEBIAN
	install -cm 0644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g		$(PKGDIR)/DEBIAN/control
	mkdir -p					$(PKGDIR)/usr/local/libexec
	$(CROSS_COMPILE)gcc -Wall -o$(PKGDIR)/usr/local/libexec/noip2 noip2.c
	$(CROSS_COMPILE)strip				$(PKGDIR)/usr/local/libexec/noip2
	mkdir -p					$(PKGDIR)/usr/local/share/doc/noip2
	head -n 19 noip2.c | tail -n 15 | cut -c 4- >	$(PKGDIR)/usr/local/share/doc/noip2/COPYING
	mkdir -p					$(PKGDIR)/etc/rc.d
	install -cm 0755 startup			$(PKGDIR)/etc/rc.d/S10-noip2
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
	if [ ! -f $(PKGFILE).downloaded ]; then rm -f $(PKGFILE) ; fi

reallyclean: clean
	rm -rf $(PKGDIR) $(PKGFILE) $(PKGFILE).downloaded

distclean: reallyclean
