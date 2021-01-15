# Makefile for building a Java application for MuntsOS

# Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

EMBLINUXBASE	?= ../../../../../..

ifneq ($(BOARDNAME),)
# Cross compile for MuntsOS
include $(EMBLINUXBASE)/include/$(BOARDNAME).mk
else
# Native compile for Linux
LIBSIMPLEIO	?= /usr/local/share/libsimpleio
endif

include $(LIBSIMPLEIO)/java/include/java.mk

JAVAC_CLASSPATH	:= .:$(LIBSIMPLEIO)/java/classes:$(EMBLINUXBASE)/examples/java/classes

JAR_COMPONENTS	+= com

# Build the applicaton JAR file

default:
	$(MAKE) Toggle_Speed.jar

# Remove working files

clean: java_mk_clean
	rm -rf $(JAR_COMPONENTS)

reallyclean: java_mk_reallyclean

distclean: java_mk_distclean
