# Global make definitions for Raspberry Pi 2 BCM2836 ARM Linux microcomputer

# Copyright (C)2013-2022, Philip Munts, President, Munts AM Corp.
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

TOOLCHAIN_BUILDER ?= crosstool

include $(MUNTSOS)/include/ARMv7.mk
include $(MUNTSOS)/include/RaspberryPi.mk
include $(MUNTSOS)/include/$(TOOLCHAIN_BUILDER).mk

ifeq ($(TOOLCHAIN_BUILDER), debian)
BOARDBASE	:= $(CONFIGURE_NAME)
else
BOARDBASE	:= RaspberryPi2
endif

KERNEL_DTB	+= bcm2709-rpi-2-b
KERNEL_DTB	+= bcm2710-rpi-2-b
KERNEL_DTB	+= bcm2710-rpi-3-b
KERNEL_DTB	+= bcm2710-rpi-3-b-plus
KERNEL_DTB	+= bcm2710-rpi-cm3
KERNEL_DTB	+= bcm2710-rpi-zero-2

LOADER		= ld-linux-armhf.so.3

include $(MUNTSOS)/include/common.mk
