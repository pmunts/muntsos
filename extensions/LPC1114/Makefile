# Makefile for building a MuntsOS LPC1114 I/O Processor extension package

# Copyright (C)2017-2022, Philip Munts, President, Munts AM Corp.
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

ARMSRC		?= $(HOME)/arm-mcu
BOARDNAME	?= UNDEFINED
MUNTSOS		?= ../..
RASPBERRYPI_LPC1114_SRC	?= $(HOME)/rpi-mcu/expansion/LPC1114/src

include $(MUNTSOS)/include/$(BOARDNAME).mk
include $(LIBSIMPLEIO)/include/dpkg.mk

OSNAME		:= muntsos-$(BOARDBASE)
PKGNAME		:= LPC1114
PKGVERSION	:= $(shell date +%Y.%j)
PKGARCH		:= $(DEBARCH)
PKGDIR		:= $(PKGNAME)-$(OSNAME)
PKGFILE		:= $(PKGDIR).deb

default: package.deb

###############################################################################

HOST_CC		= $(CROSS_COMPILE)gcc
HOST_CFLAGS	= -Wall -DMUNTSOS -I$(LIBSINCDIR) -I$(LIBSINCDIR)/tirpc -I$(RASPBERRYPI_LPC1114_SRC)/c/include
HOST_LDFLAGS	= -L$(LIBSLIBDIR) -lspiagent -lsimpleio

COMPONENTS	= $(RASPBERRYPI_LPC1114_SRC)/spi-agent/LPC1114-spi-agent.hex		\
		  $(RASPBERRYPI_LPC1114_SRC)/spi-agent-http/spi_agent_http_server	\
		  $(RASPBERRYPI_LPC1114_SRC)/spi-agent-linx/spi_agent_linx_server	\
		  $(RASPBERRYPI_LPC1114_SRC)/spi-agent-oncrpc/spi_agent_oncrpc_server	\
		  $(RASPBERRYPI_LPC1114_SRC)/spi-agent-remoteio/spi_agent_remoteio_server	\
		  $(RASPBERRYPI_LPC1114_SRC)/spi-agent-xmlrpc/spi_agent_xmlrpc_server	\
		  $(RASPBERRYPI_LPC1114_SRC)/spi-agent-zeromq/spi_agent_zeromq_server	\
		  $(RASPBERRYPI_LPC1114_SRC)/spi-agent-lib/clients/c/spi_agent_test	\
		  $(RASPBERRYPI_LPC1114_SRC)/utils/isp/expansion_lpc1114_isp		\
		  $(RASPBERRYPI_LPC1114_SRC)/utils/isp/expansion_lpc1114_reset		\
		  $(RASPBERRYPI_LPC1114_SRC)/utils/lpc21isp/lpc21isp

###############################################################################

# Compile the LPC1114 SPI Agent Firmware

$(RASPBERRYPI_LPC1114_SRC)/spi-agent/LPC1114-spi-agent.hex:
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/spi-agent BOARDNAME=RASPBERRYPI_LPC1114

###############################################################################

# Cross-Compile the HTTP transport server for MuntsOS

$(RASPBERRYPI_LPC1114_SRC)/spi-agent-http/spi_agent_http_server:
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/spi-agent-http HOST_CC=$(HOST_CC) HOST_CFLAGS:="$(HOST_CFLAGS) -Imongoose" HOST_LDFLAGS:="$(HOST_LDFLAGS) -ldl -lpthread"

###############################################################################

# Cross-Compile the LabView LINX server for MuntsOS

$(RASPBERRYPI_LPC1114_SRC)/spi-agent-linx/spi_agent_linx_server:
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/spi-agent-linx HOST_CC=$(HOST_CC) HOST_CFLAGS:="$(HOST_CFLAGS) -I$(LIBSIMPLEIO)/c++" HOST_LDFLAGS:="$(HOST_LDFLAGS) -lstdc++"

###############################################################################

# Cross-Compile the ONC/RPC transport server for MuntsOS

