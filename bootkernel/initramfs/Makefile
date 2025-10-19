# Make root file system for an embedded Linux system

# Copyright (C)2013-2025, Philip Munts dba Munts Technologies.
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

BOARDNAME		?= UNDEFINED
MUNTSOS			?= $(shell pwd)/../..
MAKEJOBS		?= -j 2

include $(MUNTSOS)/include/$(BOARDNAME).mk

BUILDOS			= --build=`uname -m`
TARGETOS		= --host=$(CONFIGURE_NAME)

DISTDIR			= $(TEMP)/muntsos

BUSYBOX_VERSION		= 1.36.1
BUSYBOX_NAME		= busybox
BUSYBOX_SRC		= $(BUSYBOX_NAME)-$(BUSYBOX_VERSION)
BUSYBOX_TARBALL		= $(BUSYBOX_NAME)-$(BUSYBOX_VERSION).tar.bz2
BUSYBOX_SERVER		= http://www.busybox.net/downloads
BUSYBOX_URL		= $(BUSYBOX_SERVER)/$(BUSYBOX_TARBALL)
BUSYBOX_DIST		= $(DISTDIR)/$(BUSYBOX_TARBALL)

OPENSSH_NAME		= openssh
OPENSSH_VER		= 10.0p1
OPENSSH_SRC		= $(OPENSSH_NAME)-$(OPENSSH_VER)
OPENSSH_TARBALL		= $(OPENSSH_SRC).tar.gz
OPENSSH_SERVER		= http://ftp3.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable
OPENSSH_URL		= $(OPENSSH_SERVER)/$(OPENSSH_TARBALL)
OPENSSH_DIST		= $(DISTDIR)/$(OPENSSH_TARBALL)

RPCBIND_NAME		= rpcbind
RPCBIND_VER		= 1.2.8
RPCBIND_SRC		= $(RPCBIND_NAME)-$(RPCBIND_VER)
RPCBIND_TARBALL		= $(RPCBIND_NAME)-$(RPCBIND_VER).tar.bz2
RPCBIND_SERVER		= https://downloads.sourceforge.net/project/rpcbind/rpcbind
RPCBIND_URL		= $(RPCBIND_SERVER)/$(RPCBIND_VER)/$(RPCBIND_TARBALL)
RPCBIND_DIST		= $(DISTDIR)/$(RPCBIND_TARBALL)

IPTABLES_NAME		= iptables
IPTABLES_VER		= 1.4.21
IPTABLES_SRC		= $(IPTABLES_NAME)-$(IPTABLES_VER)
IPTABLES_TARBALL	= $(IPTABLES_NAME)-$(IPTABLES_VER).tar.bz2
IPTABLES_SERVER		= http://www.netfilter.org/projects/iptables/files
IPTABLES_URL		= $(IPTABLES_SERVER)/$(IPTABLES_TARBALL)
IPTABLES_DIST		= $(DISTDIR)/$(IPTABLES_TARBALL)

ETHTOOL_NAME		= ethtool
ETHTOOL_VER		= 6.15
ETHTOOL_SRC		= $(ETHTOOL_NAME)-$(ETHTOOL_VER)
ETHTOOL_TARBALL		= $(ETHTOOL_NAME)-$(ETHTOOL_VER).tar.gz
ETHTOOL_SERVER		= http://www.kernel.org/pub/software/network/ethtool
ETHTOOL_URL		= $(ETHTOOL_SERVER)/$(ETHTOOL_TARBALL)
ETHTOOL_DIST		= $(DISTDIR)/$(ETHTOOL_TARBALL)

IW_NAME			= iw
IW_VER			= 6.17
IW_SRC			= $(IW_NAME)-$(IW_VER)
IW_TARBALL		= $(IW_NAME)-$(IW_VER).tar.gz
IW_SERVER		= https://www.kernel.org/pub/software/network/iw
IW_URL			= $(IW_SERVER)/$(IW_TARBALL)
IW_DIST			= $(DISTDIR)/$(IW_TARBALL)

WPASUPP_NAME		= wpa_supplicant
WPASUPP_VER		= 2.10
WPASUPP_SRC		= $(WPASUPP_NAME)-$(WPASUPP_VER)
WPASUPP_TARBALL		= $(WPASUPP_NAME)-$(WPASUPP_VER).tar.gz
WPASUPP_SERVER		= https://w1.fi/releases
WPASUPP_URL		= $(WPASUPP_SERVER)/$(WPASUPP_TARBALL)
WPASUPP_DIST		= $(DISTDIR)/$(WPASUPP_TARBALL)

FIRMWARE_NAME		= linux-firmware
FIRMWARE_SRC		= $(FIRMWARE_NAME)
FIRMWARE_URL		= http://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
FIRMWARE_DIST		= $(DISTDIR)/$(FIRMWARE_NAME).tgz

WIRELESS_REGDB_NAME	= wireless-regdb
WIRELESS_REGDB_SRC	= $(WIRELESS_REGDB_NAME)
WIRELESS_REGDB_URL	= git://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.git
WIRELESS_REGDB_DIST	= $(DISTDIR)/$(WIRELESS_REGDB_NAME).tgz

MAILUTILS_NAME		= mailutils
MAILUTILS_VER		= 3.20
MAILUTILS_SRC		= $(MAILUTILS_NAME)-$(MAILUTILS_VER)
MAILUTILS_TARBALL	= $(MAILUTILS_NAME)-$(MAILUTILS_VER).tar.gz
MAILUTILS_SERVER	= https://ftp.gnu.org/gnu/mailutils
MAILUTILS_URL		= $(MAILUTILS_SERVER)/$(MAILUTILS_TARBALL)
MAILUTILS_DIST		= $(DISTDIR)/$(MAILUTILS_TARBALL)

NANO_NAME		= nano
NANO_VER		= 8.6
NANO_SRC		= $(NANO_NAME)-$(NANO_VER)
NANO_TARBALL		= $(NANO_NAME)-$(NANO_VER).tar.gz
NANO_SERVER		= https://www.nano-editor.org/dist/v8
NANO_URL		= $(NANO_SERVER)/$(NANO_TARBALL)
NANO_DIST		= $(DISTDIR)/$(NANO_TARBALL)

###############################################################################

# These are the subordinate component targets that have to be built before we
# can start populating the root file system tree

