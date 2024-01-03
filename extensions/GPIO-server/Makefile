# Makefile for building a dedicated GPIO server package for MuntsOS

# Copyright (C)2014-2022, Philip Munts, President, Munts AM Corp.
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

BUILDFLAGS	:= BOARDNAME=$(BOARDNAME) MUNTSOS=$(MUNTSOS)
OSNAME		:= muntsos-$(BOARDBASE)
PKGNAME		:= GPIO-server
PKGVERSION	:= $(shell date +%Y.%j)
PKGARCH		:= $(DEBARCH)
PKGDIR		:= $(PKGNAME)-$(OSNAME)
PKGFILE		:= $(PKGDIR).deb

default: package.deb

###############################################################################

# Build subordinate components

subordinates.done:
	$(MAKE) -C http		$(BUILDFLAGS)
	$(MAKE) -C linx		$(BUILDFLAGS)
	$(MAKE) -C onc-rpc	$(BUILDFLAGS)
	$(MAKE) -C xml-rpc	$(BUILDFLAGS)
	$(MAKE) -C $(MUNTSOS)/examples/ada/programs remoteio_server $(BUILDFLAGS)
	touch $@

###############################################################################

# Build the Debian package

$(PKGDIR): subordinates.done
	mkdir -p								$@/DEBIAN
	install -cm 0644 control						$@/DEBIAN
	install -cm 0755 postinst						$@/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g						$@/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g						$@/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g					$@/DEBIAN/control
	mkdir -p								$@/etc/rc.d
	mkdir -p								$@/usr/local/lib
	mkdir -p								$@/usr/local/libexec
	install -cm 0755 startup						$@/etc/rc.d/S50-gpio_server
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc.so.3				$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_abyss.so.3			$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_client.so.3			$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_server.so.3			$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_server_abyss.so.3		$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_util.so.4			$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_xmlparse.so.3			$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_xmltok.so.3			$@/usr/local/lib
	install -cm 0755 http/gpio_server_http					$@/usr/local/libexec
	install -cm 0755 linx/gpio_server_linx					$@/usr/local/libexec
	install -cm 0755 $(MUNTSOS)/examples/ada/programs/remoteio_server	$@/usr/local/libexec
	install -cm 0755 onc-rpc/gpio_server_oncrpc				$@/usr/local/libexec
	install -cm 0755 xml-rpc/gpio_server_xmlrpc				$@/usr/local/libexec
	find $@ -type f -exec $(CROSS_COMPILE)strip {} ";" >/dev/null 2>&1
	touch $@

package.deb: $(PKGFILE)

###############################################################################

# Upload package to repository

upload: $(PKGFILE)
	scp $^ $(REPOSITORY)

###############################################################################

# Download prebuilt package

download_prebuilt: $(PKGFILE).downloaded

$(PKGFILE).downloaded:
	wget -q -nc $(DOWNLOADPREFIX)/extensions/$(PKGFILE)
	touch $(PKGFILE).downloaded

###############################################################################

# Clean out working files

clean:
	$(MAKE) -C http    clean	$(BUILDFLAGS)
	$(MAKE) -C linx    clean	$(BUILDFLAGS)
	$(MAKE) -C onc-rpc clean	$(BUILDFLAGS)
	$(MAKE) -C xml-rpc clean	$(BUILDFLAGS)
	$(MAKE) -C $(MUNTSOS)/examples/ada/programs clean $(BUILDFLAGS)
	if [ ! -f $(PKGFILE).downloaded ]; then rm -rf $(PKGFILE) ; fi

reallyclean: clean
	rm -rf *.done $(PKGDIR) $(PKGFILE) $(PKGFILE).downloaded

distclean: reallyclean
