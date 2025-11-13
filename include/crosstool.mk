# Global definitions for cross-toolchains built with Crosstool-NG

# Copyright (C)2017-2025, Philip Munts dba Munts Technologies.
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

# See also: https://crosstool-ng.github.io

CONFIGURE_NAME	= $(GCCARCH)-muntsos-linux-$(GCCABI)
ifeq ($(GCCARCH), aarch64)
TOOLCHAIN_NAME	= $(CONFIGURE_NAME)-ctng
else ifeq ($(GCCARCH), riscv64)
TOOLCHAIN_NAME	= $(CONFIGURE_NAME)-ctng
else
TOOLCHAIN_NAME	= $(CONFIGURE_NAME)-ctng-$(BOARDBASELC)
endif
ifeq ($(OS), Windows_NT)
TOOLCHAIN_DIR	= C:/PROGRA~1/gcc-$(TOOLCHAIN_NAME)
else
TOOLCHAIN_DIR	= /usr/local/gcc-$(TOOLCHAIN_NAME)
endif
TOOLCHAIN_REV	= 11
CROSS_COMPILE	= $(TOOLCHAIN_DIR)/bin/$(CONFIGURE_NAME)-
GCCSYSROOT	= $(TOOLCHAIN_DIR)/$(CONFIGURE_NAME)/libc
LIBSDIR		= $(GCCSYSROOT)/usr
LIBSBINDIR	= $(GCCSYSROOT)/usr/bin
LIBSETCDIR	= $(GCCSYSROOT)/usr/etc
LIBSINCDIR	= $(GCCSYSROOT)/usr/include
LIBSLIBDIR	= $(GCCSYSROOT)/usr/lib
LIBSPKGCONFIG	= $(GCCSYSROOT)/usr/lib/pkgconfig
LIBSSBINDIR	= $(GCCSYSROOT)/usr/sbin
LIBSSHAREDIR	= $(GCCSYSROOT)/usr/share

GCCVER		= $(shell $(CROSS_COMPILE)gcc --version | awk '/gcc/ { print $$4 }')

# Linux Simple I/O Library

LIBSIMPLEIO	?= /usr/local/share/libsimpleio

# C/C++

CFLAGS		+= -DMUNTSOS

# Free Pascal

FPC		= /usr/local/fpc-$(TOOLCHAIN_NAME)/bin/fpc
FPC_FLAGS	+= -dMUNTSOS

# GNAT Ada

GNATPREFIX	= $(CROSS_COMPILE)
GNATADAVERSION	= -gnat2022
# The following list of compiler options needs to be kept consistent with
# ../toolchain/libsimpleio/libsimpleio.gpr
GNATMAKECFLAGS	+= -O3
GNATMAKECFLAGS	+=-ffunction-sections
GNATMAKECFLAGS	+=-fdata-sections
#GNATMAKECFLAGS	+=-gnata     (set in ada.mk)
GNATMAKECFLAGS	+=-gnato1
GNATMAKECFLAGS	+=-gnatVa
GNATMAKECFLAGS	+=-gnatwa
GNATMAKECFLAGS	+=-gnatwJ
GNATMAKECFLAGS	+=-gnatwK
#GNATMAKECFLAGS	+=-gnat2022  (set in ada.mk)
GNATMAKELDFLAGS	+= -shared-libgcc
GPRBUILD	?= $(TOOLCHAIN_DIR)/bin/gprbuild
GPRBUILDCONFIG	= --config=$(TOOLCHAIN_DIR)/share/gpr/$(CONFIGURE_NAME).cgpr

# Alire

ALRFLAGS	+= -- $(GPRBUILDCONFIG)
