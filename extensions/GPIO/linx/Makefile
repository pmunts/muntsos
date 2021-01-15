# Makefile for Raspberry Pi LPC1114 I/O Processor Expansion Board
# SPI Agent National Instruments LabView Linx server program

# Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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
EMBLINUXBASE	?= $(shell pwd)/../../..

include $(EMBLINUXBASE)/include/$(BOARDNAME).mk

LIBSIMPLEIO	?= $(GCCSYSROOT)/usr/share/libsimpleio

CFLAGS		= -Wall -D$(BOARDNAME) -DBOARDNAME='"$(BOARDNAME)"'
CFLAGS		+= -I.. -I$(LIBSIMPLEIO)/c++
LDFLAGS		= -lsimpleio -lstdc++

SOURCES		= main.cpp
SOURCES		+= ../platform.c
SOURCES		+= $(LIBSIMPLEIO)/c++/linx-server/command.cpp
SOURCES		+= $(LIBSIMPLEIO)/c++/linx-server/common.cpp
SOURCES		+= $(LIBSIMPLEIO)/c++/linx-server/executive.cpp
SOURCES		+= $(LIBSIMPLEIO)/c++/linx-server/gpio.cpp
SOURCES		+= $(LIBSIMPLEIO)/c++/linx-server/gpio-libsimpleio-sysfs.cpp

default: gpio_server_linx

###############################################################################

# Compile the server program

gpio_server_linx: $(SOURCES)

	$(CROSS_COMPILE)gcc $(CFLAGS) -o $@ $^ $(LDFLAGS)

###############################################################################

# Remove working files

clean:
	rm -f gpio_server_linx

reallyclean: clean

disclean: reallyclean
