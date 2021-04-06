# Make root file system for an embedded Linux system

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

MUNTSOS			?= ../..
BOARDNAME		?= UNDEFINED
MAKEJOBS		?= -j 2

include $(MUNTSOS)/include/$(BOARDNAME).mk

BUILDOS			= --build=`uname -m`
TARGETOS		= --host=$(CONFIGURE_NAME)

BUSYBOX_VERSION		= 1.32.1
BUSYBOX_NAME		= busybox
BUSYBOX_SRC		= $(BUSYBOX_NAME)-$(BUSYBOX_VERSION)
BUSYBOX_TARBALL		= $(BUSYBOX_NAME)-$(BUSYBOX_VERSION).tar.bz2
BUSYBOX_SERVER		= http://www.busybox.net/downloads
BUSYBOX_URL		= $(BUSYBOX_SERVER)/$(BUSYBOX_TARBALL)
BUSYBOX_DIST		= $(TEMP)/$(BUSYBOX_TARBALL)

OPENSSH_NAME		= openssh
OPENSSH_VER		= 8.5p1
OPENSSH_SRC		= $(OPENSSH_NAME)-$(OPENSSH_VER)
OPENSSH_TARBALL		= $(OPENSSH_SRC).tar.gz
OPENSSH_SERVER		= http://ftp3.usa.openbsd.org/pub/OpenBSD/OpenSSH/portable
OPENSSH_URL		= $(OPENSSH_SERVER)/$(OPENSSH_TARBALL)
OPENSSH_DIST		= $(TEMP)/$(OPENSSH_TARBALL)

RPCBIND_NAME		= rpcbind
RPCBIND_VER		= 1.2.5
RPCBIND_SRC		= $(RPCBIND_NAME)-$(RPCBIND_VER)
RPCBIND_TARBALL		= $(RPCBIND_NAME)-$(RPCBIND_VER).tar.bz2
RPCBIND_SERVER		= https://downloads.sourceforge.net/project/rpcbind/rpcbind
RPCBIND_URL		= $(RPCBIND_SERVER)/$(RPCBIND_VER)/$(RPCBIND_TARBALL)
RPCBIND_DIST		= $(TEMP)/$(RPCBIND_TARBALL)

IPTABLES_NAME		= iptables
IPTABLES_VER		= 1.4.21
IPTABLES_SRC		= $(IPTABLES_NAME)-$(IPTABLES_VER)
IPTABLES_TARBALL	= $(IPTABLES_NAME)-$(IPTABLES_VER).tar.bz2
IPTABLES_SERVER		= http://www.netfilter.org/projects/iptables/files
IPTABLES_URL		= $(IPTABLES_SERVER)/$(IPTABLES_TARBALL)
IPTABLES_DIST		= $(TEMP)/$(IPTABLES_TARBALL)

ETHTOOL_NAME		= ethtool
ETHTOOL_VER		= 5.10
ETHTOOL_SRC		= $(ETHTOOL_NAME)-$(ETHTOOL_VER)
ETHTOOL_TARBALL		= $(ETHTOOL_NAME)-$(ETHTOOL_VER).tar.gz
ETHTOOL_SERVER		= http://www.kernel.org/pub/software/network/ethtool
ETHTOOL_URL		= $(ETHTOOL_SERVER)/$(ETHTOOL_TARBALL)
ETHTOOL_DIST		= $(TEMP)/$(ETHTOOL_TARBALL)

WPASUPP_NAME		= wpa_supplicant
WPASUPP_VER		= 2.9
WPASUPP_SRC		= $(WPASUPP_NAME)-$(WPASUPP_VER)
WPASUPP_TARBALL		= $(WPASUPP_NAME)-$(WPASUPP_VER).tar.gz
WPASUPP_SERVER		= https://w1.fi/releases
WPASUPP_URL		= $(WPASUPP_SERVER)/$(WPASUPP_TARBALL)
WPASUPP_DIST		= $(TEMP)/$(WPASUPP_TARBALL)

