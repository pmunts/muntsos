# Global make definitions for Raspberry Pi 2 BCM2836 ARM Linux microcomputer

# Copyright (C)2013-2024, Philip Munts dba Munts Technologies.
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

BOARDBASE	:= RaspberryPi2

include $(MUNTSOS)/include/ARMv7.mk
include $(MUNTSOS)/include/RaspberryPi.mk

# Kernel definitions specific to this board

KERNEL		:= kernel7
KERNEL_DEFCONF	:= bcm2709_defconfig
KERNEL_DTB	+= bcm2709-rpi-2-b
KERNEL_OVL	+= disable-bt disable-wifi dwc2
KERNEL_OVL	+= anyspi i2c-rtc pca953x pwm pwm-2chan
KERNEL_OVL	+= spi1-1cs spi1-2cs spi1-3cs
KERNEL_OVL	+= spi1-2cs spi2-2cs spi2-3cs

include $(MUNTSOS)/include/kernel.mk
