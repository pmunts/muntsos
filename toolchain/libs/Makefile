# Makefile for application libraries for an embedded Linux system

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

MUNTSOS		?= ../..

BUILDNUM	?= 1

include $(MUNTSOS)/include/$(BOARDNAME).mk

BUILDOS		= --build=`uname -m`
TARGETOS	= --host=$(CONFIGURE_NAME)

NCURSES_NAME	= ncurses
NCURSES_VER	= 6.2
NCURSES_SRC	= $(NCURSES_NAME)-$(NCURSES_VER)
NCURSES_TARBALL	= $(NCURSES_NAME)-$(NCURSES_VER).tar.gz
NCURSES_SERVER	= http://ftp.gnu.org/pub/gnu/ncurses
NCURSES_URL	= $(NCURSES_SERVER)/$(NCURSES_TARBALL)
NCURSES_DIST	= $(TEMP)/$(NCURSES_TARBALL)

LIBUSB_NAME	= libusb
LIBUSB_VER	= 1.0.24
LIBUSB_SRC	= $(LIBUSB_NAME)-$(LIBUSB_VER)
LIBUSB_TARBALL	= $(LIBUSB_NAME)-$(LIBUSB_VER).tar.bz2
LIBUSB_SERVER	= https://github.com/libusb/libusb/releases/download/v$(LIBUSB_VER)
LIBUSB_URL	= $(LIBUSB_SERVER)/$(LIBUSB_TARBALL)
LIBUSB_DIST	= $(TEMP)/$(LIBUSB_TARBALL)

HIDAPI_NAME	= hidapi
HIDAPI_VER	= 0.10.1
HIDAPI_SRC	= hidapi-$(HIDAPI_NAME)-$(HIDAPI_VER)
HIDAPI_TARBALL	= $(HIDAPI_NAME)-$(HIDAPI_VER).tar.gz
HIDAPI_SERVER	= https://github.com/libusb/hidapi/archive
HIDAPI_URL	= $(HIDAPI_SERVER)/$(HIDAPI_TARBALL)
HIDAPI_DIST	= $(TEMP)/$(HIDAPI_TARBALL)

OPENSSL_NAME	= openssl
OPENSSL_VER	= 1.1.1k
OPENSSL_SRC	= $(OPENSSL_NAME)-$(OPENSSL_VER)
OPENSSL_TARBALL	= $(OPENSSL_SRC).tar.gz
OPENSSL_SERVER	= http://www.openssl.org/source
OPENSSL_URL	= $(OPENSSL_SERVER)/$(OPENSSL_TARBALL)
OPENSSL_DIST	= $(TEMP)/$(OPENSSL_TARBALL)
OPENSSL_OS	= linux-generic32

ZLIB_NAME	= zlib
ZLIB_VER	= 1.2.11
ZLIB_SRC	= $(ZLIB_NAME)-$(ZLIB_VER)
ZLIB_TARBALL	= $(ZLIB_NAME)-$(ZLIB_VER).tar.gz
ZLIB_SERVER	= http://zlib.net
ZLIB_URL	= $(ZLIB_SERVER)/$(ZLIB_TARBALL)
ZLIB_DIST	= $(TEMP)/$(ZLIB_TARBALL)

CURL_NAME	= curl
CURL_VER	= 7.78.0
CURL_SRC	= $(CURL_NAME)-$(CURL_VER)
CURL_TARBALL	= $(CURL_NAME)-$(CURL_VER).tar.gz
CURL_SERVER	= http://curl.se/download
CURL_URL	= $(CURL_SERVER)/$(CURL_TARBALL)
CURL_DIST	= $(TEMP)/$(CURL_TARBALL)

TIRPC_NAME	= libtirpc
TIRPC_VER	= 1.3.2
TIRPC_SRC	= libtirpc-$(TIRPC_VER)
TIRPC_TARBALL	= libtirpc-$(TIRPC_VER).tar.bz2
TIRPC_SERVER	= http://sourceforge.net/projects/libtirpc/files/libtirpc
TIRPC_URL	= $(TIRPC_SERVER)/$(TIRPC_VER)/$(TIRPC_TARBALL)
TIRPC_DIST	= $(TEMP)/$(TIRPC_TARBALL)

XMLRPC_C_NAME	= xmlrpc-c
XMLRPC_C_SRC	= $(XMLRPC_C_NAME)
XMLRPC_C_TARBALL = $(XMLRPC_C_NAME).tar.gz
XMLRPC_C_URL	= http://svn.code.sf.net/p/xmlrpc-c/code/stable
XMLRPC_C_DIST	= $(TEMP)/$(XMLRPC_C_TARBALL)

