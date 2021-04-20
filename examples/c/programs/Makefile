# Makefile to build C example programs for MuntsOS

# Copyright (C)2015-2021, Philip Munts, President, Munts AM Corp.
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

include $(MUNTSOS)/include/$(BOARDNAME).mk

CSRC		?= $(MUNTSOS)/examples/c
CLIBSRC		?= $(CSRC)/lib

CC	 	= $(CROSS_COMPILE)gcc
CFLAGS		+= -Wall $(DEBUGFLAGS) $(EXTRAFLAGS)
CFLAGS		+= -I$(CLIBSRC)
LDFLAGS		+= -L$(CLIBSRC) -lexamples-$(BOARDBASE) -lsimpleio
STRIP		= $(CROSS_COMPILE)strip

# Define a pattern rule to compile a C program

%: %.c
	$(MAKE) -C $(CLIBSRC)
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
	$(STRIP) $@

# Compile the test programs

default:
	for F in *.c ; do $(MAKE) `basename $$F .c` ; done

# Remove working files

clean:
	for F in *.c ; do rm -f `basename $$F .c` ; done

reallyclean: clean
	$(MAKE) -C $(CLIBSRC) clean

distclean: reallyclean
