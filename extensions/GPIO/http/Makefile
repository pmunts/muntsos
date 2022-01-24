# Makefile for building GPIO server offering HTTP

# Copyright (C)2016-2022, Philip Munts, President, Munts AM Corp.
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

CFLAGS		= -Wall -D$(BOARDNAME) -I.. -I$(LIBSINCDIR)
ifneq ($(findstring RaspberryPi,$(BOARDNAME)),)
CFLAGS		+= -DRaspberryPi
endif
LDFLAGS		= -lsimpleio

default: gpio_server_http

###############################################################################

# Compile the HTTP server program

gpio_server_http: gpio_server_http.c ../platform.c mongoose/mongoose.c
	$(CROSS_COMPILE)gcc $(CFLAGS) -Imongoose -o $@ $^ $(LDFLAGS) -lpthread

###############################################################################

# Clean out working files

clean:
	rm -rf gpio_server_http

reallyclean: clean

distclean: reallyclean