LIBPCAP_NAME	= libpcap
LIBPCAP_VER	= 1.10.1
LIBPCAP_SRC	= $(LIBPCAP_NAME)-$(LIBPCAP_VER)
LIBPCAP_TARBALL	= $(LIBPCAP_SRC).tar.gz
LIBPCAP_SERVER	= http://www.tcpdump.org/release
LIBPCAP_URL	= $(LIBPCAP_SERVER)/$(LIBPCAP_TARBALL)
LIBPCAP_DIST	= $(TEMP)/$(LIBPCAP_TARBALL)

LIBMNL_SRC	= libmnl.src
LIBMNL_URL	= git://git.netfilter.org/libmnl

LIBNL_NAME	= libnl
LIBNL_VER	= 3.5.0
LIBNL_SRC	= $(LIBNL_NAME)-$(LIBNL_VER)
LIBNL_TARBALL	= $(LIBNL_SRC).tar.gz
LIBNL_SERVER	= https://github.com/thom311/libnl/releases/download/libnl3_5_0
LIBNL_URL	= $(LIBNL_SERVER)/$(LIBNL_TARBALL)
LIBNL_DIST	= $(TEMP)/$(LIBNL_TARBALL)

LIBSODIUM_NAME	= libsodium
LIBSODIUM_VER	= 1.0.18
LIBSODIUM_SRC	= $(LIBSODIUM_NAME)-$(LIBSODIUM_VER)
LIBSODIUM_TARBALL	= $(LIBSODIUM_NAME)-$(LIBSODIUM_VER).tar.gz
LIBSODIUM_SERVER	= https://download.libsodium.org/libsodium/releases
LIBSODIUM_URL	= $(LIBSODIUM_SERVER)/$(LIBSODIUM_TARBALL)
LIBSODIUM_DIST	= $(TEMP)/$(LIBSODIUM_TARBALL)

LIBMYSQLCLIENT_NAME	= mariadb-connector-c
LIBMYSQLCLIENT_VER	= 3.2.3
LIBMYSQLCLIENT_SRC	= $(LIBMYSQLCLIENT_NAME)-$(LIBMYSQLCLIENT_VER)-src
LIBMYSQLCLIENT_TARBALL	= $(LIBMYSQLCLIENT_NAME)-$(LIBMYSQLCLIENT_VER)-src.tar.gz
LIBMYSQLCLIENT_SERVER	= https://downloads.mariadb.com/Connectors/c/connector-c-$(LIBMYSQLCLIENT_VER)
LIBMYSQLCLIENT_URL	= $(LIBMYSQLCLIENT_SERVER)/$(LIBMYSQLCLIENT_TARBALL)
LIBMYSQLCLIENT_DIST	= $(TEMP)/$(LIBMYSQLCLIENT_TARBALL)

GDBM_NAME	= gdbm
GDBM_VER	= 1.20
GDBM_SRC	= $(GDBM_NAME)-$(GDBM_VER)
GDBM_TARBALL	= $(GDBM_NAME)-$(GDBM_VER).tar.gz
GDBM_SERVER	= http://ftp.gnu.org/pub/gnu/gdbm
GDBM_URL	= $(GDBM_SERVER)/$(GDBM_TARBALL)
GDBM_DIST	= $(TEMP)/$(GDBM_TARBALL)

MQTT_NAME	= paho.mqtt.c
MQTT_VER	= 1.3.9
MQTT_SRC	= $(MQTT_NAME)-$(MQTT_VER)
MQTT_TARBALL	= v$(MQTT_VER).tar.gz
MQTT_SERVER	= https://github.com/eclipse/paho.mqtt.c/archive
MQTT_URL	= $(MQTT_SERVER)/$(MQTT_TARBALL)
MQTT_DIST	= $(TEMP)/$(MQTT_SRC).tar.gz

RABBITMQ_NAME	= rabbitmq-c
RABBITMQ_VER	= 0.11.0
RABBITMQ_SRC	= $(RABBITMQ_NAME)-$(RABBITMQ_VER)
RABBITMQ_TARBALL = $(RABBITMQ_NAME)-$(RABBITMQ_VER).tar.gz
RABBITMQ_SERVER	= http://github.com/alanxz/rabbitmq-c/archive/v$(RABBITMQ_VER)
RABBITMQ_URL	= $(RABBITMQ_SERVER)/$(RABBITMQ_TARBALL)
RABBITMQ_DIST	= $(TEMP)/$(RABBITMQ_TARBALL)

ZEROMQ_NAME	= zeromq
ZEROMQ_VER	= 4.3.4
ZEROMQ_SRC	= $(ZEROMQ_NAME)-$(ZEROMQ_VER)
ZEROMQ_TARBALL	= $(ZEROMQ_NAME)-$(ZEROMQ_VER).tar.gz
ZEROMQ_SERVER	= https://github.com/zeromq/libzmq/releases/download/v$(ZEROMQ_VER)
ZEROMQ_URL	= $(ZEROMQ_SERVER)/$(ZEROMQ_TARBALL)
ZEROMQ_DIST	= $(TEMP)/$(ZEROMQ_TARBALL)

