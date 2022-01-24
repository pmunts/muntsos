# Makefile for building the XML-RPC server library package for MuntsOS

# Copyright (C)2021-2022, Philip Munts, President, Munts AM Corp.
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
MUNTSOS		?= $(shell pwd)/../..

include $(MUNTSOS)/include/$(BOARDNAME).mk
include $(LIBSIMPLEIO)/include/dpkg.mk

OSNAME		= muntsos-$(BOARDBASE)
PKGNAME		= xmlrpc-server
PKGVERSION	= $(shell date +%Y.%j)
PKGARCH		= $(DEBARCH)
PKGDIR		= $(PKGNAME)-$(OSNAME)
PKGFILE		= $(PKGDIR).deb

default: package.deb

# Build the Debian package file

$(PKGDIR):
	mkdir -p							$@/DEBIAN
	install -cm 0644 control					$@/DEBIAN
	install -cm 0755 postinst					$@/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g					$@/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g					$@/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g				$@/DEBIAN/control
	mkdir -p							$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc.so.3			$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_abyss.so.3		$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_server.so.3		$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_server_abyss.so.3	$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_util.so.4		$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_xmlparse.so.3		$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_xmltok.so.3		$@/usr/local/lib
	touch $@

package.deb: $(PKGFILE)

# Download prebuilt package

download_prebuilt: $(PKGFILE).downloaded

$(PKGFILE).downloaded:
	wget -q -nc $(DOWNLOADPREFIX)/extensions/$(PKGFILE)
	touch $(PKGFILE).downloaded

# Remove working files

clean:
	rm -rf $(PKGDIR)
	if [ ! -f $(PKGFILE).downloaded ]; then rm -f $(PKGFILE) ; fi

reallyclean: clean
	rm -rf $(PKGFILE) $(PKGFILE).downloaded

distclean: reallyclean
