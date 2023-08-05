# Global make definitions for Raspberry Pi 1 BCM2835 ARM Linux microcomputer

# Copyright (C)2013-2023, Philip Munts dba Munts Technologies.
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

include $(MUNTSOS)/include/ARMv6.mk
include $(MUNTSOS)/include/RaspberryPi.mk
include $(MUNTSOS)/include/$(TOOLCHAIN_BUILDER).mk

BOARDBASE	:= RaspberryPi1

KERNEL_DTB	+= bcm2708-rpi-b
KERNEL_DTB	+= bcm2708-rpi-b-plus
KERNEL_DTB	+= bcm2708-rpi-b-rev1
KERNEL_DTB	+= bcm2708-rpi-cm
KERNEL_DTB	+= bcm2708-rpi-zero
KERNEL_DTB	+= bcm2708-rpi-zero-w

LOADER		= ld-linux-armhf.so.3

include $(MUNTSOS)/include/common.mk
