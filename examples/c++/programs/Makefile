# Makefile for building C++ example programs for MuntsOS

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

# Override the following macro to build out of tree

MUNTSOS		?= ../../..

ifneq ($(BOARDNAME),)
# Cross compile for MuntsOS
include $(MUNTSOS)/include/$(BOARDNAME).mk
else
# Native compile for Linux
LIBSIMPLEIO	?= /usr/local/share/libsimpleio
endif

CXX_SRC		?= $(MUNTSOS)/examples/c++
CXXDEPS		+= libsimpleio++.a
CXXFLAGS	+= -I$(CXX_SRC)/lib

include $(LIBSIMPLEIO)/c++/include/c++.mk
include $(LIBSIMPLEIO)/c++/include/libsimpleio.mk

# Compile the test programs

default:
	for F in *.cpp ; do $(MAKE) `basename $$F .cpp` ; done

# Remove working files

clean: cxx_mk_clean libsimpleio_mk_clean
	for F in *.cpp ; do rm -f `basename $$F .cpp` ; done

reallyclean: clean cxx_mk_reallyclean libsimpleio_mk_reallyclean

distclean: reallyclean cxx_mk_distclean libsimpleio_mk_distclean