FIRMWARE_NAME		= linux-firmware
FIRMWARE_SRC		= $(FIRMWARE_NAME)
FIRMWARE_URL		= http://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
FIRMWARE_DIST		= $(TEMP)/$(FIRMWARE_NAME).tgz

WIRELESS_REGDB_NAME	= wireless-regdb
WIRELESS_REGDB_SRC	= $(WIRELESS_REGDB_NAME)
WIRELESS_REGDB_URL	= git://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.git
WIRELESS_REGDB_DIST	= $(TEMP)/$(WIRELESS_REGDB_NAME).tgz

MAILUTILS_NAME		= mailutils
MAILUTILS_VER		= 3.12
MAILUTILS_SRC		= $(MAILUTILS_NAME)-$(MAILUTILS_VER)
MAILUTILS_TARBALL	= $(MAILUTILS_NAME)-$(MAILUTILS_VER).tar.gz
MAILUTILS_SERVER	= https://ftp.gnu.org/gnu/mailutils
MAILUTILS_URL		= $(MAILUTILS_SERVER)/$(MAILUTILS_TARBALL)
MAILUTILS_DIST		= $(TEMP)/$(MAILUTILS_TARBALL)

NANO_NAME		= nano
NANO_VER		= 5.6.1
NANO_SRC		= $(NANO_NAME)-$(NANO_VER)
NANO_TARBALL		= $(NANO_NAME)-$(NANO_VER).tar.gz
NANO_SERVER		= https://www.nano-editor.org/dist/v5
NANO_URL		= $(NANO_SERVER)/$(NANO_TARBALL)
NANO_DIST		= $(TEMP)/$(NANO_TARBALL)

###############################################################################

# These are the subordinate component targets that have to be built before we
# can start populating the root file system tree

COMPONENT_TARGETS	= modules busybox openssh rpcbind force-umount iptables ethtool wpasupp mailutils nano firmware regdb noip2 mdnsd install-overlays nupkg entropypump serialnumber

ifneq ($(findstring Beagle, $(BOARDNAME)),)
COMPONENT_TARGETS	+= config-pin
endif

###############################################################################

# Make initramfs image suitable for building into the Linux kernel

default: initramfs.cpio.gz

###############################################################################

# Build kernel modules

modules:
	$(MAKE) -C ../kernel modules.done

###############################################################################

# Download BusyBox source

$(BUSYBOX_DIST):
	wget -nv -P $(TEMP) $(BUSYBOX_URL)

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
	$(MAKE) -C $(BUSYBOX_SRC) oldconfig CROSS_COMPILE=$(CROSS_COMPILE) GCCSYSROOT=$(GCCSYSROOT)
	$(MAKE) $(MAKEJOBS) -C $(BUSYBOX_SRC) CROSS_COMPILE=$(CROSS_COMPILE) GCCSYSROOT=$(GCCSYSROOT) SKIP_STRIP=y
	$(MAKE) -C $(BUSYBOX_SRC) install CROSS_COMPILE=$(CROSS_COMPILE) GCCSYSROOT=$(GCCSYSROOT) SKIP_STRIP=y

busybox: $(BUSYBOX_SRC)/skeleton

###############################################################################

# Download OpenSSH source

$(OPENSSH_DIST):
	wget -nv -P $(TEMP) $(OPENSSH_URL)

# Unpack OpenSSH source

$(OPENSSH_SRC): $(OPENSSH_DIST)
	tar xzf $(OPENSSH_DIST)
	touch $@

# Build OpenSSH

