# Makefile to build the C examples software component library

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

# Modify the following macro to build out of tree

MUNTSOS		?= ../../..

ifneq ($(BOARDNAME),)
# Cross-compile for MuntsOS
include $(MUNTSOS)/include/$(BOARDNAME).mk
CFLAGS		+= -D$(BOARDNAME)
else
# Native compile for Linux
BOARDBASE	:= $(shell $(CROSS_COMPILE)gcc -dumpmachine)
endif

AR		= $(CROSS_COMPILE)ar
CC	 	= $(CROSS_COMPILE)gcc
CFLAGS		+= -Wall -I. $(DEBUGFLAGS) $(EXTRAFLAGS)

default: libexamples-$(BOARDBASE).a

# Compile the library components

libexamples-$(BOARDBASE).a:
	for F in *.c ; do $(CC) $(CFLAGS) -c -o `basename $$F .c`.o $$F ; done
	$(AR) rcs $@ *.o

# Remove working files

clean:
	rm -rf *.o *.a
