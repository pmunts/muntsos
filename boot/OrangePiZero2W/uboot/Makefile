# Build U-Boot for Orange Pi Zero 2 W

# Copyright (C)2024, Philip Munts dba Munts Technologies.
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

MUNTSOS		?= ../..
BOARDNAME	?= OrangePiZero2W

include $(MUNTSOS)/include/$(BOARDNAME).mk

default: uboot

###############################################################################

# Build Trusted Firmware

BL31_URL	:= https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git
BL31_SRC	:= trusted-firmware-a
BL31_MAKEOPTS	:= CROSS_COMPILE=$(CROSS_COMPILE) PLAT=sun50i_h616 DEBUG=1
BL31_BIN	:= $(shell pwd)/bl31.bin

$(BL31_BIN):
	git clone --depth 1 $(BL31_URL)
	$(MAKE) -C $(BL31_SRC) $(BL31_MAKEOPTS)
	cp $(BL31_SRC)/build/sun50i_h616/debug/bl31.bin $@
	touch $@

bl31: $(BL31_BIN)

###############################################################################

# Build U-Boot

UBOOT_URL	:= https://github.com/u-boot/u-boot.git
UBOOT_SRC	:= u-boot
UBOOT_MAKEOPTS	:= BL31=$(BL31_BIN) CROSS_COMPILE=$(CROSS_COMPILE)
UBOOT_BIN	:= $(shell pwd)/u-boot-sunxi-with-spl.bin

$(UBOOT_SRC):
	git clone --depth 1 $(UBOOT_URL)
	cd $(UBOOT_SRC) ; patch -b -p0 <../uboot.patch
	touch $@

$(UBOOT_BIN): $(BL31_BIN) $(UBOOT_SRC)
	cp uboot.config $(UBOOT_SRC)/.config
	$(MAKE) -C $(UBOOT_SRC) $(UBOOT_MAKEOPTS) oldconfig
	$(MAKE) -C $(UBOOT_SRC) $(UBOOT_MAKEOPTS)
	cp u-boot/u-boot-sunxi-with-spl.bin $@
	touch $@

uboot: $(UBOOT_BIN)

menuconfig: $(BL31_BIN) $(UBOOT_SRC)
	cp uboot.config $(UBOOT_SRC)/.config
	$(MAKE) -C $(UBOOT_SRC) $(UBOOT_MAKEOPTS) oldconfig
	$(MAKE) -C $(UBOOT_SRC) $(UBOOT_MAKEOPTS) menuconfig
	cp $(UBOOT_SRC)/.config uboot.config

###############################################################################

# Remove working files

clean:
	rm -rf $(BL31_SRC) $(UBOOT_SRC)