MODBUS_NAME	= libmodbus
MODBUS_VER	= 3.1.6
MODBUS_SRC	= libmodbus-$(MODBUS_VER)
MODBUS_TARBALL	= libmodbus-$(MODBUS_VER).tar.gz
MODBUS_SERVER	= https://libmodbus.org/releases
MODBUS_URL	= $(MODBUS_SERVER)/$(MODBUS_TARBALL)
MODBUS_DIST	= $(TEMP)/$(MODBUS_TARBALL)

DESTDIR		= $(shell pwd)
INSTALLDIR	= gcc-$(TOOLCHAIN_NAME)-libs

SUBORDINATES	= ncurses libusb hidapi openssl zlib curl tirpc xmlrpc libpcap libmnl libnl libsodium libmysqlclient gdbm mqtt rabbitmq zeromq modbus
SRCDIRS		= $(NCURSES_SRC) $(LIBUSB_SRC) $(HIDAPI_SRC) $(OPENSSL_SRC) $(ZLIB_SRC) $(CURL_SRC) $(TIRPC_SRC) $(XMLRPC_C_SRC) $(LIBPCAP_SRC) $(LIBMNL_SRC) $(LIBNL_SRC) $(LIBSODIUM_SRC) $(LIBMYSQLCLIENT_SRC) $(GDBM_SRC) $(MQTT_SRC) $(RABBITMQ_SRC) $(ZEROMQ_SRC) $(MODBUS_SRC)
DISTFILES	= $(NCURSES_DIST) $(LIBUSB_DIST) $(HIDAPI_DIST) $(OPENSSL_DIST) $(ZLIB_DIST) $(CURL_DIST) $(TIRPC_DIST) $(XMLRPC_C_DIST) $(LIBPCAP_DIST) $(LIBNL_DIST) $(LIBSODIUM_DIST) $(LIBMYSQLCLIENT_DIST) $(GDBM_DIST) $(MQTT_DIST) $(RABBITMQ_DIST) $(ZEROMQ_DIST) $(MODBUS_DIST)