$(OPENSSH_SRC)/skeleton: $(OPENSSH_SRC)
	cd $(OPENSSH_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --prefix=/usr --sysconfdir=/etc/ssh --with-privsep-user=nobody --with-privsep-path=/var/empty --disable-strip CC=$(CROSS_COMPILE)gcc
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
	cd $(RPCBIND_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --without-statedir --without-systemdsystemunitdir CC=$(CROSS_COMPILE)gcc TIRPC_CFLAGS=-I$(GCCSYSROOT)/usr/include/tirpc TIRPC_LIBS=-ltirpc
	$(MAKE) $(MAKEJOBS) -C $(RPCBIND_SRC)
	touch $@

rpcbind: $(RPCBIND_SRC)/rpcbind

###############################################################################

# Build config-pin

ifneq ($(findstring Beagle, $(BOARDNAME)),)
config-pin: config-pin.c
	$(CROSS_COMPILE)gcc -Wall -o $@ $^
endif

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
	wget -nv -P $(TEMP) $(IPTABLES_URL)

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
	wget -nv -P $(TEMP) $(ETHTOOL_URL)

# Unpack ethtool source

$(ETHTOOL_SRC): $(ETHTOOL_DIST)
	tar xzf $(ETHTOOL_DIST)
	touch $@

# Build ethtool

$(ETHTOOL_SRC)/ethtool: $(ETHTOOL_SRC)
	cd $(ETHTOOL_SRC) ; ./configure $(BUILDOS) $(TARGETOS) CC=$(CROSS_COMPILE)gcc MNL_CFLAGS="-DMuntsOS" MNL_LIBS="-lmnl"
	$(MAKE) $(MAKEJOBS) -C $(ETHTOOL_SRC)
	touch $@

ethtool: $(ETHTOOL_SRC)/ethtool

###############################################################################

# Download wpa_supplicant source

$(WPASUPP_DIST):
	wget -nv -P $(TEMP) $(WPASUPP_URL)

# Unpack wpa_supplicant source

$(WPASUPP_SRC): $(WPASUPP_DIST)
	tar xzf $(WPASUPP_DIST)
	cp wpa_supplicant.config $(WPASUPP_SRC)/wpa_supplicant/.config
	sed -i 's#@@LIBNL3DIR@@#$(GCCSYSROOT)/usr/include/libnl3#g' $(WPASUPP_SRC)/wpa_supplicant/.config
	touch $@

# Build wpa_supplicant

$(WPASUPP_SRC)/wpa_supplicant/wpa_supplicant: $(WPASUPP_SRC)
	env PKG_CONFIG_PATH=$(GCCSYSROOT)/usr/lib/pkgconfig $(MAKE) $(MAKEJOBS) -C $(WPASUPP_SRC)/wpa_supplicant CC=$(CROSS_COMPILE)gcc
	touch $@

wpasupp: $(WPASUPP_SRC)/wpa_supplicant/wpa_supplicant

###############################################################################

# Download mailutils source

$(MAILUTILS_DIST):
	wget -nv -P $(TEMP) $(MAILUTILS_URL)

# Unpack mailutils source

$(MAILUTILS_SRC): $(MAILUTILS_DIST)
	tar xzf $(MAILUTILS_DIST)
	touch $@

# Build mailutils

$(MAILUTILS_SRC)/mail/mail: $(MAILUTILS_SRC)
	cd $(MAILUTILS_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --sysconfdir=/etc --disable-ipv6 --disable-imap --disable-pop --disable-nntp --disable-mh --disable-maildir --disable-dotmail --disable-smtp --disable-prog --disable-radios --disable-python --disable-cxx --disable-build-servers --disable-build-clients --enable-build-mail CC=$(CROSS_COMPILE)gcc LDFLAGS=-static
	$(MAKE) $(MAKEJOBS) -C $(MAILUTILS_SRC)
	touch $@

mailutils: $(MAILUTILS_SRC)/mail/mail

###############################################################################

# Download nano source

$(NANO_DIST):
	wget -nv -P $(TEMP) $(NANO_URL)

# Unpack nano source

$(NANO_SRC): $(NANO_DIST)
	tar xzf $(NANO_DIST)
	touch $@

# Build nano

$(NANO_SRC)/src/nano: $(NANO_SRC)
	cd $(NANO_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --sysconfdir=/etc/ --disable-nls --disable-utf8 CC=$(CROSS_COMPILE)gcc NCURSES_LIBS=-lncurses
	$(MAKE) -C $(NANO_SRC)/lib
	$(MAKE) -C $(NANO_SRC)/src

nano: $(NANO_SRC)/src/nano

###############################################################################

# Download Linux firmware

$(FIRMWARE_DIST):
	git clone $(FIRMWARE_URL) $(TEMP)/$(FIRMWARE_NAME)
	cd $(TEMP) ; tar czf $(FIRMWARE_DIST) $(FIRMWARE_NAME)
	rm -rf $(TEMP)/$(FIRMWARE_NAME)

# Unpack Linux firmware source distribution

$(FIRMWARE_SRC): $(FIRMWARE_DIST)
	tar xzf $(FIRMWARE_DIST)
	touch $@

firmware: $(FIRMWARE_SRC)

###############################################################################

# Download wireless-regdb

$(WIRELESS_REGDB_DIST):
	git clone $(WIRELESS_REGDB_URL) $(TEMP)/$(WIRELESS_REGDB_NAME)
	cd $(TEMP) ; tar czf $(WIRELESS_REGDB_DIST) $(WIRELESS_REGDB_NAME)
	rm -rf $(TEMP)/$(WIRELESS_REGDB_NAME)

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
	@cat ../kernel/$(KERNEL_NAME)/COPYING			>>$@
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
ifneq ($(findstring Beagle, $(BOARDNAME)),)
	@echo "**** config-pin:"				>>$@
	@head -n 23 config-pin.c | tail -n 21 | cut -c 4-	>>$@
endif
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
	@echo "** glibc:"                                       >>$@
	@echo ""						>>$@
	@cat $(TOOLCHAIN_DIR)/share/licenses/glibc/COPYING	>>$@
	@echo ""						>>$@
	@echo "** Shared Libraries:"				>>$@
	@echo ""						>>$@
	@cat $(GCCSYSROOT)/usr/COPYING				>>$@
	@echo ""						>>$@
	@echo "**** libsimpleio:"				>>$@
	@echo ""						>>$@
	@cat $(GCCSYSROOT)/usr/share/doc/libsimpleio/COPYING	>>$@
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
	mkdir -p $@/lib/modules
	mkdir -p $@/mnt
	mkdir -p $@/proc
	mkdir -p $@/root/.ssh
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

# Install config-pin

ifneq ($(findstring Beagle, $(BOARDNAME)),)
	install -cm 0755 config-pin				$@/sbin
endif

# Install ethtool

	install -cm 0755 $(ETHTOOL_SRC)/ethtool			$@/usr/sbin

# Install force-umount

	install -cm 0755 force-umount				$@/usr/sbin

# Install serialnumber

	install -cm 0755 serialnumber				$@/sbin

# Install iptables

	cp -R -P -p $(IPTABLES_SRC)/skeleton/*			$@

# Install ldconfig

	install -cm 0755 $(GCCSYSROOT)/sbin/ldconfig		$@/sbin
	if [ -f $(GCCSYSROOT)/sbin/ldconfig.real ]; then install -cm 0755 $(GCCSYSROOT)/sbin/ldconfig.real $@/sbin ; fi

# Install ldd

	install -cm 0755 $(GCCSYSROOT)/usr/bin/ldd		$@/usr/bin
	sed -i 's/bash/sh/g'					$@/usr/bin/ldd

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

	install -cm 0755 $(GCCSYSROOT)/usr/bin/openssl		$@/usr/bin

# Install entropypump

	install -cm 0755 entropypump				$@/usr/sbin

# Install rpcbind

	install -cm 0755 $(RPCBIND_SRC)/rpcbind			$@/usr/sbin

# Install rpcinfo

	install -cm 0755 $(RPCBIND_SRC)/rpcinfo			$@/usr/sbin

# Install sysconfig

	install -cm 0755 sysconfig				$@/usr/sbin

# Install wpa_supplicant

	install -cm 0755 $(WPASUPP_SRC)/wpa_supplicant/wpa_cli	$@/usr/sbin
	install -cm 0755 $(WPASUPP_SRC)/wpa_supplicant/wpa_supplicant $@/usr/sbin

# Create some initial device nodes

	fakeroot -s fakeroot.state mknod			$@/dev/console c 5 1

# Install files to /etc

	echo "publisher=`whoami`@`hostname`"			>$@/etc/publisher
	echo "revision=$(REVISION)"				>>$@/etc/publisher
	echo "compiler=`$(CROSS_COMPILE)gcc --version | head -n 1`" >>$@/etc/publisher
	echo "timestamp=`date`"					>>$@/etc/publisher
	install -cm 0400 ssh_host_dsa_key			$@/etc/ssh
	install -cm 0400 ssh_host_ecdsa_key			$@/etc/ssh
	install -cm 0400 ssh_host_ed25519_key			$@/etc/ssh
	install -cm 0400 ssh_host_rsa_key			$@/etc/ssh
	install -cm 0444 environment				$@/etc
	install -cm 0444 fstab					$@/etc
	install -cm 0444 group					$@/etc
	install -cm 0444 hidraw.conf				$@/etc
	install -cm 0444 host.conf				$@/etc
	install -cm 0444 hosts					$@/etc
	install -cm 0444 httpd.conf				$@/etc
	install -cm 0444 inittab				$@/etc
	install -cm 0444 issue					$@/etc
	install -cm 0444 ld.so.conf				$@/etc
	install -cm 0644 mdev.conf				$@/etc
	install -cm 0444 motd					$@/etc
	ln -s /proc/mounts					$@/etc/mtab
	install -cm 0444 $(GCCSYSROOT)/usr/etc/netconfig	$@/etc
	install -cm 0444 network.conf				$@/etc
	install -cm 0444 nsswitch.conf				$@/etc
	install -cm 0444 ntp.conf				$@/etc
	install -cm 0444 passwd					$@/etc
	install -cm 0444 profile				$@/etc
	install -cm 0444 /etc/protocols				$@/etc
	install -cm 0755 rc					$@/etc
	sed -i 's/@@BOARDNAME@@/$(BOARDNAME)/g'			$@/etc/rc
	sed -i 's/@@BOARDBASE@@/$(BOARDBASE)/g'			$@/etc/rc
ifneq ($(findstring RaspberryPi, $(BOARDNAME)),)
	sed -i '/mount -a/a if [ -f /sys/class/leds/led1/brightness ]; then echo 255 >/sys/class/leds/led1/brightness ; fi' $@/etc/rc
	sed -i '/mount -a/G'					$@/etc/rc
	sed -i '/mount -a/a # Turn on the power LED, if it has been changed to led1' $@/etc/rc
	sed -i '/mount -a/G'					$@/etc/rc
endif
	install -cm 0444 rpc					$@/etc
	install -cm 0444 services				$@/etc
	install -cm 0400 shadow					$@/etc

# Install files to /lib

	install -cm 0755 $(GCCLDLINUX)				$@/lib
	install -cm 0755 $(GCCLIBDIR)/libgcc_s.so.1		$@/lib
	install -cm 0755 $(GCCLIBDIR)/libstdc++.so.6		$@/lib
	install -cm 0755 $(GCCSYSROOT)/lib/libc.so.6		$@/lib
	install -cm 0755 $(GCCSYSROOT)/lib/libcrypt.so.1	$@/lib
	install -cm 0755 $(GCCSYSROOT)/lib/libdl.so.2		$@/lib
	install -cm 0755 $(GCCSYSROOT)/lib/libm.so.6		$@/lib
	install -cm 0755 $(GCCSYSROOT)/lib/libnsl.so.1		$@/lib
	install -cm 0755 $(GCCSYSROOT)/lib/libnss_dns.so.2	$@/lib
	install -cm 0755 $(GCCSYSROOT)/lib/libnss_files.so.2 	$@/lib
	install -cm 0755 $(GCCSYSROOT)/lib/libpthread.so.0	$@/lib
	install -cm 0755 $(GCCSYSROOT)/lib/libresolv.so.2	$@/lib
	install -cm 0755 $(GCCSYSROOT)/lib/librt.so.1		$@/lib
	install -cm 0755 $(GCCSYSROOT)/lib/libutil.so.1		$@/lib
	install -cm 0755 $(GCCSYSROOT)/usr/lib/libcrypto.so.1.1 $@/lib
	install -cm 0755 $(GCCSYSROOT)/usr/lib/libmnl.so.0	$@/lib
	install -cm 0755 $(GCCSYSROOT)/usr/lib/libncurses.so.6	$@/lib
	install -cm 0755 $(GCCSYSROOT)/usr/lib/libnl-3.so.200	$@/lib
	install -cm 0755 $(GCCSYSROOT)/usr/lib/libnl-genl-3.so.200 $@/lib
	install -cm 0755 $(GCCSYSROOT)/usr/lib/libssl.so.1.1	$@/lib
	install -cm 0755 $(GCCSYSROOT)/usr/lib/libtirpc.so.3	$@/lib
	install -cm 0755 $(GCCSYSROOT)/usr/lib/libz.so.1	$@/lib

ifeq ($(findstring Gadget, $(BOARDNAME)),)
	install -cm 0755 $(GCCSYSROOT)/usr/lib/libusb-1.0.so.0	$@/lib
endif

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

ifneq ($(findstring BeagleBone, $(BOARDNAME)),)
	# Firmware for the BeagleBone Black Wireless built-in WLAN interface
	mkdir -p						$@/lib/firmware/ti-connectivity
	install -cm 0644 $(FIRMWARE_SRC)/ti-connectivity/wl18xx-fw-4.bin $@/lib/firmware/ti-connectivity
	install -cm 0644 wl18xx-conf.bin			$@/lib/firmware/ti-connectivity
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
endif

ifneq ($(findstring RaspberryPi4, $(BOARDNAME)),)
	# Firmware for the Raspberry Pi 4 Model B built-in WLAN interface
	mkdir -p										$@/lib/firmware/brcm
	install -cm 0644 $(FIRMWARE_SRC)/cypress/cyfmac43455-sdio.bin				$@/lib/firmware/brcm/brcmfmac43455-sdio.bin
	install -cm 0644 $(FIRMWARE_SRC)/cypress/cyfmac43455-sdio.clm_blob			$@/lib/firmware/brcm/brcmfmac43455-sdio.clm_blob
	install -cm 0644 $(FIRMWARE_SRC)/brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.txt	$@/lib/firmware/brcm/brcmfmac43455-sdio.txt
	sed -i 's/0x48200100/0x44200100/g'							$@/lib/firmware/brcm/brcmfmac43455-sdio.txt

endif

ifeq ($(BOARDNAME), RaspberryPi4Gadget)
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

	install -cm 0644 $(WIRELESS_REGDB_SRC)/regulatory.db	$@/lib/firmware
	install -cm 0644 $(WIRELESS_REGDB_SRC)/regulatory.db.p7s $@/lib/firmware

# Install kernel modules

	cp -R -P -p ../kernel/modules/lib/modules		$@/lib
	find $@/lib/modules -type d -name '*MuntsOS' -exec ln -s modules.dep.bb {}/modules.dep ";"

# Install files to /root

	touch							$@/root/.ssh/authorized_keys
	chmod 400						$@/root/.ssh/authorized_keys

# Install files to /usr/lib

	install -cm 0755 $(GCCSYSROOT)/usr/lib/libsimpleio.so	$@/usr/lib

# Install files to /usr/libexec

	install -cm 0555 autoexec.script			$@/usr/libexec
	install -cm 0555 hotplug.script				$@/usr/libexec
	install -cm 0555 ifplugd.script				$@/usr/libexec
	install -cm 0555 install-overlays			$@/usr/libexec
	install -cm 0555 mdev-helper-gpio			$@/usr/libexec
	install -cm 0555 mdev-helper-hidraw			$@/usr/libexec
	install -cm 0555 mdev-helper-pwm			$@/usr/libexec
	install -cm 0755 netstart.script			$@/usr/libexec
	install -cm 0755 netstop.script				$@/usr/libexec
	install -cm 0555 udhcpc.script				$@/usr/libexec
	mkdir -p						$@/usr/libexec/services/ttyGS0
	echo "#!/bin/sh" >					$@/usr/libexec/services/ttyGS0/run
	echo "exec /sbin/getty -h -L ttyGS0 115200 vt100" >>	$@/usr/libexec/services/ttyGS0/run
	chmod 555						$@/usr/libexec/services/ttyGS0/run

# Install files to /usr/share

	cp -R -P -p $(GCCSYSROOT)/usr/share/terminfo		$@/usr/share

ifneq ($(findstring Beagle, $(BOARDNAME)),)
	install -cm 0444 pinmux.*Beagle*			$@/usr/share/sysconfig
	install -cm 0444 overlays.*Beagle*			$@/usr/share/sysconfig
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

ifneq ($(findstring Beagle, $(BOARDNAME)),)
	ln -s /sys/class/leds/beaglebone\:green\:usr0/brightness $@/dev/userled
	ln -s /sys/class/leds/beaglebone\:green\:usr0/trigger	$@/dev/userled_trigger

	echo ""							>>$@/etc/mdev.conf
	echo "# $(BOARDNAME) devices"				>>$@/etc/mdev.conf
	echo "ttyS1           root:gpio 660"			>>$@/etc/mdev.conf
	echo "ttyS2           root:gpio 660"			>>$@/etc/mdev.conf
	echo "ttyS3           root:gpio 660"			>>$@/etc/mdev.conf
	echo "ttyS4           root:gpio 660"			>>$@/etc/mdev.conf
	echo "ttyS5           root:gpio 660"			>>$@/etc/mdev.conf
endif

ifneq ($(findstring RaspberryPi, $(BOARDNAME)),)
	ln -s /sys/class/leds/led0/brightness			$@/dev/userled
	ln -s /sys/class/leds/led0/trigger			$@/dev/userled_trigger

	sed -i 's/-h -L 115200 ttyS0/115200 tty1/g'		$@/etc/inittab

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
	chmod 500						$@/etc/ssh
	chmod 700						$@/root/.ssh
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
	rm -rf ../kernel/modules*
	rm -rf $(BUSYBOX_SRC)
	rm -rf $(OPENSSH_SRC)
	rm -rf $(RPCBIND_SRC)
	rm -rf $(IPTABLES_SRC)
	rm -rf $(ETHTOOL_SRC)
	rm -rf $(WPASUPP_SRC)
	rm -rf $(MAILUTILS_SRC)
	rm -rf $(NANO_SRC)
	rm -rf $(FIRMWARE_SRC)
	rm -rf $(WIRELESS_REGDB_SRC)
	rm -f COPYING
ifneq ($(findstring Beagle, $(BOARDNAME)),)
	rm -f config-pin
endif
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
	rm -f $(WPASUPP_DIST)
	rm -f $(MAILUTILS_DIST)
	rm -f $(NANO_DIST)
	rm -f $(FIRMWARE_DIST)
	rm -f $(WIRELESS_REGDB_DIST)
