# Makefile to build GPIO ONC-RPC client program

# Copyright (C)2013-2018, Philip Munts, President, Munts AM Corp.
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

ifneq ($(BOARDNAME),)
# Cross-compile for MuntsOS
EMBLINUXBASE	?= ../../../../..
include $(EMBLINUXBASE)/include/$(BOARDNAME).mk
endif

PROGRAMS	= Button_And_LED Toggle_Speed
STUBS		= gpio_server_oncrpc_clnt.c gpio_server_oncrpc_xdr.c

CC	 	= $(CROSS_COMPILE)gcc
CFLAGS		+= -Wall $(DEBUGFLAGS) $(EXTRAFLAGS)
RPCGENFLAGS	+= -N

ifeq ($(findstring CYGWIN, $(shell uname)), CYGWIN)
CFLAGS		+= -DCYGWIN -I/usr/include/tirpc
LDFLAGS		+= -ltirpc
endif

ifeq ($(shell uname), Darwin)
CFLAGS		+= -D__STDC__=0
endif

default: $(PROGRAMS)

###############################################################################

# Compile interface definition to create C client stubs

gpio_server_oncrpc.x:
	cp ../../../onc-rpc/gpio_server_oncrpc.x .

gpio_server_oncrpc.h: gpio_server_oncrpc.x
	rpcgen $(RPCGENFLAGS) $<

gpio_server_oncrpc_clnt.c: gpio_server_oncrpc.h

gpio_server_oncrpc_xdr.c: gpio_server_oncrpc.h

###############################################################################

# Compile the client programs

Button_And_LED: Button_And_LED.c $(STUBS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

Toggle_Speed: Toggle_Speed.c $(STUBS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

###############################################################################

# Remove working files

clean:
	rm -f $(PROGRAMS)
	rm -f gpio_server_oncrpc.h
	rm -f gpio_server_oncrpc.x
	rm -f gpio_server_oncrpc_clnt.c
	rm -f gpio_server_oncrpc_svc.c
	rm -f gpio_server_oncrpc_xdr.c

reallyclean: clean

distclean: reallyclean
