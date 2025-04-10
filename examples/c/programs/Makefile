# Makefile for building C programs for MuntsOS Embedded Linux

# Copyright (C)2015-2024, Philip Munts dba Munts Technologies.
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

.PHONY: default clean

LIBSIMPLEIO	?= /usr/local/share/libsimpleio
MUNTSOS		?= /usr/local/share/muntsos

include $(MUNTSOS)/include/$(BOARDNAME).mk

CLIBSRC		?= $(MUNTSOS)/examples/c/lib

OBJ		:= $(shell pwd)/obj

CC	 	= $(CROSS_COMPILE)gcc
CFLAGS		+= -Wall $(DEBUGFLAGS) $(EXTRAFLAGS)
CFLAGS		+= -I$(CLIBSRC)
LDFLAGS		+= -L$(OBJ) -lexamples-$(BOARDBASE) -lsimpleio
STRIP		= $(CROSS_COMPILE)strip

# Define a pattern rule to compile a C program

%: %.c
	$(MAKE) -C $(CLIBSRC) OBJ=$(OBJ)
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
	$(STRIP) $@

# Compile programs

default:
	for F in *.c ; do $(MAKE) `basename $$F .c` ; done

# Remove working files

clean:
	rm -rf $(OBJ)
	for F in *.c ; do rm -f `basename $$F .c` ; done