$(RASPBERRYPI_LPC1114_SRC)/spi-agent-oncrpc/spi_agent_oncrpc_server:
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/spi-agent-oncrpc HOST_CC=$(HOST_CC) HOST_CFLAGS:="$(HOST_CFLAGS) -I$(LIBSINCDIR)/tirpc" HOST_LDFLAGS:="$(HOST_LDFLAGS) -ltirpc"

###############################################################################

# Cross-Compile the Remote I/O server for MuntsOS

$(RASPBERRYPI_LPC1114_SRC)/spi-agent-remoteio/spi_agent_remoteio_server:
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/spi-agent-remoteio HOST_CC=$(HOST_CC) HOST_CFLAGS:="$(HOST_CFLAGS)" HOST_LDFLAGS:="$(HOST_LDFLAGS)"

###############################################################################

# Cross-Compile the XML-RPC transport server for MuntsOS

$(RASPBERRYPI_LPC1114_SRC)/spi-agent-xmlrpc/spi_agent_xmlrpc_server:
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/spi-agent-xmlrpc HOST_CC=$(HOST_CC) HOST_CFLAGS:="$(HOST_CFLAGS)" HOST_LDFLAGS:="$(HOST_LDFLAGS) -lxmlrpc -lxmlrpc_abyss -lxmlrpc_server -lxmlrpc_server_abyss -lxmlrpc_xmlparse -lxmlrpc_xmltok -lxmlrpc_util -lpthread"

###############################################################################

# Cross-Compile the ZeroMQ transport server for MuntsOS

$(RASPBERRYPI_LPC1114_SRC)/spi-agent-zeromq/spi_agent_zeromq_server:
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/spi-agent-zeromq HOST_CC=$(HOST_CC) HOST_CFLAGS:="$(HOST_CFLAGS)" HOST_LDFLAGS:="$(HOST_LDFLAGS) -lzmq"

###############################################################################

# Cross-Compile the SPI Agent test program for MuntsOS

$(RASPBERRYPI_LPC1114_SRC)/spi-agent-lib/clients/c/spi_agent_test:
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/spi-agent-lib/clients/c HOST_CC=$(HOST_CC) HOST_CFLAGS:="$(HOST_CFLAGS)" HOST_LDFLAGS:="$(HOST_LDFLAGS)"

###############################################################################

# Cross-Compile expansion_lpc1114_isp for MuntsOS

$(RASPBERRYPI_LPC1114_SRC)/utils/isp/expansion_lpc1114_isp:
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/utils/isp HOST_CC=$(HOST_CC) HOST_CFLAGS:="$(HOST_CFLAGS)" HOST_LDFLAGS:="$(HOST_LDFLAGS)"

###############################################################################

# Cross-Compile expansion_lpc1114_reset for MuntsOS

$(RASPBERRYPI_LPC1114_SRC)/utils/isp/expansion_lpc1114_reset:
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/utils/reset HOST_CC=$(HOST_CC) HOST_CFLAGS:="$(HOST_CFLAGS)" HOST_LDFLAGS:="$(HOST_LDFLAGS)"

###############################################################################

# Cross-Compile lpc21isp for MuntsOS

$(RASPBERRYPI_LPC1114_SRC)/utils/lpc21isp/lpc21isp:
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/utils/lpc21isp HOST_CC=$(HOST_CC) HOST_CFLAGS:="-Wall"

lpc21isp: $(RASPBERRYPI_LPC1114_SRC)/utils/lpc21isp/lpc21isp

###############################################################################

# Build the LPC1114 I/O Processor extension package for MuntsOS

$(PKGDIR): $(COMPONENTS)
	mkdir -p										$(PKGDIR)/DEBIAN
	install -cm 0644 control								$(PKGDIR)/DEBIAN
	install -cm 0755 postinst								$(PKGDIR)/DEBIAN
	install -cm 0755 preinst								$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g								$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g								$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g							$(PKGDIR)/DEBIAN/control
	mkdir -p										$@/etc/rc.d
	mkdir -p										$@/usr/local/bin
	mkdir -p										$@/usr/local/etc
	mkdir -p										$@/usr/local/lib/firmware
	mkdir -p										$@/usr/local/lib/python3
	mkdir -p										$@/usr/local/libexec
	install -cm 0755 $(RASPBERRYPI_LPC1114_SRC)/utils/lpc21isp/lpc21isp			$@/usr/local/bin
	install -cm 0755 $(RASPBERRYPI_LPC1114_SRC)/spi-agent-lib/clients/c/spi_agent_test	$@/usr/local/bin
