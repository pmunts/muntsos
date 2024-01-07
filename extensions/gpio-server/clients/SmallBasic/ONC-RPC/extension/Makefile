# Makefile for building the Small Basic GPIO Client Extension

# Copyright (C)2016-2024, Philip Munts dba Munts Technologies.
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

# Override the following macros to build out of tree

MUNTSOS			?= ../../../../../..
CSHARPSRC		?= $(MUNTSOS)/examples/csharp

RPCGEN			= mono $(CSHARPSRC)/utilities/jrpcgen.exe -noserver
CONFIGURATION		= Release
DLLVERSION		= $(shell sigcheck -a GPIO-Extension.dll 2>&1 | awk '/Prod version/ { print $$3 }')
INNOSETUPCOMPILER	?= iscc

# Build the DLL project

default: installer

# Compile RPC definitions

gpio_server_oncrpc.cs:
	cp $(MUNTSOS)/extensions/GPIO/gpio_server_oncrpc.x .
	$(RPCGEN) gpio_server_oncrpc.x
	rm gpio_server_oncrpc.x

# Build the installer

installer: csharp_mk_build
	$(INNOSETUPCOMPILER) /dCONFIGURATION=$(CONFIGURATION) /dDLLVERSION=$(DLLVERSION) GPIO-Extension.iss

# Remove working files

clean: csharp_mk_clean

# Include subordinate makefiles

include $(CSHARPSRC)/include/csharp.mk
