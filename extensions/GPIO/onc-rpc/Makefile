# Makefile for building a GPIO server offering ONC-RPC

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
MUNTSOS		?= $(shell pwd)/../../..

include $(MUNTSOS)/include/$(BOARDNAME).mk

CFLAGS		= -Wall -D$(BOARDNAME) -I.. -I$(GCCSYSROOT)/usr/include/tirpc
ifneq ($(findstring RaspberryPi,$(BOARDNAME)),)
CFLAGS		+= -DRaspberryPi
endif
LDFLAGS		= -lsimpleio -ltirpc

default: gpio_server_oncrpc

###############################################################################

# Compile RPC definitions

gpio_server_oncrpc.h: gpio_server_oncrpc.x
	rpcgen -C -M -N $<
	patch -b -p0 <gpio_server_oncrpc.patch

###############################################################################

# Compile the ONC-RPC server program

gpio_server_oncrpc: gpio_server_oncrpc.h
	$(CROSS_COMPILE)gcc $(CFLAGS) -o $@ gpio_server_oncrpc.c ../platform.c gpio_server_oncrpc_svc.c gpio_server_oncrpc_xdr.c $(LDFLAGS)

###############################################################################

# Clean out working files

clean:
	rm -f gpio_server_oncrpc
	rm -f gpio_server_oncrpc.h gpio_server_oncrpc_clnt.c
	rm -f gpio_server_oncrpc_svc.c gpio_server_oncrpc_svc.c.orig
	rm -f gpio_server_oncrpc_xdr.c

reallyclean: clean

distclean: reallyclean
