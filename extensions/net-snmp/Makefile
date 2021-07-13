# Makefile for building the net-snmp package for MuntsOS

# Copyright (C)2016-2021, Philip Munts, President, Munts AM Corp.
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

BUILDOS		= --build=`uname -m`
TARGETOS	= --host=$(CONFIGURE_NAME)

SRCNAME		= net-snmp
SRCVER		= 5.8
SRCDIR		= $(SRCNAME)-$(SRCVER)
SRCTARBALL	= $(SRCDIR).tar.gz
SRCSERVER	= https://sourceforge.net/projects/net-snmp/files/net-snmp/$(SRCVER)
SRCURL		= $(SRCSERVER)/$(SRCTARBALL)
SRCDIST		= $(TEMP)/$(SRCTARBALL)
DESTDIR		= $(SRCDIR)/skeleton
SBINDIR		= $(DESTDIR)/usr/local/sbin
MIBSDIR		= $(DESTDIR)/usr/local/share/snmp/mibs

OSNAME		= muntsos-$(BOARDBASE)
PKGNAME		= $(SRCNAME)
PKGVERSION	= $(SRCVER)-$(shell date +%Y.%j)
PKGARCH		= $(DEBARCH)
PKGDIR		= $(PKGNAME)-$(OSNAME)
PKGFILE		= $(PKGDIR).deb

default: package.deb

# Download the source distribution

$(SRCDIST):
	wget -nv -P $(TEMP) $(SRCURL)

# Unpack the source distribution

src.done: $(SRCDIST)
	tar xzf $^
	cp /usr/share/misc/config.guess $(SRCDIR)
	cp /usr/share/misc/config.sub   $(SRCDIR)
	touch $@

# Compile sources

build.done: src.done
	cd $(SRCDIR) ; ./configure $(BUILDOS) $(TARGETOS) CC=$(CROSS_COMPILE)gcc --enable-mini-agent --with-mib-modules="mibII ip-mib if-mib tcp-mib udp-mib ucd_snmp target agent_mibs notification-log-mib snmpv3mibs notification" --without-perl-modules --disable-embedded-perl --disable-shared --with-default-snmp-version="2" --with-sys-contact="root" --with-sys-location="unknown" --with-logfile="/var/log/snmpd.log" --with-persistent-directory="/var/net-snmp" --disable-manuals
	$(MAKE) -C $(SRCDIR)
	mkdir -p $(SRCDIR)/skeleton
	$(MAKE) -C $(SRCDIR) install DESTDIR=$(shell pwd)/$(DESTDIR)
	touch $@

# Build the Debian package file

$(PKGDIR): build.done
	mkdir -p					$(PKGDIR)/DEBIAN
	install -cm 0644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g		$(PKGDIR)/DEBIAN/control
	mkdir -p					$(PKGDIR)/etc/rc.d
	mkdir -p					$(PKGDIR)/usr/local/etc
	mkdir -p					$(PKGDIR)/usr/local/libexec
	mkdir -p					$(PKGDIR)/usr/local/share/snmp/mibs
	install -cm 0755 startup			$(PKGDIR)/etc/rc.d/S50-snmpd
	install -cm 0644 snmpd.conf			$(PKGDIR)/usr/local/etc
	install -cm 0755 $(SBINDIR)/snmpd		$(PKGDIR)/usr/local/libexec
	$(CROSS_COMPILE)strip				$(PKGDIR)/usr/local/libexec/*
	install -cm 0644 $(MIBSDIR)/SNMPv2*.txt		$(PKGDIR)/usr/local/share/snmp/mibs
	touch $@

package.deb: $(PKGFILE)

# Download prebuilt package

download_prebuilt: $(PKGFILE).downloaded

$(PKGFILE).downloaded:
	wget -q -nc $(DOWNLOADPREFIX)/extensions/$(PKGFILE)
	touch $(PKGFILE).downloaded

# Remove working files

clean:
	rm -rf build.done $(PKGDIR) $(SRCDIR)/skeleton
	if [ ! -f $(PKGFILE).downloaded ]; then rm -f $(PKGFILE) ; fi
	-$(MAKE) -C $(SRCDIR) distclean

reallyclean: clean
	rm -rf src.done $(SRCDIR) $(PKGFILE) $(PKGFILE).downloaded

distclean: reallyclean
	rm -rf $(SRCDIST)
