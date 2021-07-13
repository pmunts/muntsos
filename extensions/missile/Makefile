# Makefile for building the USB Missile Launcher server package for MuntsOS

# Copyright (C)2013-2021, Philip Munts, President, Munts AM Corp.
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

CC		:= $(CROSS_COMPILE)gcc
CFLAGS		+= -Wall -I$(GCCSYSROOT)/usr/include/tirpc
LDFLAGS		+= -lusb-1.0 -ltirpc

OSNAME		:= muntsos-$(BOARDBASE)
PKGNAME		:= missile-server
PKGVERSION	:= $(shell date +%Y.%j)
PKGARCH		:= $(DEBARCH)
PKGDIR		:= $(PKGNAME)-$(OSNAME)
PKGFILE		:= $(PKGDIR).deb

default: package.deb

###############################################################################

# Compile the interface definition to create C server stubs

missile.h:
	rpcgen -N missile.x
	patch -b <missile.patch

missile_svc.c: missile.h

###############################################################################

# Compile the ONC-RPC server

missile_server: missile.h
	$(CC) $(CFLAGS) -o $@ missile_server.c missile_svc.c $(LDFLAGS)

###############################################################################

# Compile the ONC-RPC client

missile_client: missile.h
	$(CC) $(CFLAGS) -o $@ missile_client.c missile_clnt.c $(LDFLAGS)

###############################################################################

# Build the Debian package

$(PKGDIR): missile_server missile_client
	mkdir -p					$@/DEBIAN
	install -cm 0644 control			$@/DEBIAN
	install -cm 0755 postinst			$@/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$@/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g			$@/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g		$@/DEBIAN/control
	mkdir -p					$@/etc/rc.d
	mkdir -p					$@/usr/local/bin
	mkdir -p					$@/usr/local/lib
	mkdir -p					$@/usr/local/libexec
	install -cm 0755 startup			$@/etc/rc.d/S50-missile_server
	install -cm 0755 missile_client			$@/usr/local/bin
	install -cm 0755 $(GCCSYSROOT)/usr/lib/libusb-1.0.so.0 $@/usr/local/lib
	install -cm 0755 missile_server			$@/usr/local/libexec
	find $@ -type f -exec $(CROSS_COMPILE)strip {} ";" >/dev/null 2>&1
	touch $@

package.deb: $(PKGFILE)

###############################################################################

# Download prebuilt package

download_prebuilt: $(PKGFILE).downloaded

$(PKGFILE).downloaded:
	wget -q -nc $(DOWNLOADPREFIX)/extensions/$(PKGFILE)
	touch $(PKGFILE).downloaded

###############################################################################

# Remove working files

clean:
	rm -f missile_client
	rm -f missile_server
	rm -f missile.h
	rm -f missile_clnt.c
	rm -f missile_svc.c
	rm -f missile_svc.c.orig
	rm -f missile_xdr.c
	rm -rf *.done $(PKGDIR)
	-if [ ! -f $(PKGFILE).downloaded ]; then rm -rf $(PKGFILE) ; fi

reallyclean: clean
	rm -rf $(PKGFILE) $(PKGFILE).downloaded

distclean: reallyclean
