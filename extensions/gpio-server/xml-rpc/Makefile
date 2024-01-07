# Makefile for building a GPIO server offering XML-RPC

# Copyright (C)2016-2024, Philip Munts dba Munts Technologies.
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
MUNTSOS		?= /usr/local/share/muntsos

include $(MUNTSOS)/include/$(BOARDNAME).mk

CFLAGS		= -Wall -D$(BOARDNAME) -I.. -I$(LIBSINCDIR)
ifneq ($(findstring RaspberryPi,$(BOARDNAME)),)
CFLAGS		+= -DRaspberryPi
endif
LDFLAGS		= -lsimpleio

default: gpio_server_xmlrpc

###############################################################################

# Compile the XML-RPC server program
gpio_server_xmlrpc: gpio_server_xmlrpc.c
	$(CROSS_COMPILE)gcc $(CFLAGS) -o $@ gpio_server_xmlrpc.c ../platform.c $(LDFLAGS) -lxmlrpc -lxmlrpc_abyss -lxmlrpc_server -lxmlrpc_server_abyss -lxmlrpc_util

###############################################################################

# Clean out working files

clean:
	rm -rf gpio_server_xmlrpc

reallyclean: clean

distclean: reallyclean
