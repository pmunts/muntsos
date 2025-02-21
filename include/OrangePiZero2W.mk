# Global make definitions for the Orange Pi Zero 2 W ARM Linux microcomputer

# Copyright (C)2023-2025, Philip Munts dba Munts Technologies.
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

BOARDBASE	:= OrangePiZero2W
BOARDBASELC	:= $(shell echo $(BOARDBASE) | tr A-Z a-z)
BOARDNAMELC	:= $(shell echo $(BOARDNAME) | tr A-Z a-z)

include $(MUNTSOS)/include/AArch64.mk

BOOTFILESDIR	= $(MUNTSOS)/boot/$(BOARDBASE)
BOOTFILESTGZ	= $(BOOTFILESDIR)/bootfiles.tgz
BOOTKERNELDIR	= $(MUNTSOS)/bootkernel
BOOTKERNELTGZ	= $(BOOTKERNELDIR)/$(BOARDNAME)-Kernel.tgz

KERNEL_DEFCONF	= linux_sunxi64_defconfig
KERNEL_IMGSRC	= Image
KERNEL_IMG	= $(BOARDNAME).img
KERNEL_DTB	= allwinner/sun50i-h618-orangepi-zero2w
KERNEL_TARGETS	= $(KERNEL_IMGSRC)

# Definitions for the kernel repository

KERNEL_REPO     = https://github.com/orangepi-xunlong/linux-orangepi.git
KERNEL_BRANCH	= 6.1
KERNEL_TREEISH	= orange-pi-$(KERNEL_BRANCH)-sun50iw9
KERNEL_NAME	= linux-orangepizero2w-$(KERNEL_BRANCH)

# Can't use GCC 14 for the Orange Pi Zero 2W kernel
KCROSS_COMPILE	= /usr/local/gcc-aarch64-none-elf

CFLAGS		+= -DORANGEPIZERO2W

include $(MUNTSOS)/include/kernel.mk
