                      Embedded Linux Application Libraries

   This directory contains a recipe for building some development
   libraries for a particular MuntsOS target.

   The following libraries are included:
     * [1]GNU ncurses library
     * [2]libusb USB library
     * [3]OpenSSL crypto library
     * [4]zlib compression library
     * [5]libcurl HTTP access library
     * [6]xmlrpc-c XML RPC library
     * [7]MySQL database client library
     * [8]libpcap packet capture libarary
     * [9]Netlink protocol library
     * [10]RabbitMQ AMQP client library
     * [11]libsodium crypto library
     * [12]ZeroMQ messaging library
     * [13]gdbm database library

Installation

   Build the libraries with:

   make BOARDNAME=RaspberryPi1

   Build installation packages with either of:

   make BOARDNAME=RaspberryPi1 package.deb

   make BOARDNAME=RaspberryPi1 tarball

   Prebuilt toolchain packages are available at:
   [14]http://repo.munts.com.
   _______________________________________________________________________

   Questions or comments to Philip Munts [15]phil@munts.net

References

   1. http://www.gnu.org/software/ncurses
   2. http://www.libusb.org/
   3. http://www.openssl.org/
   4. http://www.zlib.net/
   5. http://curl.haxx.se/libcurl
   6. http://xmlrpc-c.sourceforge.net/
   7. http://dev.mysql.com/downloads/connector/c
   8. http://www.tcpdump.org/
   9. http://www.infradead.org/~tgr/libnl
  10. https://github.com/alanxz/rabbitmq-c
  11. https://download.libsodium.org/doc
  12. http://zeromq.org/
  13. http://www.gnu.org/software/gdbm
  14. http://repo.munts.com/
  15. mailto:phil@munts.net