COMPONENT_TARGETS	= busybox openssh rpcbind detach force-umount iptables ethtool iw wpasupp mailutils nano firmware regdb noip2 mdnsd install-overlays nupkg entropypump serialnumber

ifeq ($(BOARDBASE), BeagleBone)
COMPONENT_TARGETS	+= config-pin
endif

###############################################################################

# Make initramfs image suitable for building into the Linux kernel

default: initramfs.cpio.gz

###############################################################################

# Download BusyBox source

$(BUSYBOX_DIST):
	wget -nv -P $(DISTDIR) $(BUSYBOX_URL)

# Unpack BusyBox source

$(BUSYBOX_SRC): $(BUSYBOX_DIST)
	tar xjf $(BUSYBOX_DIST)
	cd $(BUSYBOX_SRC) && patch -b -p0 <../busybox.patch
	touch $@

# Configure BusyBox

busybox.menuconfig: $(BUSYBOX_SRC)
	cp busybox.config $(BUSYBOX_SRC)/.config
	$(MAKE) -C $(BUSYBOX_SRC) menuconfig CROSS_COMPILE=$(CROSS_COMPILE)
	$(MAKE) -C $(BUSYBOX_SRC) oldconfig CROSS_COMPILE=$(CROSS_COMPILE)
	cp $(BUSYBOX_SRC)/.config busybox.config

# Build BusyBox

$(BUSYBOX_SRC)/skeleton: $(BUSYBOX_SRC)
	cp busybox.config $(BUSYBOX_SRC)/.config
	$(MAKE) -C $(BUSYBOX_SRC) oldconfig CROSS_COMPILE=$(CROSS_COMPILE)
	$(MAKE) $(MAKEJOBS) -C $(BUSYBOX_SRC) CROSS_COMPILE=$(CROSS_COMPILE) SKIP_STRIP=y
	$(MAKE) -C $(BUSYBOX_SRC) install CROSS_COMPILE=$(CROSS_COMPILE) SKIP_STRIP=y

busybox: $(BUSYBOX_SRC)/skeleton

###############################################################################

# Download OpenSSH source

$(OPENSSH_DIST):
	wget -nv -P $(DISTDIR) $(OPENSSH_URL)

# Unpack OpenSSH source

$(OPENSSH_SRC): $(OPENSSH_DIST)
	tar xzf $(OPENSSH_DIST)
	touch $@

# Build OpenSSH

