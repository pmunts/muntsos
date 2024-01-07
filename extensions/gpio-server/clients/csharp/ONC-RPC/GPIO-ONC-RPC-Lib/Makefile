# Generic Makefile template for building C# applications

# Copyright (C)2014-2024, Philip Munts dba Munts Technologies.
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

MUNTSOS		?= $(shell pwd)/../../../../../..
CSHARPSRC	?= $(MUNTSOS)/examples/csharp

RPCGEN		= mono $(CSHARPSRC)/utilities/jrpcgen.exe -noserver
CONFIGURATION	= Release

default: GPIO-ONC-RPC-Lib.dll

# Build the projects

GPIO-ONC-RPC-Lib.dll:
	"$(MSBUILD)" $(MSBUILDTARGET) $(MSBUILDFLAGS) GPIO-ONC-RPC-Lib-DLL.csproj

# Build the library help file

ifeq ($(OS),Windows_NT)
ifeq ($(CONFIGURATION), Release)
GPIO-ONC-RPC-Lib.chm: GPIO-ONC-RPC-Lib.dll
	"$(MSBUILD)" GPIO-ONC-RPC-Lib-Help.shfbproj
endif
endif

# Release the assembly and help file

ifeq ($(OS),Windows_NT)
ifeq ($(CONFIGURATION), Release)
release: GPIO-ONC-RPC-Lib.dll GPIO-ONC-RPC-Lib.chm
	cp GPIO-ONC-RPC-Lib.dll prebuilt
	cp GPIO-ONC-RPC-Lib.xml prebuilt
	cp GPIO-ONC-RPC-Lib.chm prebuilt
endif
endif

# Compile RPC definitions

gpio_server_oncrpc.cs:
	cp $(MUNTSOS)/extensions/GPIO/onc-rpc/gpio_server_oncrpc.x .
	$(RPCGEN) gpio_server_oncrpc.x
	rm gpio_server_oncrpc.x

# Remove working files

clean: csharp_mk_clean

# Include subordinate makefiles

include $(CSHARPSRC)/include/csharp.mk
