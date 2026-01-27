# Makefile for building a MuntsOS Embedded Linux Java example program

# Copyright (C)2026, Philip Munts dba Munts Technologies.
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

LIBSIMPLEIO	?= /usr/local/share/libsimpleio

include $(LIBSIMPLEIO)/attic/java/include/java.mk

JAR_COMPONENTS	+= com

# Infer program name from project directory name

PROGRAM_NAME	:= $(shell basename `pwd`)

# Override the .class rule, to unpack library jar files

%.class: %.java
	rm -rf $(JAR_COMPONENTS)
	jar xf $(LIBSIMPLEIO)/attic/java/jars/jna.jar         com/sun
	jar xf $(LIBSIMPLEIO)/attic/java/jars/libsimpleio.jar com/munts
	$(JAVAC) $(JAVAC_FLAGS) $<

# Override the .manifest rule, to enable native method access

%.manifest: %.class
	echo "Main-Class: $*" >$@
	echo "Permissions: $(JAR_PERMISSIONS)" >>$@
	echo "Enable-Native-Access: ALL-UNNAMED" >>$@

# Build applicaton program jar file

default: $(PROGRAM_NAME)

# Remove working files

clean: java_mk_clean

reallyclean: java_mk_reallyclean

distclean: java_mk_distclean