OSNAME		?= unknown
PKGNAME		= gcc-$(TOOLCHAIN_NAME)-libs
PKGVER		= $(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		= all
PKGSUFFIX	= $(PKGVER)-$(OSNAME)-$(PKGARCH)
PKGDIR		= $(PKGNAME)-$(PKGSUFFIX)
PKGFILE		= $(PKGDIR).deb

default: package.deb

###############################################################################

# Fetch source distributions

download: $(DISTFILES)

###############################################################################

# Download ncurses source distribution

$(NCURSES_DIST):
	wget -nv -P $(TEMP) $(NCURSES_URL)

# Unpack ncurses source

$(NCURSES_SRC): $(NCURSES_DIST)
	tar xzf $(NCURSES_DIST)

# Build ncurses

$(INSTALLDIR)/lib/libncurses.a: $(NCURSES_SRC)
	cd $(NCURSES_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --prefix=/$(INSTALLDIR) --with-shared --without-ada --disable-pc-files CC=$(CROSS_COMPILE)gcc CXX=$(CROSS_COMPILE)g++
	$(MAKE) -C $(NCURSES_SRC)
	$(MAKE) -C $(NCURSES_SRC) install DESTDIR=$(DESTDIR) INSTALL_PROG=install
	# Relocate include files--Can't seem to configure ncurses6 to do this
	sed -i 's@ncurses/@@g' $(INSTALLDIR)/include/ncurses/*
	mv $(INSTALLDIR)/include/ncurses/* $(INSTALLDIR)/include
	rmdir $(INSTALLDIR)/include/ncurses
	touch $@

ncurses: $(INSTALLDIR)/lib/libncurses.a

###############################################################################

# Download libusb source distribution

$(LIBUSB_DIST):
	wget -nv -P $(TEMP) $(LIBUSB_URL)

# Unpack libusb source

$(LIBUSB_SRC): $(LIBUSB_DIST)
	tar xjf $(LIBUSB_DIST)

# Build libusb

$(INSTALLDIR)/lib/libusb-1.0.a: $(LIBUSB_SRC)
	cd $(LIBUSB_SRC) ; env PATH=$$PATH':'`dirname $(CROSS_COMPILE)` ./configure $(BUILDOS) $(TARGETOS) --prefix=/$(INSTALLDIR) --disable-udev
	$(MAKE) -C $(LIBUSB_SRC) PATH=$$PATH':'`dirname $(CROSS_COMPILE)`
	$(MAKE) -C $(LIBUSB_SRC) PATH=$$PATH':'`dirname $(CROSS_COMPILE)` install DESTDIR=$(DESTDIR)
	touch $@

libusb: $(INSTALLDIR)/lib/libusb-1.0.a

###############################################################################

# Download libusb source distribution

$(HIDAPI_DIST):
	wget -nv -P $(TEMP) $(HIDAPI_URL)

# Unpack libusb source

$(HIDAPI_SRC): $(HIDAPI_DIST)
	tar xzf $(HIDAPI_DIST)

# Build hidapi

$(INSTALLDIR)/lib/libhidapi.a: $(HIDAPI_SRC)
	mkdir -p $(INSTALLDIR)/include/hidapi
	install -cm 0644 $(HIDAPI_SRC)/hidapi/hidapi.h $(INSTALLDIR)/include/hidapi
	$(CROSS_COMPILE)gcc -Wall -fPIC -I$(HIDAPI_SRC)/hidapi -I$(INSTALLDIR)/include/libusb-1.0 -c -o $(HIDAPI_SRC)/hid.o $(HIDAPI_SRC)/libusb/hid.c
	$(CROSS_COMPILE)gcc -shared -fPIC -Wl,-soname,libhidapi.so.0 -o $(INSTALLDIR)/lib/libhidapi.so.$(HIDAPI_VER) $(HIDAPI_SRC)/*.o -L$(INSTALLDIR)/lib -lusb-1.0
	ln -s libhidapi.so.$(HIDAPI_VER) $(INSTALLDIR)/lib/libhidapi.so
	ln -s libhidapi.so.$(HIDAPI_VER) $(INSTALLDIR)/lib/libhidapi.so.0
	$(CROSS_COMPILE)ar rcs $@ $(HIDAPI_SRC)/*.o
	touch $@

hidapi: $(INSTALLDIR)/lib/libhidapi.a

###############################################################################

# Download OpenSSL source

$(OPENSSL_DIST):
	wget -nv -P $(TEMP) $(OPENSSL_URL)

# Unpack OpenSSL source

$(OPENSSL_SRC): $(OPENSSL_DIST)
	tar xzf $(OPENSSL_DIST)

# Build OpenSSL

$(INSTALLDIR)/lib/libcrypto.a: $(OPENSSL_SRC)
	cd $(OPENSSL_SRC) ; ./Configure no-hw shared --prefix=/$(INSTALLDIR) --openssldir=/$(INSTALLDIR)/openssl $(OPENSSL_OS)
	$(MAKE) -C $(OPENSSL_SRC) CC=$(CROSS_COMPILE)gcc
	$(MAKE) -C $(OPENSSL_SRC) CC=$(CROSS_COMPILE)gcc install_sw DESTDIR=$(DESTDIR)
	touch $@

openssl: $(INSTALLDIR)/lib/libcrypto.a

###############################################################################

# Download zlib source distribution

$(ZLIB_DIST):
	wget -nv -P $(TEMP) $(ZLIB_URL)

# Unpack zlib source

$(ZLIB_SRC): $(ZLIB_DIST)
	tar xzf $(ZLIB_DIST)

# Build zlib

$(INSTALLDIR)/lib/libz.a: $(ZLIB_SRC)
	cd $(ZLIB_SRC) ; export CROSS_PREFIX=$(CROSS_COMPILE) ; ./configure --prefix=/$(INSTALLDIR)
	$(MAKE) -C $(ZLIB_SRC)
	$(MAKE) -C $(ZLIB_SRC) install DESTDIR=$(DESTDIR)
	touch $@

zlib: $(INSTALLDIR)/lib/libz.a

###############################################################################

# Download curl source distribution

$(CURL_DIST):
	wget -nv -P $(TEMP) $(CURL_URL)

# Unpack curl source

$(CURL_SRC): $(CURL_DIST)
	tar xzf $(CURL_DIST)

# Build curl

$(INSTALLDIR)/lib/libcurl.a: $(CURL_SRC)
	cd $(CURL_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --prefix=/$(INSTALLDIR) CC=$(CROSS_COMPILE)gcc --with-ssl=$(shell pwd)/$(INSTALLDIR) --with-zlib=$(shell pwd)/$(INSTALLDIR)
	$(MAKE) -C $(CURL_SRC)
	$(MAKE) -C $(CURL_SRC) install DESTDIR=$(DESTDIR)
	touch $@

curl: $(INSTALLDIR)/lib/libcurl.a

###############################################################################

# Download the TI-RPC source distribution

$(TIRPC_DIST):
	wget -nv -P $(TEMP) $(TIRPC_URL)

# Unpack TI-RPC source

$(TIRPC_SRC): $(TIRPC_DIST)
	tar xjf $(TIRPC_DIST)

# Build TI-RPC

$(INSTALLDIR)/lib/libtirpc.a: $(TIRPC_SRC)
	cd $(TIRPC_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --prefix=/$(INSTALLDIR) --disable-gssapi --disable-ipv6 CC=$(CROSS_COMPILE)gcc
	$(MAKE) -C $(TIRPC_SRC)
	$(MAKE) -C $(TIRPC_SRC) install DESTDIR=$(DESTDIR)

tirpc: $(INSTALLDIR)/lib/libtirpc.a

###############################################################################

# Download xmlrpc-c source distribution

$(XMLRPC_C_DIST):
	svn co $(XMLRPC_C_URL) $(TEMP)/$(XMLRPC_C_SRC)
	cp /usr/share/misc/config.guess $(TEMP)/$(XMLRPC_C_SRC)
	cp /usr/share/misc/config.sub   $(TEMP)/$(XMLRPC_C_SRC)
	cd $(TEMP) && tar czf $(XMLRPC_C_DIST) --exclude .svn $(XMLRPC_C_SRC) && rm -rf $(XMLRPC_C_SRC)

# Unpack xmlrpc-c source

$(XMLRPC_C_SRC): $(XMLRPC_C_DIST)
	tar xzf $(XMLRPC_C_DIST)

# Build xmlrpc-c

$(INSTALLDIR)/lib/libxmlrpc.a: $(XMLRPC_C_SRC)
	cd $(XMLRPC_C_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --prefix=/$(INSTALLDIR) --mandir=/$(INSTALLDIR)/share/man CC=$(CROSS_COMPILE)gcc CXX=$(CROSS_COMPILE)g++
	cd $(XMLRPC_C_SRC)/lib/expat/gennmtab ; $(MAKE) CC=gcc
	$(MAKE) -C $(XMLRPC_C_SRC) CFLAGS_PERSONAL="-fpermissive -I$(DESTDIR)/$(INSTALLDIR)/include" LDFLAGS="-L`pwd`/$(INSTALLDIR)/lib" AR=$(CROSS_COMPILE)ar RANLIB=$(CROSS_COMPILE)ranlib
	$(MAKE) -C $(XMLRPC_C_SRC) install DESTDIR=$(DESTDIR) RANLIB=$(CROSS_COMPILE)ranlib
	$(MAKE) -C $(XMLRPC_C_SRC)/tools/xmlrpc LDFLAGS="-L`pwd`/$(INSTALLDIR)/lib -lcurl -lz -lssl -lcrypto"
	$(MAKE) -C $(XMLRPC_C_SRC)/tools/xmlrpc install DESTDIR=$(DESTDIR)
	touch $@

xmlrpc: $(INSTALLDIR)/lib/libxmlrpc.a

###############################################################################

# Download libpcap source distribution

$(LIBPCAP_DIST):
	wget -nv -P $(TEMP) $(LIBPCAP_URL)

# Unpack libpcap source

$(LIBPCAP_SRC): $(LIBPCAP_DIST)
	tar xzf $(LIBPCAP_DIST)

# Build libpcap

$(INSTALLDIR)/lib/libpcap.a: $(LIBPCAP_SRC)
	cd $(LIBPCAP_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --prefix=/$(INSTALLDIR) --disable-ipv6 --disable-bluetooth --disable-can --disable-canusb --without-libnl --with-pcap=linux CC=$(CROSS_COMPILE)gcc
	$(MAKE) -C $(LIBPCAP_SRC)
	$(MAKE) -C $(LIBPCAP_SRC) install DESTDIR=$(DESTDIR)
	touch $@

libpcap: $(INSTALLDIR)/lib/libpcap.a

###############################################################################

# Clone libmnl source tree

$(LIBMNL_SRC):
	git clone --depth 1 $(LIBMNL_URL) $(LIBMNL_SRC)

# Build libmnl

$(INSTALLDIR)/lib/libmnl.a: $(LIBMNL_SRC)
	cd $(LIBMNL_SRC) && ./autogen.sh && ./configure $(BUILDOS) $(TARGETOS) --prefix=/$(INSTALLDIR) --enable-static CC=$(CROSS_COMPILE)gcc
	$(MAKE) -C $(LIBMNL_SRC)
	$(MAKE) -C $(LIBMNL_SRC) install DESTDIR=$(DESTDIR)
	touch $@

libmnl: $(INSTALLDIR)/lib/libmnl.a

###############################################################################

# Download the netlink source distribution

$(LIBNL_DIST):
	wget -nv -P $(TEMP) $(LIBNL_URL)

# Unpack netlink source

$(LIBNL_SRC): $(LIBNL_DIST)
	tar xzf $(LIBNL_DIST)

# Build netlink

$(INSTALLDIR)/lib/libnl-3.a: $(LIBNL_SRC)
	cd $(LIBNL_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --prefix=/$(INSTALLDIR) --enable-static CC=$(CROSS_COMPILE)gcc
	$(MAKE) -C $(LIBNL_SRC)
	$(MAKE) -C $(LIBNL_SRC) install DESTDIR=$(DESTDIR)
	touch $@

libnl: $(INSTALLDIR)/lib/libnl-3.a

###############################################################################

# Download the Sodium source distribution

$(LIBSODIUM_DIST):
	wget -nv -P $(TEMP) $(LIBSODIUM_URL)

# Unpack Sodium source

$(LIBSODIUM_SRC): $(LIBSODIUM_DIST)
	tar xzf $(LIBSODIUM_DIST)

# Build Sodium

$(INSTALLDIR)/lib/libsodium.a: $(LIBSODIUM_SRC)
	cd $(LIBSODIUM_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --prefix=/$(INSTALLDIR) --enable-static CC=$(CROSS_COMPILE)gcc
	$(MAKE) -C $(LIBSODIUM_SRC)
	$(MAKE) -C $(LIBSODIUM_SRC) install DESTDIR=$(DESTDIR)
	touch $@

libsodium: $(INSTALLDIR)/lib/libsodium.a

###############################################################################

# Download MariaDB C Connector

$(LIBMYSQLCLIENT_DIST):
	wget -nv -P $(TEMP) $(LIBMYSQLCLIENT_URL)

# Unpack MariaDB C Connector source

$(LIBMYSQLCLIENT_SRC): $(LIBMYSQLCLIENT_DIST)
	tar xzf $(LIBMYSQLCLIENT_DIST)
	cd $(LIBMYSQLCLIENT_SRC) && patch -b -p0 <../mariadb-connector-c.patch

$(INSTALLDIR)/lib/libmysqlclient.a: $(LIBMYSQLCLIENT_SRC)
	echo "set(CMAKE_SYSTEM_NAME Linux)"					>$(LIBMYSQLCLIENT_SRC)/toolchain.cmake
	echo "set(CMAKE_SYSTEM_PROCESSOR $(ARCH))"				>>$(LIBMYSQLCLIENT_SRC)/toolchain.cmake
	echo "set(CMAKE_BUILD_TYPE Release)"					>>$(LIBMYSQLCLIENT_SRC)/toolchain.cmake
	echo "set(CMAKE_C_COMPILER $(CROSS_COMPILE)gcc)"			>>$(LIBMYSQLCLIENT_SRC)/toolchain.cmake
	echo "set(CMAKE_CXX_COMPILER $(CROSS_COMPILE)g++)"			>>$(LIBMYSQLCLIENT_SRC)/toolchain.cmake
	echo "set(CMAKE_FIND_ROOT_PATH $(GCCLIBDIR) $(DESTDIR)/$(INSTALLDIR))" 	>>$(LIBMYSQLCLIENT_SRC)/toolchain.cmake
	echo "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)"			>>$(LIBMYSQLCLIENT_SRC)/toolchain.cmake
	echo "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)"			>>$(LIBMYSQLCLIENT_SRC)/toolchain.cmake
	echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)"			>>$(LIBMYSQLCLIENT_SRC)/toolchain.cmake
	echo "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)"			>>$(LIBMYSQLCLIENT_SRC)/toolchain.cmake
	mkdir -p $(LIBMYSQLCLIENT_SRC)/cross
	cd $(LIBMYSQLCLIENT_SRC)/cross && cmake .. -DCMAKE_TOOLCHAIN_FILE=../toolchain.cmake -DCMAKE_INSTALL_PREFIX=/$(INSTALLDIR)
	$(MAKE) -C $(LIBMYSQLCLIENT_SRC)/cross
	$(MAKE) -C $(LIBMYSQLCLIENT_SRC)/cross install DESTDIR=$(DESTDIR)
	ln -s mariadb $(INSTALLDIR)/include/mysql
	ln -s mariadb/libmysqlclient.a $(INSTALLDIR)/lib/libmysqlclient.a
	ln -s mariadb/libmysqlclient.so $(INSTALLDIR)/lib/libmysqlclient.so

libmysqlclient: $(INSTALLDIR)/lib/libmysqlclient.a

###############################################################################

# Download gdbm source distribution

$(GDBM_DIST):
	wget -nv -P $(TEMP) $(GDBM_URL)

# Unpack gdbm source

$(GDBM_SRC): $(GDBM_DIST)
	tar xzf $(GDBM_DIST)

# Build gdbm

$(INSTALLDIR)/lib/libgdbm.a: $(GDBM_SRC)
	cd $(GDBM_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --prefix=/$(INSTALLDIR) --enable-libgdbm-compat --disable-nls CC=$(CROSS_COMPILE)gcc
	$(MAKE) -C $(GDBM_SRC)
	$(MAKE) -C $(GDBM_SRC) install DESTDIR=$(DESTDIR)
	rm -rf $(DESTDIR)/$(INSTALLDIR)/share/info
	touch $@

gdbm: $(INSTALLDIR)/lib/libgdbm.a

###############################################################################

# Download Paho MQTT C client library source distribution

$(MQTT_DIST):
	wget -nv -P $(TEMP) $(MQTT_URL)
	mv $(TEMP)/$(MQTT_TARBALL) $@

# Unpack Paho MQTT C client library source

$(MQTT_SRC): $(MQTT_DIST)
	tar xzf $(MQTT_DIST)

# Build Paho MQTT C client library

$(INSTALLDIR)/lib/libpaho-mqtt3a.so: $(MQTT_SRC)
	$(MAKE) -C $(MQTT_SRC) CC=$(CROSS_COMPILE)gcc CFLAGS="-I$(DESTDIR)/$(INSTALLDIR)/include" LDFLAGS="-L$(DESTDIR)/$(INSTALLDIR)/lib"
	$(MAKE) -C $(MQTT_SRC) CC=$(CROSS_COMPILE)gcc CFLAGS="-I$(DESTDIR)/$(INSTALLDIR)/include" LDFLAGS="-L$(DESTDIR)/$(INSTALLDIR)/lib" install DESTDIR=$(DESTDIR)/ prefix=$(INSTALLDIR) LDCONFIG=true

mqtt: $(INSTALLDIR)/lib/libpaho-mqtt3a.so

###############################################################################

# Download RabbitMQ C library source distribution

$(RABBITMQ_DIST):
	wget -nv -P $(TEMP) $(RABBITMQ_URL)

# Unpack RabbitMQ C library source

$(RABBITMQ_SRC): $(RABBITMQ_DIST)
	tar xzf $(RABBITMQ_DIST)

# Build RabbitMQ C library

$(INSTALLDIR)/lib/librabbitmq.a: $(RABBITMQ_SRC)
	mkdir -p $(RABBITMQ_SRC)/build
	cd $(RABBITMQ_SRC)/build && env CC=$(CROSS_COMPILE)gcc cmake ..	\
	-DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=ON			\
	-DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF				\
	-DCMAKE_INSTALL_PREFIX=$(DESTDIR)/$(INSTALLDIR)			\
	-DOPENSSL_INCLUDE_DIR=$(DESTDIR)/$(INSTALLDIR)/include		\
	-DOPENSSL_CRYPTO_LIBRARY=$(DESTDIR)/$(INSTALLDIR)/lib/libcrypto.so \
	-DOPENSSL_SSL_LIBRARY=$(DESTDIR)/$(INSTALLDIR)/lib/libssl.so
	cd $(RABBITMQ_SRC)/build && cmake --build . --target install
	sed -i "s@`pwd`@@g" $(DESTDIR)/$(INSTALLDIR)/lib/pkgconfig/librabbitmq.pc
	touch $@

rabbitmq: $(INSTALLDIR)/lib/librabbitmq.a

###############################################################################

# Download the ZeroMQ source distribution

$(ZEROMQ_DIST):
	wget -nv -P $(TEMP) $(ZEROMQ_URL)

# Unpack ZeroMQ source

$(ZEROMQ_SRC): $(ZEROMQ_DIST)
	tar xzf $(ZEROMQ_DIST)

# Build ZeroMQ

$(INSTALLDIR)/lib/libzmq.a: $(ZEROMQ_SRC)
	cd $(ZEROMQ_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --prefix=/$(INSTALLDIR) --enable-static CC=$(CROSS_COMPILE)gcc CXX=$(CROSS_COMPILE)g++ sodium_CFLAGS=-I$(DESTDIR)/$(INSTALLDIR)/include sodium_LIBS=-L$(DESTDIR)/$(INSTALLDIR)/lib
	$(MAKE) -C $(ZEROMQ_SRC)
	$(MAKE) -C $(ZEROMQ_SRC) install DESTDIR=$(DESTDIR)
	touch $@

zeromq: $(INSTALLDIR)/lib/libzmq.a

###############################################################################

# Download the libmodbus source distribution

$(MODBUS_DIST):
	wget -nv -P $(TEMP) $(MODBUS_URL)

# Unpack libmodbus source

$(MODBUS_SRC): $(MODBUS_DIST)
	tar xzf $(MODBUS_DIST)

# Build libmodbus

$(INSTALLDIR)/lib/libmodbus.a: $(MODBUS_SRC)
	cd $(MODBUS_SRC) ; ./configure $(BUILDOS) $(TARGETOS) --prefix=/$(INSTALLDIR) --enable-static --enable-shared CC=$(CROSS_COMPILE)gcc
	$(MAKE) -C $(MODBUS_SRC)
	$(MAKE) -C $(MODBUS_SRC) install DESTDIR=$(DESTDIR)

modbus: $(INSTALLDIR)/lib/libmodbus.a

###############################################################################

# Collect copyright/license information into one place

$(INSTALLDIR)/COPYING: $(SUBORDINATES)
	@echo "**** ncurses:"				>$@
	@echo ""					>>$@
	@cat $(NCURSES_SRC)/COPYING			>>$@
	@echo ""					>>$@
	@echo "**** libusb:"				>>$@
	@echo ""					>>$@
	@cat $(LIBUSB_SRC)/COPYING			>>$@
	@echo ""					>>$@
	@echo "**** hidapi:"				>>$@
	@echo ""					>>$@
	@cat $(HIDAPI_SRC)/LICENSE-orig.txt		>>$@
	@echo ""					>>$@
	@echo "**** openssl:"				>>$@
	@cat $(OPENSSL_SRC)/LICENSE			>>$@
	@echo "**** zlib:"				>>$@
	@echo ""					>>$@
	@tail -n 31 $(ZLIB_SRC)/README			>>$@
	@echo ""					>>$@
	@echo "**** libcurl:"				>>$@
	@echo ""					>>$@
	@cat $(CURL_SRC)/COPYING			>>$@
	@echo ""					>>$@
	@echo "**** libtirpc:"				>>$@
	@echo ""					>>$@
	@cat $(TIRPC_SRC)/COPYING			>>$@
	@echo ""					>>$@
	@echo "**** xmlrpc-c:"				>>$@
	@echo ""					>>$@
	@cat $(XMLRPC_C_SRC)/doc/COPYING		>>$@
	@echo ""					>>$@
	@echo "**** libpcap:"				>>$@
	@echo ""					>>$@
	@cat $(LIBPCAP_SRC)/LICENSE			>>$@
	@echo ""					>>$@
	@echo "**** libnl:"				>>$@
	@echo ""					>>$@
	@cat $(LIBNL_SRC)/COPYING			>>$@
	@echo ""					>>$@
	@echo "**** libsodium:"				>>$@
	@cut -c 4- $(LIBSODIUM_SRC)/LICENSE		>>$@
	@echo "**** libmysqlclient (MariaDB C Connector):" >>$@
	@echo ""					>>$@
	@cat $(LIBMYSQLCLIENT_SRC)/COPYING.LIB		>>$@
	@echo ""					>>$@
	@echo "**** gdbm:"				>>$@
	@echo ""					>>$@
	@cat $(GDBM_SRC)/COPYING			>>$@
	@echo ""					>>$@
	@echo "**** libmqtt:"	 			>>$@
	@echo ""					>>$@
	@cat $(MQTT_SRC)/LICENSE			>>$@
	@echo ""					>>$@
	@echo "**** rabbitmq-c:"			>>$@
	@echo ""					>>$@
	@cat $(RABBITMQ_SRC)/LICENSE-MIT		>>$@
	@echo ""					>>$@
	@echo "**** zeromq:"				>>$@
	@echo ""					>>$@
	@cat $(ZEROMQ_SRC)/COPYING			>>$@
	@echo ""					>>$@
	@echo "**** libmodbus:"				>>$@
	@echo ""					>>$@
	@cat $(MODBUS_SRC)/COPYING.LESSER		>>$@
	@sed -i 's/\f//'				$@
	@uniq $@ >$@.new && mv $@.new			$@
	@dos2unix					$@

copying: $(INSTALLDIR)/COPYING

###############################################################################

# Create Debian package

package.deb: $(INSTALLDIR)/COPYING
	mkdir -p					$(PKGDIR)/DEBIAN
	mkdir -p					$(PKGDIR)$(GCCSYSROOT)/usr
	install -cm 0644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@BOARDNAME@@/$(BOARDBASE)/g		$(PKGDIR)/DEBIAN/control
	cp -R -P -p $(INSTALLDIR)/*			$(PKGDIR)$(GCCSYSROOT)/usr
	chmod -R ugo-w					$(PKGDIR)/usr/*
	fakeroot dpkg-deb --build			$(PKGDIR)
	chmod -R ugo+w					$(PKGDIR)

###############################################################################

# Remove working files

clean:
	rm -rf $(INSTALLDIR) $(PKGDIR) $(PKGFILE)

reallyclean: clean
	rm -rf *.o $(SRCDIRS)

distclean: reallyclean
	-rm $(DISTFILES)
