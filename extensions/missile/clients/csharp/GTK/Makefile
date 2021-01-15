# Makefile for building the Mono GTK# Missile Launcher Client

# Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

EMBLINUXBASE		?= ../../../../..
CSHARPSRC		?= $(EMBLINUXBASE)/examples/csharp

default: MissileClientGTK.exe

# Build the project

MissileClientGTK.exe: csharp_mk_build

ifeq ($(OS), Windows_NT)
# Build Windows desktop application installer

INNOSETUPCOMPILER	?= iscc

installer: MissileClientGTK.exe
	$(INNOSETUPCOMPILER) MissileClientGTK.iss
endif

ifeq ($(shell uname), Darwin)
# Build MacOS app bundle

bundle: MissileClientGTK.app

zipfile: MissileClientGTK.zip
endif

# Remove working files

clean: csharp_mk_clean
ifeq ($(shell uname), Darwin)
	-chmod -R u+w *.app
	rm -rf *.app *.zip
endif

# Include subordinate makefiles

include $(CSHARPSRC)/include/csharp.mk