$(OPENSSH_SRC)/skeleton: $(OPENSSH_SRC)
	cd $(OPENSSH_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --prefix=/usr --sysconfdir=/etc/ssh --with-privsep-user=nobody --with-privsep-path=/var/empty --disable-dsa-keys --disable-strip CC=$(CROSS_COMPILE)gcc CFLAGS=-I$(LIBSINCDIR) LDFLAGS=-L$(LIBSLIBDIR)
	$(MAKE) $(MAKEJOBS) -C $(OPENSSH_SRC)
	$(MAKE) -C $(OPENSSH_SRC) install DESTDIR=skeleton
	rm -rf $(OPENSSH_SRC)/skeleton/usr/share
	rm -rf $(OPENSSH_SRC)/skeleton/var
	touch $@

openssh: $(OPENSSH_SRC)/skeleton

###############################################################################

# Download rpcbind source

$(RPCBIND_DIST):
	wget -nv -O $(RPCBIND_DIST) $(RPCBIND_URL)

# Unpack rpcbind source distribution

$(RPCBIND_SRC): $(RPCBIND_DIST)
	tar xjf $(RPCBIND_DIST)
	touch $@

# Build rpcbind

$(RPCBIND_SRC)/rpcbind: $(RPCBIND_SRC)
	cd $(RPCBIND_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --without-statedir --without-systemdsystemunitdir CC=$(CROSS_COMPILE)gcc TIRPC_CFLAGS=-I$(LIBSINCDIR)/tirpc TIRPC_LIBS=-ltirpc
	$(MAKE) $(MAKEJOBS) -C $(RPCBIND_SRC)
	touch $@

rpcbind: $(RPCBIND_SRC)/rpcbind

###############################################################################

# Build config-pin

ifeq ($(BOARDBASE), BeagleBone)
config-pin: config-pin.c
	$(CROSS_COMPILE)gcc -Wall -o $@ $^
endif

###############################################################################

# Build detach

detach: detach.c
	$(CROSS_COMPILE)gcc -Wall -o $@ $^

###############################################################################

# Build force-umount

force-umount: force-umount.c
	$(CROSS_COMPILE)gcc -Wall -o $@ $^

###############################################################################

# Build noip2

noip2: noip2.c
	$(CROSS_COMPILE)gcc -Wall -o $@ $^

###############################################################################

# Download iptables source

$(IPTABLES_DIST):
	wget -nv -P $(DISTDIR) $(IPTABLES_URL)

# Unpack iptables source

$(IPTABLES_SRC): $(IPTABLES_DIST)
	tar xjf $(IPTABLES_DIST)
	touch $@

# Build iptables

$(IPTABLES_SRC)/skeleton: $(IPTABLES_SRC)
	cd $(IPTABLES_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --prefix=/usr --sysconfdir=/etc --enable-ipv4 --disable-ipv6 --disable-devel --disable-libipq CC=$(CROSS_COMPILE)gcc LDFLAGS=-ldl
	$(MAKE) $(MAKEJOBS) -C $(IPTABLES_SRC)
	$(MAKE) -C $(IPTABLES_SRC) install DESTDIR=$(shell pwd)/$(IPTABLES_SRC)/skeleton
	rm -rf $(IPTABLES_SRC)/skeleton/usr/share
	touch $@

iptables: $(IPTABLES_SRC)/skeleton

###############################################################################

# Download ethtool source

$(ETHTOOL_DIST):
	wget -nv -P $(DISTDIR) $(ETHTOOL_URL)

# Unpack ethtool source

$(ETHTOOL_SRC): $(ETHTOOL_DIST)
	tar xzf $(ETHTOOL_DIST)
	touch $@

# Build ethtool

$(ETHTOOL_SRC)/ethtool: $(ETHTOOL_SRC)
	cd $(ETHTOOL_SRC) ; ./configure $(BUILDOS) $(TARGETOS) CC=$(CROSS_COMPILE)gcc MNL_CFLAGS="-DMuntsOS -I$(LIBSINCDIR)" MNL_LIBS="-L$(LIBSLIBDIR) -lmnl"
	$(MAKE) $(MAKEJOBS) -C $(ETHTOOL_SRC)
	touch $@

ethtool: $(ETHTOOL_SRC)/ethtool

###############################################################################

# Download iw source

$(IW_DIST):
	wget -nv -P $(DISTDIR) $(IW_URL)

# Unpack iw source

$(IW_SRC): $(IW_DIST)
	tar xzf $(IW_DIST)
	touch $@

# Build iw

$(IW_SRC)/iw: $(IW_SRC)
	PKG_CONFIG_PATH=$(LIBSPKGCONFIG) $(MAKE) -C $(IW_SRC) CC=$(CROSS_COMPILE)gcc
	touch $@

iw: $(IW_SRC)/iw

###############################################################################

# Download wpa_supplicant source

$(WPASUPP_DIST):
	wget -nv -P $(DISTDIR) $(WPASUPP_URL)

# Unpack wpa_supplicant source

$(WPASUPP_SRC): $(WPASUPP_DIST)
	tar xzf $(WPASUPP_DIST)
	cp wpa_supplicant.config $(WPASUPP_SRC)/wpa_supplicant/.config
	sed -i 's#@@LIBSINCDIR@@#$(LIBSINCDIR)#g' $(WPASUPP_SRC)/wpa_supplicant/.config
	touch $@

# Build wpa_supplicant

$(WPASUPP_SRC)/wpa_supplicant/wpa_supplicant: $(WPASUPP_SRC)
	$(MAKE) $(MAKEJOBS) -C $(WPASUPP_SRC)/wpa_supplicant CC=$(CROSS_COMPILE)gcc
	touch $@

wpasupp: $(WPASUPP_SRC)/wpa_supplicant/wpa_supplicant

###############################################################################

# Download mailutils source

$(MAILUTILS_DIST):
	wget -nv -P $(DISTDIR) $(MAILUTILS_URL)

# Unpack mailutils source

$(MAILUTILS_SRC): $(MAILUTILS_DIST)
	tar xzf $(MAILUTILS_DIST)
	touch $@

# Build mailutils

$(MAILUTILS_SRC)/mail/mail: $(MAILUTILS_SRC)
	cd $(MAILUTILS_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --sysconfdir=/etc --disable-ipv6 --disable-imap --disable-pop --disable-nntp --disable-mh --disable-maildir --disable-dotmail --disable-smtp --disable-prog --disable-radius --disable-python --disable-cxx --disable-build-servers --disable-build-clients --enable-build-mail --without-fribidi CC=$(CROSS_COMPILE)gcc CFLAGS="-Wno-incompatible-pointer-types" LDFLAGS=-static
	$(MAKE) $(MAKEJOBS) -C $(MAILUTILS_SRC)
	touch $@

mailutils: $(MAILUTILS_SRC)/mail/mail

###############################################################################

# Download nano source

$(NANO_DIST):
	wget -nv -P $(DISTDIR) $(NANO_URL)

# Unpack nano source

$(NANO_SRC): $(NANO_DIST)
	tar xzf $(NANO_DIST)
	touch $@

# Build nano

$(NANO_SRC)/src/nano: $(NANO_SRC)
	cd $(NANO_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --sysconfdir=/etc/ --disable-nls --disable-utf8 CC=$(CROSS_COMPILE)gcc NCURSES_LIBS=-lncursesw
	$(MAKE) -C $(NANO_SRC)/lib
	$(MAKE) -C $(NANO_SRC)/src

nano: $(NANO_SRC)/src/nano

###############################################################################

# Download Linux firmware

$(FIRMWARE_DIST):
	git clone --depth 1 $(FIRMWARE_URL) $(DISTDIR)/$(FIRMWARE_NAME)
	cd $(DISTDIR) ; tar czf $(FIRMWARE_DIST) $(FIRMWARE_NAME)
	rm -rf $(DISTDIR)/$(FIRMWARE_NAME)

# Unpack Linux firmware source distribution

$(FIRMWARE_SRC): $(FIRMWARE_DIST)
	tar xzf $(FIRMWARE_DIST)
	touch $@

firmware: $(FIRMWARE_SRC)

###############################################################################

# Download wireless-regdb

$(WIRELESS_REGDB_DIST):
	git clone --depth 1 $(WIRELESS_REGDB_URL) $(DISTDIR)/$(WIRELESS_REGDB_NAME)
	cd $(DISTDIR) ; tar czf $(WIRELESS_REGDB_DIST) $(WIRELESS_REGDB_NAME)
	rm -rf $(DISTDIR)/$(WIRELESS_REGDB_NAME)

# Unpack wireless-regdb

$(WIRELESS_REGDB_SRC): $(WIRELESS_REGDB_DIST)
	tar xzf $(WIRELESS_REGDB_DIST)
	touch $@

regdb: $(WIRELESS_REGDB_SRC)

###############################################################################

mdnsd: mdnsd.c
	$(MAKE) -C libmdns libtinysvcmdns.a CROSS_COMPILE=$(CROSS_COMPILE)
	$(CROSS_COMPILE)gcc -Wall -Ilibmdns -o $@ $^ -Llibmdns -ltinysvcmdns -lpthread

###############################################################################

install-overlays: install-overlays.c
	$(CROSS_COMPILE)gcc -Wall -o $@ $^

###############################################################################

nupkg:
	$(MAKE) -C nupkg.src CROSS_COMPILE=$(CROSS_COMPILE)

###############################################################################

# Build entropypump

entropypump: entropypump.c
	$(CROSS_COMPILE)gcc -Wall -o $@ $^

###############################################################################

# Build serialnumber

serialnumber: serialnumber.c
	$(CROSS_COMPILE)gcc -Wall $(CFLAGS) -o $@ $^

###############################################################################

# Collect all license/copyright information for distributed binaries into one place

COPYING: $(COMPONENT_TARGETS)
	@cat COPYING.preface					>$@
	@echo ""						>>$@
	@echo "** MuntsOS Embedded Linux distribution:"		>>$@
	@echo ""						>>$@
	@tail -n 24 ../../COPYING				>>$@
	@echo ""						>>$@
	@echo "** Linux Kernel:"				>>$@
	@echo ""						>>$@
	@cat $(KERNEL_SRC)/COPYING				>>$@
	@echo ""						>>$@
	@echo "** Root File System:"				>>$@
	@echo ""						>>$@
	@echo "**** BusyBox:"					>>$@
	@echo ""						>>$@
	@cat $(BUSYBOX_SRC)/LICENSE				>>$@
	@echo ""						>>$@
	@echo "**** ethtool:"					>>$@
	@echo ""						>>$@
	@cat $(ETHTOOL_SRC)/COPYING				>>$@
	@echo ""						>>$@
	@echo "**** iw:"					>>$@
	@echo ""						>>$@
	@cat $(IW_SRC)/COPYING					>>$@
	@echo ""						>>$@
	@echo "**** iptables:"					>>$@
	@echo ""						>>$@
	@cat $(IPTABLES_SRC)/COPYING				>>$@
	@echo ""						>>$@
	@echo "**** libmdns:"					>>$@
	@echo ""						>>$@
	@cat libmdns/LICENSE.txt				>>$@
	@echo "**** mail:"					>>$@
	@cat $(MAILUTILS_SRC)/COPYING				>>$@
	@echo "**** nano:"					>>$@
	@cat $(NANO_SRC)/COPYING				>>$@
	@echo "**** noip2:"					>>$@
	@head -n 20 noip2.c | tail -n 17 | cut -c 4-		>>$@
	@echo "**** OpenSSH:"					>>$@
	@echo ""						>>$@
	@cat $(OPENSSH_SRC)/LICENCE				>>$@
	@echo ""						>>$@
ifneq ($(findstring RaspberryPi, $(BOARDNAME)),)
ifeq ($(GCCARCH), aarch64)
	@echo "**** pinctrl"					>>$@
	@echo ""						>>$@
	@cat pinctrl.LICENSE					>>$@
	@echo ""						>>$@
endif
endif
	@echo "**** regulatory.db:"				>>$@
	@echo ""						>>$@
	@cat $(WIRELESS_REGDB_SRC)/LICENSE			>>$@
	@echo "**** rpcbind:"					>>$@
	@echo ""						>>$@
	@cat $(RPCBIND_SRC)/COPYING				>>$@
	@echo ""						>>$@
	@echo "**** wpa_supplicant:"				>>$@
	@echo ""						>>$@
	@cat $(WPASUPP_SRC)/COPYING				>>$@
	@echo ""						>>$@
ifeq ($(BOARDBASE), BeagleBone)
	@echo "**** config-pin:"				>>$@
	@head -n 23 config-pin.c | tail -n 21 | cut -c 4-	>>$@
endif
	@echo "**** detach:"					>>$@
	@head -n 22 detach.c | tail -n 21 | cut -c 4-		>>$@
	@echo "**** entropypump:"				>>$@
	@head -n 22 entropypump.c | tail -n 21 | cut -c 4-	>>$@
	@echo "**** force-umount:"				>>$@
	@head -n 23 force-umount.c | tail -n 21 | cut -c 4-	>>$@
	@echo "**** nupkg:"					>>$@
	@head -n 22 nupkg.src/main.c | tail -n 21 | cut -c 4-	>>$@
	@echo "**** mdnsd:"					>>$@
	@head -n 22 mdnsd.c | tail -n 21 | cut -c 4-		>>$@
	@echo "**** serialnumber:"				>>$@
	@head -n 22 serialnumber.c | tail -n 21 | cut -c 4-	>>$@
	@echo "** Shared Libraries:"				>>$@
	@echo ""						>>$@
	@cat $(LIBSDIR)/COPYING					>>$@
	@echo ""						>>$@
	@echo "**** libsimpleio:"				>>$@
	@echo ""						>>$@
	@cat /usr/local/share/libsimpleio/doc/COPYING		>>$@
	@sed -i 's/\f//'					$@
	@dos2unix						$@

###############################################################################

# Create root file system tree

initramfs.d: COPYING
	mkdir -p $@/bin
	mkdir -p $@/boot
	mkdir -p $@/cdrom
	mkdir -p $@/dev/pts
	mkdir -p $@/dev/shm
	mkdir -p $@/etc/ssh
	mkdir -p $@/etc/ssl/certs
	mkdir -p $@/lib/modules
	mkdir -p $@/mnt
	mkdir -p $@/proc
	mkdir -p $@/root/.ssh
	ln -s var/run $@/run
	mkdir -p $@/sbin
	mkdir -p $@/sys
	mkdir -p $@/tmp
	mkdir -p $@/umass
	mkdir -p $@/usr/bin
	mkdir -p $@/usr/lib
	mkdir -p $@/usr/libexec
	mkdir -p $@/usr/local/bin
	mkdir -p $@/usr/local/etc
	mkdir -p $@/usr/local/libexec
	mkdir -p $@/usr/local/lib
	mkdir -p $@/usr/local/sbin
	mkdir -p $@/usr/share/sysconfig
	mkdir -p $@/usr/sbin
	mkdir -p $@/var/db
	mkdir -p $@/var/empty
	mkdir -p $@/var/lib/dpkg/info
	mkdir -p $@/var/lock
	mkdir -p $@/var/log
	mkdir -p $@/var/run
	mkdir -p $@/var/spool/cron/crontabs
	mkdir -p $@/www

# Install COPYING

	install -cm 0444 COPYING				$@

# Install BusyBox

	cp -P -p $(BUSYBOX_SRC)/skeleton/bin/*			$@/bin
	cp -P -p $(BUSYBOX_SRC)/skeleton/sbin/*			$@/sbin
	cp -P -p $(BUSYBOX_SRC)/skeleton/usr/bin/*		$@/usr/bin
	cp -P -p $(BUSYBOX_SRC)/skeleton/usr/sbin/*		$@/usr/sbin
	ln -s sbin/init						$@/init

# Install curl

	install -cm 0755 $(LIBSBINDIR)/curl			$@/bin

# Install config-pin

ifeq ($(BOARDBASE), BeagleBone)
	install -cm 0755 config-pin				$@/sbin
endif

# Install detach

	install -cm 0755 detach					$@/usr/sbin

# Install pinctrl

ifneq ($(findstring RaspberryPi, $(BOARDNAME)),)
ifeq ($(GCCARCH), aarch64)
	install -cm 0755 pinctrl				$@/sbin
endif
endif

# Install ethtool

	install -cm 0755 $(ETHTOOL_SRC)/ethtool			$@/usr/sbin

# Install iw

	install -cm 0755 $(IW_SRC)/iw				$@/usr/sbin

# Install force-umount

	install -cm 0755 force-umount				$@/usr/sbin

# Install serialnumber

	install -cm 0755 serialnumber				$@/sbin

# Install iptables

	cp -R -P -p $(IPTABLES_SRC)/skeleton/*			$@

# Install ldconfig

	install -cm 0755 $(LIBSBINDIR)/ldconfig			$@/sbin

# Install ldd

	install -cm 0755 $(LIBSBINDIR)/ldd			$@/usr/bin
	sed -i 's#/bin/bash#/bin/sh#g'				$@/usr/bin/ldd

# Install linklibs

	install -cm 0755 linklibs				$@/usr/sbin

# Install lspkgs

	install -cm 0755 lspkgs					$@/usr/bin

# Install mail

	install -cm 0755 $(MAILUTILS_SRC)/mail/mail		$@/usr/bin

# Install mdnsd

	install -cm 0755 mdnsd					$@/usr/sbin

# Install nano

	install -cm 0755 $(NANO_SRC)/src/nano			$@/usr/bin

# Install netconfig

	install -cm 0755 netconfig				$@/usr/sbin

# Install noip2

	install -cm 0755 noip2					$@/usr/sbin

# Install nupkg

	install -cm 0555 nupkg					$@/usr/bin

# Install openssh

	cp -R -P -p $(OPENSSH_SRC)/skeleton/*			$@
	echo "" >>						$@/etc/ssh/sshd_config
	echo "PermitRootLogin yes" >>				$@/etc/ssh/sshd_config

# Install openssl

	install -cm 0755 $(LIBSBINDIR)/openssl			$@/usr/bin

# Install entropypump

	install -cm 0755 entropypump				$@/usr/sbin

# Install rpcbind

	install -cm 0755 $(RPCBIND_SRC)/rpcbind			$@/usr/sbin

# Install rpcinfo

	install -cm 0755 $(RPCBIND_SRC)/rpcinfo			$@/usr/sbin

# Install sfdisk

	install -cm 0755 $(LIBSSBINDIR)/sfdisk			$@/sbin

# Install sysconfig

	install -cm 0755 sysconfig				$@/usr/sbin

# Install wpa_supplicant

	install -cm 0755 $(WPASUPP_SRC)/wpa_supplicant/wpa_cli	$@/usr/sbin
	install -cm 0755 $(WPASUPP_SRC)/wpa_supplicant/wpa_supplicant $@/usr/sbin

# Create some initial device nodes

	fakeroot -s fakeroot.state mknod			$@/dev/console c 5 1

# Install files to /etc

	echo "publisher=`whoami`@`hostname`"			>$@/etc/publisher
	echo "timestamp=`date`"					>>$@/etc/publisher
	echo "revision=$(REVISION)"				>>$@/etc/publisher
	echo "compiler=`$(CROSS_COMPILE)gcc --version | head -n 1`" >>$@/etc/publisher
	echo "kernelrepo=$(KERNEL_REPO)"			>>$@/etc/publisher
	echo "kernelbranch=$(KERNEL_BRANCH)"			>>$@/etc/publisher
	echo "kerneltreeish=$(KERNEL_TREEISH)"			>>$@/etc/publisher
	echo "kernelcommit=$(shell cat $(KERNEL_COMMIT))"	>>$@/etc/publisher
	install -cm 0444 environment				$@/etc
	install -cm 0444 fstab					$@/etc
	install -cm 0444 group					$@/etc
	install -cm 0444 hidraw.conf				$@/etc
	install -cm 0444 host.conf				$@/etc
	install -cm 0444 hosts					$@/etc
	install -cm 0444 httpd.conf				$@/etc
ifeq ($(BOARDBASE), BeagleBone)
	install -cm 0444 inittab.serial				$@/etc/inittab
else
	install -cm 0444 inittab.vt				$@/etc/inittab
endif
	install -cm 0444 issue					$@/etc
	install -cm 0444 ld.so.conf				$@/etc
	install -cm 0644 mdev.conf				$@/etc
	install -cm 0444 modules				$@/etc
	install -cm 0444 motd					$@/etc
	ln -s /proc/mounts					$@/etc/mtab
	install -cm 0444 $(LIBSETCDIR)/netconfig		$@/etc
	install -cm 0444 network.conf				$@/etc
ifneq ($(findstring Gadget, $(BOARDNAME)),)
	chmod 644						$@/etc/network.conf
	echo ""						    >>	$@/etc/network.conf
	echo "# USB Network Gadget interface configuration" >>  $@/etc/network.conf
	echo ""						    >>	$@/etc/network.conf
	echo "#usb0_address=10.254.254.252"		    >>  $@/etc/network.conf
	echo "#usb0_netmask=255.255.255.248"		    >>  $@/etc/network.conf
	echo "#usb0_peer=10.254.254.253"		    >>	$@/etc/network.conf
	chmod 444						$@/etc/network.conf
endif
ifeq ($(BOARDNAME), "RaspberryPi4")
	chmod 644						$@/etc/network.conf
	echo ""						    >>	$@/etc/network.conf
	echo "# USB Network Gadget interface configuration" >>  $@/etc/network.conf
	echo ""						    >>	$@/etc/network.conf
	echo "#usb0_address=10.254.254.252"		    >>  $@/etc/network.conf
	echo "#usb0_netmask=255.255.255.248"		    >>  $@/etc/network.conf
	echo "#usb0_peer=10.254.254.253"		    >>	$@/etc/network.conf
	chmod 444						$@/etc/network.conf
endif
ifeq ($(BOARDNAME), "RaspberryPi5")
	chmod 644						$@/etc/network.conf
	echo ""						    >>	$@/etc/network.conf
	echo "# USB Network Gadget interface configuration" >>  $@/etc/network.conf
	echo ""						    >>	$@/etc/network.conf
	echo "#usb0_address=10.254.254.252"		    >>  $@/etc/network.conf
	echo "#usb0_netmask=255.255.255.248"		    >>  $@/etc/network.conf
	echo "#usb0_peer=10.254.254.253"		    >>	$@/etc/network.conf
	chmod 444						$@/etc/network.conf
endif
	install -cm 0444 nsswitch.conf				$@/etc
	install -cm 0444 ntp.conf				$@/etc
	install -cm 0444 passwd					$@/etc
	install -cm 0444 profile				$@/etc
	install -cm 0444 /etc/protocols				$@/etc
	install -cm 0755 rc					$@/etc
	sed -i 's/@@BOARDARCH@@/$(BOARDARCH)/g'			$@/etc/rc
	sed -i 's/@@BOARDBASE@@/$(BOARDBASE)/g'			$@/etc/rc
	sed -i 's/@@BOARDNAME@@/$(BOARDNAME)/g'			$@/etc/rc
	sed -i 's/@@TOOLCHAINREVISION@@/$(TOOLCHAIN_REV)/g'	$@/etc/rc
ifeq ($(BOARDBASE), BeagleBone)
	sed -i 's#@@USERLED@@#/sys/class/leds/beaglebone\:green\:usr0#g' $@/etc/rc
endif
ifeq ($(BOARDNAME), BeaglePlay)
	sed -i 's#@@USERLED@@#/sys/class/leds/beaglebone\:green\:usr0#g' $@/etc/rc
endif
ifeq ($(BOARDBASE), OrangePiZero2W)
ifeq ($(KERNEL_BRANCH), 6.1)
	sed -i 's#@@USERLED@@#/sys/class/leds/green_led#g'	$@/etc/rc
else
	sed -i 's#@@USERLED@@#/sys/class/leds/green\:status#g'	$@/etc/rc
endif
endif
ifneq ($(findstring RaspberryPi, $(BOARDNAME)),)
ifeq ($(KERNEL_BRANCH), 5.15)
	sed -i 's#@@USERLED@@#/sys/class/leds/led0#g'		$@/etc/rc
else
	sed -i 's#@@USERLED@@#/sys/class/leds/ACT#g'		$@/etc/rc
endif
endif
	install -cm 0444 ca-certificates.crt			$@/etc/ssl/certs
	install -cm 0444 rpc					$@/etc
	install -cm 0444 services				$@/etc
	install -cm 0400 shadow					$@/etc

# Install files to /lib

	install -cm 0755 $(LIBSLIBDIR)/$(LOADER)		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libc.so.6		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libcrypt.so.1		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libcrypto.so.3 		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libcurl.so.4		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libdl.so.2		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libfdisk.so.1		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libgcc_s.so.1		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libm.so.6		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libmnl.so.0		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libncursesw.so.6		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libnl-3.so.200		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libnl-genl-3.so.200	$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libnsl.so.1		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libnss_dns.so.2		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libnss_files.so.2 	$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libpthread.so.0		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libresolv.so.2		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/librt.so.1		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libsmartcols.so.1	$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libssl.so.3		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libstdc++.so.6		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libtirpc.so.3		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libutil.so.1		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libuuid.so.1		$@/lib
	install -cm 0755 $(LIBSLIBDIR)/libz.so.1		$@/lib

# Install firmware blobs to /lib/firmware

ifeq ($(findstring Gadget, $(BOARDNAME)),)
	# Firmware for the Raspberry Pi Official USB Wireless Adapter
	mkdir -p						$@/lib/firmware/brcm
	install -cm 0644 $(FIRMWARE_SRC)/brcm/brcmfmac43143.bin $@/lib/firmware/brcm
	# Firmware for certain Ralink USB WiFi adapters
	install -cm 0644 $(FIRMWARE_SRC)/rt2870.bin		$@/lib/firmware
	install -cm 0644 $(FIRMWARE_SRC)/rt73.bin		$@/lib/firmware
	# Firmware for certain Realtek USB WiFi adapters
	mkdir -p						$@/lib/firmware/rtlwifi
	install -cm 0644 $(FIRMWARE_SRC)/rtlwifi/rtl8192cufw_TMSC.bin $@/lib/firmware/rtlwifi
endif

ifeq ($(BOARDBASE), BeagleBone)
	# Firmware for the BeagleBone Black Wireless built-in WLAN interface
	mkdir -p						$@/lib/firmware/ti-connectivity
	install -cm 0644 $(FIRMWARE_SRC)/ti-connectivity/wl18xx-fw-4.bin $@/lib/firmware/ti-connectivity
	install -cm 0644 wl18xx-conf.bin			$@/lib/firmware/ti-connectivity
endif

ifeq ($(BOARDBASE), BeaglePlay)
	# Firmware for the BeagleBone Black Wireless built-in WLAN interface
	mkdir -p						$@/lib/firmware/ti-connectivity
	install -cm 0644 $(FIRMWARE_SRC)/ti-connectivity/wl18xx-fw-4.bin $@/lib/firmware/ti-connectivity
	install -cm 0644 wl18xx-conf.bin			$@/lib/firmware/ti-connectivity
endif

ifeq ($(BOARDBASE), OrangePiZero2W)
	# Firmware for the Orange Pi Zero 2W Wireless built-in WLAN interface
	mkdir -p										$@/lib/firmware
	install -cm 0644 uwe5622/*								$@/lib/firmware
endif

ifneq ($(findstring RaspberryPi1, $(BOARDNAME)),)
	# Firmware for the Raspberry Pi Zero Wireless built-in WLAN interface
	mkdir -p										$@/lib/firmware/brcm
	install -cm 0644 $(FIRMWARE_SRC)/cypress/cyfmac43430-sdio.bin				$@/lib/firmware/brcm/brcmfmac43430-sdio.bin
	install -cm 0644 $(FIRMWARE_SRC)/cypress/cyfmac43430-sdio.clm_blob			$@/lib/firmware/brcm/brcmfmac43430-sdio.clm_blob
	install -cm 0644 $(FIRMWARE_SRC)/brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.txt	$@/lib/firmware/brcm/brcmfmac43430-sdio.txt
endif

ifneq ($(findstring RaspberryPi2, $(BOARDNAME)),)
	# Firmware for the Raspberry Pi 3 Model B built-in WLAN interface
	mkdir -p										$@/lib/firmware/brcm
	install -cm 0644 $(FIRMWARE_SRC)/cypress/cyfmac43430-sdio.bin				$@/lib/firmware/brcm/brcmfmac43430-sdio.bin
	install -cm 0644 $(FIRMWARE_SRC)/cypress/cyfmac43430-sdio.clm_blob			$@/lib/firmware/brcm/brcmfmac43430-sdio.clm_blob
	install -cm 0644 $(FIRMWARE_SRC)/brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.txt	$@/lib/firmware/brcm/brcmfmac43430-sdio.txt
	# Firmware for the Raspberry Pi 3 Model A+ and B+ built-in WLAN interface
	install -cm 0644 $(FIRMWARE_SRC)/cypress/cyfmac43455-sdio.bin				$@/lib/firmware/brcm/brcmfmac43455-sdio.bin
	install -cm 0644 $(FIRMWARE_SRC)/cypress/cyfmac43455-sdio.clm_blob			$@/lib/firmware/brcm/brcmfmac43455-sdio.clm_blob
	install -cm 0644 $(FIRMWARE_SRC)/brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.txt	$@/lib/firmware/brcm/brcmfmac43455-sdio.txt
	# Firmware for the Raspberry Pi Zero 2 built-in WLAN interface
	install -cm 0644 brcm/brcmfmac43436*zero-2-w*						$@/lib/firmware/brcm
endif

ifneq ($(findstring RaspberryPi3, $(BOARDNAME)),)
	# Firmware for the Raspberry Pi 3 Model B built-in WLAN interface
	mkdir -p										$@/lib/firmware/brcm
	install -cm 0644 $(FIRMWARE_SRC)/cypress/cyfmac43430-sdio.bin				$@/lib/firmware/brcm/brcmfmac43430-sdio.bin
	install -cm 0644 $(FIRMWARE_SRC)/cypress/cyfmac43430-sdio.clm_blob			$@/lib/firmware/brcm/brcmfmac43430-sdio.clm_blob
	install -cm 0644 $(FIRMWARE_SRC)/brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.txt	$@/lib/firmware/brcm/brcmfmac43430-sdio.txt
	# Firmware for the Raspberry Pi 3 Model A+ and B+ built-in WLAN interface
	install -cm 0644 $(FIRMWARE_SRC)/cypress/cyfmac43455-sdio.bin				$@/lib/firmware/brcm/brcmfmac43455-sdio.bin
	install -cm 0644 $(FIRMWARE_SRC)/cypress/cyfmac43455-sdio.clm_blob			$@/lib/firmware/brcm/brcmfmac43455-sdio.clm_blob
	install -cm 0644 $(FIRMWARE_SRC)/brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.txt	$@/lib/firmware/brcm/brcmfmac43455-sdio.txt
	# Firmware for the Raspberry Pi Zero 2 W built-in WLAN interface
	install -cm 0644 brcm/brcmfmac43430*zero-2-w*						$@/lib/firmware/brcm
endif

ifneq ($(findstring RaspberryPi4, $(BOARDNAME)),)
	# Firmware for the Raspberry Pi 4 Model B built-in WLAN interface
	mkdir -p										$@/lib/firmware/brcm
	install -cm 0644 $(FIRMWARE_SRC)/cypress/cyfmac43455-sdio.bin				$@/lib/firmware/brcm/brcmfmac43455-sdio.bin
	install -cm 0644 $(FIRMWARE_SRC)/cypress/cyfmac43455-sdio.clm_blob			$@/lib/firmware/brcm/brcmfmac43455-sdio.clm_blob
	install -cm 0644 $(FIRMWARE_SRC)/brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.txt	$@/lib/firmware/brcm/brcmfmac43455-sdio.txt
	sed -i 's/0x48200100/0x44200100/g'							$@/lib/firmware/brcm/brcmfmac43455-sdio.txt
endif

ifneq ($(findstring RaspberryPi5, $(BOARDNAME)),)
	# Firmware for the Raspberry Pi build-in WLAN interface
	mkdir -p										$@/lib/firmware/brcm
	install -cm 0644 $(FIRMWARE_SRC)/cypress/cyfmac43455-sdio.bin				$@/lib/firmware/brcm/brcmfmac43455-sdio.bin
	install -cm 0644 $(FIRMWARE_SRC)/cypress/cyfmac43455-sdio.clm_blob			$@/lib/firmware/brcm/brcmfmac43455-sdio.clm_blob
	install -cm 0644 $(FIRMWARE_SRC)/brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.txt	$@/lib/firmware/brcm/brcmfmac43455-sdio.txt
	sed -i 's/0x48200100/0x44200100/g'							$@/lib/firmware/brcm/brcmfmac43455-sdio.txt
endif

	install -cm 0644 $(WIRELESS_REGDB_SRC)/regulatory.db	$@/lib/firmware
	install -cm 0644 $(WIRELESS_REGDB_SRC)/regulatory.db.p7s $@/lib/firmware

# Install kernel modules

	cp -R -P -p $(KERNEL_WORK)/modules/lib/modules		$@/lib
	find $@/lib/modules -type d -name '*MuntsOS' -exec ln -s modules.dep.bb {}/modules.dep ";"

# Install files to /root

	touch							$@/root/.ssh/authorized_keys
	chmod 400						$@/root/.ssh/authorized_keys

# Install files to /usr/lib

	install -cm 0755 $(LIBSLIBDIR)/libsimpleio.so		$@/usr/lib

# Install files to /usr/libexec

	install -cm 0555 autoexec.script			$@/usr/libexec
	install -cm 0555 ifplugd.script				$@/usr/libexec
	install -cm 0555 install-overlays			$@/usr/libexec
	install -cm 0555 mdev-helper-hidraw			$@/usr/libexec
	install -cm 0555 mdev-helper-net			$@/usr/libexec
	install -cm 0555 mdev-helper-pwm			$@/usr/libexec
	install -cm 0755 netstart.script			$@/usr/libexec
	install -cm 0755 netstop.script				$@/usr/libexec
	install -cm 0755 udhcpc.script				$@/usr/libexec
ifeq ($(BOARDNAME), BeaglePlay)
	install -cm 0755 beagleplay-install-muntsos-emmc	$@/usr/libexec/install-muntsos-emmc
	install -cm 0755 beagleplay-install-uboot-emmc		$@/usr/libexec/install-uboot-emmc
endif
	mkdir -p						$@/usr/libexec/services/ttyGS0
	echo "#!/bin/sh" >					$@/usr/libexec/services/ttyGS0/run
	echo "exec /sbin/getty -h -L ttyGS0 115200 vt100" >>	$@/usr/libexec/services/ttyGS0/run
	chmod 555						$@/usr/libexec/services/ttyGS0/run

# Install files to /usr/share

	cp -R -P -p $(LIBSSHAREDIR)/terminfo			$@/usr/share

ifeq ($(BOARDBASE), BeagleBone)
	install -cm 0444 pinmux.*Beagle*			$@/usr/share/sysconfig
	install -cm 0444 overlays.*Beagle*			$@/usr/share/sysconfig
endif

ifneq ($(findstring RaspberryPi, $(BOARDNAME)),)
ifeq ($(GCCARCH), aarch64)
	install -cm 0444 pinmux.$(BOARDNAME)			$@/usr/share/sysconfig
endif
endif

# Install files to /var

	touch							$@/var/lib/dpkg/status
	touch							$@/var/log/lastlog
	touch							$@/var/spool/cron/crontabs/root

# Install files to /www

	sed s/@@BOARDNAME@@/$(BOARDNAME)/g <index.html.target >	$@/www/index.html

# Remove pkgconfig

	rm -rf							$@/usr/lib/pkgconfig

# Perform board dependent customizations

ifeq ($(BOARDBASE), BeagleBone)
	echo ""							>>$@/etc/mdev.conf
	echo "# $(BOARDNAME) devices"				>>$@/etc/mdev.conf
	echo "ttyS1           root:gpio 660"			>>$@/etc/mdev.conf
	echo "ttyS2           root:gpio 660"			>>$@/etc/mdev.conf
	echo "ttyS3           root:gpio 660"			>>$@/etc/mdev.conf
	echo "ttyS4           root:gpio 660"			>>$@/etc/mdev.conf
	echo "ttyS5           root:gpio 660"			>>$@/etc/mdev.conf
endif

ifeq ($(BOARDBASE), OrangePiZero2W)

	echo ""							>>$@/etc/mdev.conf
	echo "# $(BOARDNAME) devices"				>>$@/etc/mdev.conf
	echo "ttyS1           root:gpio 660"			>>$@/etc/mdev.conf
	echo "ttyS2           root:gpio 660"			>>$@/etc/mdev.conf
	echo "ttyS3           root:gpio 660"			>>$@/etc/mdev.conf
endif

ifneq ($(findstring RaspberryPi, $(BOARDNAME)),)
	echo ""							>>$@/etc/mdev.conf
	echo "# $(BOARDNAME) devices"				>>$@/etc/mdev.conf
	echo "ttyAMA0         root:gpio 660"			>>$@/etc/mdev.conf
endif

# Create shared library directory symlinks

ifneq ($(WORDSIZE), 32)
	ln -s lib						$@/lib$(WORDSIZE)
	ln -s lib						$@/usr/lib$(WORDSIZE)
	ln -s lib						$@/usr/local/lib$(WORDSIZE)
endif

# Strip program files to save space

	find $@/bin		-type f -exec $(CROSS_COMPILE)strip {} ";"
	find $@/sbin		-type f -exec $(CROSS_COMPILE)strip {} ";"
	find $@/usr/bin		-type f -exec $(CROSS_COMPILE)strip {} ";"
	find $@/usr/libexec	-type f -exec $(CROSS_COMPILE)strip {} ";"
	find $@/usr/sbin	-type f -exec $(CROSS_COMPILE)strip {} ";"

# Strip shared library files to save space

	find $@/lib $@/usr/lib -type f -name '*.so'   -exec $(CROSS_COMPILE)strip {} ";"
	find $@/lib $@/usr/lib -type f -name '*.so.*' -exec $(CROSS_COMPILE)strip {} ";"

# Remove unnecessary .la files

	find $@ -name '*.la' -exec rm {} ";"

# Fixup permissions

	chmod 444						$@/etc/mdev.conf
	chmod 444						$@/etc/publisher
	chmod 555						$@/etc/rc
	chmod 555						$@/etc/ssh
	chmod 500						$@/root/.ssh
	chmod 1777						$@/tmp
	chmod 400						$@/var/spool/cron/crontabs/root
	chmod -R -w						$@/bin $@/lib $@/sbin $@/usr $@/www

# Touch everything to set time stamps

	find $@ -type d -exec touch -r $@ {} ";"
	find $@ -type f -exec touch -r $@ {} ";"

###############################################################################

# Create root file system cpio archive

initramfs.cpio.gz: initramfs.d
	cd initramfs.d && find * >../initramfs.manifest
	cd initramfs.d && fakeroot -i ../fakeroot.state cpio -H newc -o -v -O ../initramfs.cpio -R root.root <../initramfs.manifest
	chmod -R u+w initramfs.d
	rm fakeroot.state
	gzip initramfs.cpio
	touch $@

###############################################################################

# Download source distributions

download: $(BUSYBOX_DIST) $(OPENSSH_DIST) $(RPCBIND_DIST) $(IPTABLES_DIST) $(ETHTOOL_DIST) $(WPASUPP_DIST) $(MAILUTILS_DIST) $(NANO_DIST) $(FIRMWARE_DIST)

###############################################################################

# Clean out working files

clean:
	rm -rf fakeroot.state initramfs.cpio initramfs.cpio.gz initramfs.manifest initramfs.d

reallyclean: clean
	$(MAKE) -C libmdns clean
	rm -rf $(BUSYBOX_SRC)
	rm -rf $(OPENSSH_SRC)
	rm -rf $(RPCBIND_SRC)
	rm -rf $(IPTABLES_SRC)
	rm -rf $(ETHTOOL_SRC)
	rm -rf $(IW_SRC)
	rm -rf $(WPASUPP_SRC)
	rm -rf $(MAILUTILS_SRC)
	rm -rf $(NANO_SRC)
	rm -rf $(FIRMWARE_SRC)
	rm -rf $(WIRELESS_REGDB_SRC)
	rm -f COPYING
ifeq ($(BOARDBASE), BeagleBone)
	rm -f config-pin
endif
	rm -f detach
	rm -f entropypump
	rm -f force-umount
	rm -f serialnumber
	rm -f install-overlays
	rm -f mdnsd
	rm -f noip2
	rm -f nupkg

distclean: reallyclean
	rm -f $(BUSYBOX_DIST)
	rm -f $(OPENSSH_DIST)
	rm -f $(RPCBIND_DIST)
	rm -f $(IPTABLES_DIST)
	rm -f $(ETHTOOL_DIST)
	rm -f $(IW_DIST)
	rm -f $(WPASUPP_DIST)
	rm -f $(MAILUTILS_DIST)
	rm -f $(NANO_DIST)
	rm -f $(FIRMWARE_DIST)
	rm -f $(WIRELESS_REGDB_DIST)
