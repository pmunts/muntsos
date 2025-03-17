Embedded Linux Application Libraries
====================================

This directory contains a recipe for building some development libraries
for a particular MuntsOS target.

The following libraries are included:

-   [GNU ncurses library](http://www.gnu.org/software/ncurses)
-   [libusb USB library](http://www.libusb.org)
-   [OpenSSL crypto library](http://www.openssl.org)
-   [zlib compression library](http://www.zlib.net)
-   [libcurl HTTP access library](http://curl.haxx.se/libcurl)
-   [xmlrpc-c XML RPC library](http://xmlrpc-c.sourceforge.net)
-   [MySQL database client
    library](http://dev.mysql.com/downloads/connector/c)
-   [libpcap packet capture libarary](http://www.tcpdump.org)
-   [Netlink protocol library](http://www.infradead.org/~tgr/libnl)
-   [RabbitMQ AMQP client library](https://github.com/alanxz/rabbitmq-c)
-   [libsodium crypto library](https://download.libsodium.org/doc)
-   [ZeroMQ messaging library](http://zeromq.org)
-   [gdbm database library](http://www.gnu.org/software/gdbm)

Installation
------------

Build the libraries with:

`make BOARDNAME=RaspberryPi1`

Build installation packages with either of:

`make BOARDNAME=RaspberryPi1 package.deb`

`make BOARDNAME=RaspberryPi1 tarball`

Prebuilt toolchain packages are available at: <https://repo.munts.com>.

------------------------------------------------------------------------

Questions or comments to Philip Munts <phil@munts.net>
