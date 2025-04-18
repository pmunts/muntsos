# Makefile for mailtunnel lightweight MTA extension package

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

PKGNAME		:= mailtunnel
PKGVERSION	:= $(shell date +%Y.%j)
PKGARCH		:= all
PKGDIR		:= $(PKGNAME)-muntsos-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb

MAILIDENT	?= id_rsa
MAILUSER	?= $(PKGNAME)
MAILSERVER	?= UNKNOWN

default: $(PKGFILE)

id_rsa:
	ssh-keygen -C "Mail Tunnel User" -t rsa -b 4096 -f id_rsa

known_hosts:
	ssh-keyscan $(MAILSERVER) >$@

$(PKGFILE): $(PKGDIR)
	fakeroot dpkg-deb --build $(PKGDIR)

$(PKGDIR):
	mkdir -p				$(PKGDIR)/DEBIAN
	install -cm 0644 control		$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g	$(PKGDIR)/DEBIAN/control
	install -cm 0755 postinst		$(PKGDIR)/DEBIAN
	sed -i 's/@@MAILUSER@@/$(MAILUSER)/g'	$(PKGDIR)/DEBIAN/postinst
	sed -i 's/@@MAILSERVER@@/$(MAILSERVER)/g' $(PKGDIR)/DEBIAN/postinst
	mkdir -p				$(PKGDIR)/etc
	install -cm 0400 $(MAILIDENT)		$(PKGDIR)/etc/mailtunnel.id
	install -cm 0400 known_hosts		$(PKGDIR)/etc/mailtunnel.hosts

clean:
	-rm -rf $(PKGDIR) $(PKGFILE)

reallyclean: clean
	rm -f $(MAILIDENT) $(MAILIDENT).pub known_hosts

distclean: reallyclean
