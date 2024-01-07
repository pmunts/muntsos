# Makefile for building a Mikropascal PIC application program

# Copyright (C)2017-2024, Philip Munts dba Munts Technologies.
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

# Keep intermediate (especially .hex) files

.SECONDARY:

# Compiler definitions

MIKROPASCAL	?= "C:/Users/Public/Documents/Mikroelektronika/mikroPascal PRO for PIC/mPPIC.exe"

COMMONDIR	?= $(FIRMWARESRC)/common

WORKINGFILES	+= *.asm *.bin *.bmk *.brk *.dbg *.dct *.dlt *.*mcl
WORKINGFILES	+= *.log *.lst *callertable.txt *.ini *.user.dic
WORKINGFILES	+= $(COMMONDIR)/*.asm $(COMMONDIR)/*.ini $(COMMONDIR)/*.*mcl

# Define a pattern rule to build a Mikropascal PIC project

%.hex: %.mpppi
	$(MIKROPASCAL) -DL -O11111114 -Y -PF $<

# Remove working files

mikropascal_mk_clean:
	rm -f $(WORKINGFILES)

mikropascal_mk_reallyclean: mikropascal_mk_clean
	rm -f *.hex

mikropascal_mk_distclean: mikropascal_mk_reallyclean

# Include subordinate makefiles

include $(FIRMWARESRC)/PIC/mikroprog.mk
