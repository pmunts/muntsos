# Makefile definitions for building GNU Modula-2 MuntsOS example programs

# Copyright (C)2024, Philip Munts dba Munts Technologies.
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

.PHONY: default clean reallyclean distclean

# Override the following macro to build out of tree:

LIBSIMPLEIO	?= /usr/local/share/libsimpleio
MUNTSOS		?= /usr/local/share/muntsos

include $(LIBSIMPLEIO)/gm2/include/gm2.mk
include $(LIBSIMPLEIO)/gm2/include/libsimpleio.mk
include $(MUNTSOS)/examples/modula2/include/examples.mk

# Compile the test programs

default:
	for F in *.mod ; do $(MAKE) `basename $$F .mod` ; done

# Remove working files

clean: gm2_mk_clean
	for F in *.mod ; do rm -f `basename $$F .mod` ; done

reallyclean: gm2_mk_reallyclean clean

distclean: gm2_mk_distclean reallyclean
