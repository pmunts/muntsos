# Global make definitions for the BeagleBone ARM Linux microcomputer

# Copyright (C)2013-2021, Philip Munts, President, Munts AM Corp.
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

include $(MUNTSOS)/include/ARMv7.mk

BOARDBASE	= BeagleBone
LOADER		= ld-linux-armhf.so.3
PLATFORM_NAME	= beagle

KERNEL_IMGSRC	= zImage
KERNEL_IMG	= BeagleBone.img
KERNEL_DTB	= am335x-bone
KERNEL_DTB	+= am335x-boneblack
KERNEL_DTB	+= am335x-boneblack-wireless
KERNEL_DTB	+= am335x-bonegreen
KERNEL_DTB	+= am335x-bonegreen-wireless
KERNEL_DTB	+= am335x-pocketbeagle
KERNEL_DTB	+= am335x-sancloud-bbe
KERNEL_TARGETS	= $(KERNEL_IMGSRC) dtbs

BOOTFILESDIR	= $(MUNTSOS)/boot/BeagleBone
BOOTKERNELDIR	= $(MUNTSOS)/bootkernel
BOOTKERNELTGZ	= $(BOOTKERNELDIR)/$(BOARDNAME)-Kernel.tgz

# Definitions for the Beagleboard kernel repository

KERNEL_REPOSITORY = https://github.com/beagleboard/linux.git
KERNEL_NAME	= linux-$(PLATFORM_NAME)
KERNEL_CLONE	= /usr/src/$(KERNEL_NAME)
KERNEL_BRANCH	= 5.4
KERNEL_DIST	= $(TEMP)/$(KERNEL_NAME).tar.bz2

TOOLCHAIN_BUILDER ?= crosstool

include $(MUNTSOS)/include/common.mk
include $(MUNTSOS)/include/$(TOOLCHAIN_BUILDER).mk

CFLAGS		+= -DBEAGLEBONE
