# Global make definitions for Raspberry Pi BCM283x ARM Linux microcomputer

# Copyright (C)2013-2020, Philip Munts, President, Munts AM Corp.
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

# The original Raspberry Pi (1) is obsolete, but it still serves as the
# base upon which software for the newer boards is built.  Their makefiles
# will include this one and override macros as necessary.

include $(EMBLINUXBASE)/include/ARMv6.mk

LOADER		= ld-linux-armhf.so.3
MUNTSOS		= yes
PLATFORM_NAME	= rpi

KERNEL_IMGSRC	= Image
KERNEL_IMG	= $(BOARDNAME).img
KERNEL_TARGETS	= $(KERNEL_IMGSRC) dtbs
KERNEL_OVL	= disable-bt disable-wifi
KERNEL_OVL	+= pwm pwm-2chan
KERNEL_OVL	+= spi1-1cs spi1-2cs spi1-3cs
KERNEL_OVL	+= spi1-2cs spi2-2cs spi2-3cs

BOOTFILESDIR	= $(EMBLINUXBASE)/boot/RaspberryPi
BOOTKERNELDIR	= $(EMBLINUXBASE)/bootkernel
BOOTKERNELTGZ	= $(BOOTKERNELDIR)/$(BOARDNAME)-Kernel.tgz

# Definitions for the Raspberry Pi kernel repository

KERNEL_REPOSITORY = http://github.com/raspberrypi/linux.git
KERNEL_NAME	= linux-$(PLATFORM_NAME)
KERNEL_CLONE	= /usr/src/$(KERNEL_NAME)
KERNEL_BRANCH	= rpi-5.4.y
KERNEL_DIST	= $(TEMP)/$(KERNEL_NAME).tar.bz2

TOOLCHAIN_BUILDER ?= crosstool

include $(EMBLINUXBASE)/include/common.mk
include $(EMBLINUXBASE)/include/$(TOOLCHAIN_BUILDER).mk

CFLAGS		+= -DRASPBERRYPI