ifneq ($(findstring BeagleBone,$(BOARDNAME)),)
	install -cm 0644 expansion_lpc1114.config.BeagleBone					$@/usr/local/etc/expansion_lpc1114.config
endif
ifneq ($(findstring RaspberryPi,$(BOARDNAME)),)
	install -cm 0644 expansion_lpc1114.config.RaspberryPi					$@/usr/local/etc/expansion_lpc1114.config
endif
	install -cm 0755 $(LIBSLIBDIR)/libcurl.so.4						$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libsodium.so.23						$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libspiagent.so						$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc.so.3						$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_abyss.so.3					$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_client.so.3					$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_server.so.3					$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_server_abyss.so.3				$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_util.so.4					$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_xmlparse.so.3					$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libxmlrpc_xmltok.so.3					$@/usr/local/lib
	install -cm 0755 $(LIBSLIBDIR)/libzmq.so.5						$@/usr/local/lib
	install -cm 0644 $(RASPBERRYPI_LPC1114_SRC)/spi-agent/LPC1114-spi-agent.hex		$@/usr/local/lib/firmware
	install -cm 0644 $(RASPBERRYPI_LPC1114_SRC)/python/spiagent*.py				$@/usr/local/lib/python3
	install -cm 0755 $(RASPBERRYPI_LPC1114_SRC)/scripts/expansion_lpc1114_flash		$@/usr/local/libexec
	install -cm 0755 $(RASPBERRYPI_LPC1114_SRC)/scripts/expansion_lpc1114_startup		$@/usr/local/libexec
	install -cm 0755 $(RASPBERRYPI_LPC1114_SRC)/utils/isp/expansion_lpc1114_isp		$@/usr/local/libexec
	install -cm 0755 $(RASPBERRYPI_LPC1114_SRC)/utils/reset/expansion_lpc1114_reset		$@/usr/local/libexec
	install -cm 0755 $(RASPBERRYPI_LPC1114_SRC)/spi-agent-http/spi_agent_http_server	$@/usr/local/libexec
	install -cm 0755 $(RASPBERRYPI_LPC1114_SRC)/spi-agent-linx/spi_agent_linx_server	$@/usr/local/libexec
	install -cm 0755 $(RASPBERRYPI_LPC1114_SRC)/spi-agent-oncrpc/spi_agent_oncrpc_server	$@/usr/local/libexec
	install -cm 0755 $(RASPBERRYPI_LPC1114_SRC)/spi-agent-remoteio/spi_agent_remoteio_server	$@/usr/local/libexec
	install -cm 0755 $(RASPBERRYPI_LPC1114_SRC)/spi-agent-xmlrpc/spi_agent_xmlrpc_server	$@/usr/local/libexec
	install -cm 0755 $(RASPBERRYPI_LPC1114_SRC)/spi-agent-zeromq/spi_agent_zeromq_server	$@/usr/local/libexec
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
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/spi-agent clean
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/spi-agent-http clean
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/spi-agent-linx clean
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/spi-agent-oncrpc clean
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/spi-agent-remoteio clean
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/spi-agent-xmlrpc clean
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/spi-agent-zeromq clean
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/spi-agent-lib/clients/c clean
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/utils/isp clean
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/utils/lpc21isp distclean
	$(MAKE) -C $(RASPBERRYPI_LPC1114_SRC)/utils/reset clean
	rm -rf $(PKGDIR)
	if [ ! -f $(PKGFILE).downloaded ]; then rm -f $(PKGFILE) ; fi

reallyclean: clean
	rm -rf $(PKGDIR) $(PKGFILE) $(PKGFILE).downloaded

distclean: reallyclean
