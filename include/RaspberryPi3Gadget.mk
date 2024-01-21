# Global make definitions for Raspberry Pi 3 BCM2837 ARM Linux microcomputer

# Copyright (C)2019-2024, Philip Munts dba Munts Technologies.
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

BOARDBASE	:= RaspberryPi3

include $(MUNTSOS)/include/AArch64.mk
include $(MUNTSOS)/include/RaspberryPi.mk

# Kernel definitions specific to this board

KERNEL		:= kernel8
KERNEL_DEFCONF	:= bcm2711_defconfig
KERNEL_DTB	+= broadcom/bcm2710-rpi-3-b-plus
KERNEL_DTB	+= broadcom/bcm2710-rpi-cm3
KERNEL_DTB	+= broadcom/bcm2710-rpi-zero-2
KERNEL_OVL	+= overlay_map
KERNEL_OVL	+= disable-bt disable-wifi dwc2
KERNEL_OVL	+= anyspi i2c-rtc pwm pwm-2chan
KERNEL_OVL	+= spi1-1cs spi1-2cs spi1-3cs
KERNEL_OVL	+= spi1-2cs spi2-2cs spi2-3cs

include $(MUNTSOS)/include/kernel.mk
