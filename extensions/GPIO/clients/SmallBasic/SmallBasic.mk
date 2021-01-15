# Makefile for building Small Basic applications

# Copyright (C)2014-2018, Philip Munts, President, Munts AM Corp.
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

# Toolchain definitions

SBC	?= $(PROGRAMFILES)/Microsoft/Small Basic/SmallBasicCompiler.exe

# These targets are not files

.PHONY: smallbasic_mk_default smallbasic_mk_clean

# Don't delete intermediate files

.SECONDARY:

# Small Basic suffix rules

.SUFFIXES: .exe .sb

.sb.exe:
	"$(SBC)" $<

# Define default target placeholder

smallbasic_mk_default:
	@echo ERROR: You must explicitly specify a make target!
	@exit 1

# Clean out working files

smallbasic_mk_clean:
	rm -rf *.dll
	rm -rf *.exe
	rm -rf *.pdb
