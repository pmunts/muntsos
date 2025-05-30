# Build U-Boot and friends for Orange Pi Zero 2 W

# Copyright (C)2024-2025, Philip Munts dba Munts Technologies.
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

.PHONY: bl31 defconfig menuconfig uboot tarball clean reallyclean distclean

MUNTSOS		?= ../../..
BOARDNAME	?= OrangePiZero2W

include $(MUNTSOS)/include/$(BOARDNAME).mk

default: tarball

###############################################################################

# Build Trusted Firmware

BL31_URL	:= https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git
BL31_SRC	:= trusted-firmware-a
BL31_MAKEOPTS	:= CROSS_COMPILE=$(CROSS_COMPILE) PLAT=sun50i_h616 DEBUG=1
BL31_BIN	:= $(shell pwd)/$(BL31_SRC)/build/sun50i_h616/debug/bl31.bin

$(BL31_BIN):
	git clone --depth 1 $(BL31_URL)
	$(MAKE) -C $(BL31_SRC) $(BL31_MAKEOPTS)
	touch $@
	pandoc -f rst -t plain $(BL31_SRC)/docs/license.rst >release/LICENSE.bl31

bl31: $(BL31_BIN)

###############################################################################

# Build U-Boot

UBOOT_URL	:= https://github.com/u-boot/u-boot.git
UBOOT_TAG	:= v2024.10
UBOOT_SRC	:= src
UBOOT_MAKEOPTS	:= BL31=$(BL31_BIN) CROSS_COMPILE=$(CROSS_COMPILE)
UBOOT_BIN	:= $(shell pwd)/$(UBOOT_SRC)/u-boot-sunxi-with-spl.bin

$(UBOOT_SRC):
	git clone --branch $(UBOOT_TAG) --depth 1 $(UBOOT_URL) $(UBOOT_SRC)
	cd $(UBOOT_SRC) ; patch -b -p0 <../uboot.patch
	touch $@

defconfig: $(BL31_BIN) $(UBOOT_SRC)
	$(MAKE) -C $(UBOOT_SRC) $(UBOOT_MAKEOPTS) orangepi_zero2w_defconfig
	cp $(UBOOT_SRC)/.config uboot.config

menuconfig: $(BL31_BIN) $(UBOOT_SRC)
	cp uboot.config $(UBOOT_SRC)/.config
	$(MAKE) -C $(UBOOT_SRC) $(UBOOT_MAKEOPTS) oldconfig
	$(MAKE) -C $(UBOOT_SRC) $(UBOOT_MAKEOPTS) menuconfig
	cp $(UBOOT_SRC)/.config uboot.config

$(UBOOT_BIN): $(BL31_BIN) $(UBOOT_SRC)
	cp uboot.config $(UBOOT_SRC)/.config
	$(MAKE) -C $(UBOOT_SRC) $(UBOOT_MAKEOPTS) oldconfig
	$(MAKE) -C $(UBOOT_SRC) $(UBOOT_MAKEOPTS)
	touch $@
	cp $(UBOOT_BIN) release
	cp $(UBOOT_SRC)/Licenses/README release/LICENSE.u-boot

uboot: $(UBOOT_BIN)

###############################################################################

tarball:
	rm -rf			bootfiles.d
	mkdir -p		bootfiles.d/u-boot
	cp -r release/*		bootfiles.d/u-boot
	$(MAKE) -C scripts
	cp scripts/*.scr	bootfiles.d
	cd bootfiles.d && find * -type f -exec md5sum -b {} ";" | LC_ALL=C sort -k 2 >bootfiles.md5
	cd bootfiles.d && tar czf ../$(BOOTFILESTGZ) * --owner=root --group=root --mode=ugo-w --sort=name

###############################################################################

# Remove working files

clean:
	$(MAKE) -C scripts clean
	rm -rf bootfiles.d

reallyclean: clean
	rm -rf $(BL31_SRC) $(UBOOT_SRC)

distclean: reallyclean
