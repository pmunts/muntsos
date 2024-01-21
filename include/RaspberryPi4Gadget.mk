# Global make definitions for Raspberry Pi 4 BCM2711 ARM Linux microcomputer

# Copyright (C)2020-2024, Philip Munts dba Munts Technologies.
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

include $(MUNTSOS)/include/AArch64.mk
include $(MUNTSOS)/include/RaspberryPi.mk
include $(MUNTSOS)/include/$(TOOLCHAIN_BUILDER).mk

BOARDBASE	:= RaspberryPi3

KERNEL		:= kernel8
KERNEL_DEFCONF	:= bcm2711_defconfig
KERNEL_DTB	+= broadcom/bcm2711-rpi-4-b
KERNEL_DTB	+= broadcom/bcm2711-rpi-cm4
KERNEL_DTB	+= broadcom/bcm2711-rpi-cm4s
KERNEL_OVL	+= overlay_map
KERNEL_OVL	+= disable-bt disable-wifi dwc2
KERNEL_OVL	+= anyspi i2c-rtc pwm pwm-2chan
KERNEL_OVL	+= spi1-1cs spi1-2cs spi1-3cs
KERNEL_OVL	+= spi1-2cs spi2-2cs spi2-3cs
KERNEL_OVL	+= i2c3 i2c4 i2c5 i2c6
KERNEL_OVL	+= spi3-1cs spi3-2cs spi4-1cs spi4-2cs
KERNEL_OVL	+= spi5-1cs spi5-2cs spi6-1cs spi6-2cs
KERNEL_OVL	+= uart2 uart3 uart4 uart5

include $(MUNTSOS)/include/common.mk
