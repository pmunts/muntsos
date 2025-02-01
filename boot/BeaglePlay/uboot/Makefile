# Build U-Boot and friends for BeaglePlay

# Copyright (C)2025, Philip Munts dba Munts Technologies.
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

.PHONY: bl31 optee defconfig menuconfig uboot tarball sources clean reallyclean distclean

MUNTSOS		?= ../../..
BOARDNAME	?= BeaglePlay

include $(MUNTSOS)/include/$(BOARDNAME).mk

default: tarball

###############################################################################

# Build Trusted Firmware

BL31_URL	:= https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git
BL31_SRC	:= trusted-firmware-a.src
BL31_BIN	:= $(shell pwd)/$(BL31_SRC)/build/k3/lite/release/bl31.bin

BL31_MAKEOPTS	+= CROSS_COMPILE=$(CROSS_COMPILE)
BL31_MAKEOPTS	+= PLAT=k3 SPD=opteed TARGET_BOARD=lite

$(BL31_SRC):
	git clone --branch master --depth 1 $(BL31_URL) $(BL31_SRC)
	pandoc -f rst -t plain $(BL31_SRC)/docs/license.rst >release/LICENSE.bl31

$(BL31_BIN): $(BL31_SRC)
	$(MAKE) -C $(BL31_SRC) $(BL31_MAKEOPTS)
	touch $@

bl31: $(BL31_BIN)

###############################################################################

# Build OP-TEE

OPTEE_URL	:= https://github.com/OP-TEE/optee_os.git
OPTEE_SRC	:= optee.src
OPTEE_BIN	:= $(shell pwd)/$(OPTEE_SRC)/out/arm-plat-k3/core/tee-raw.bin

OPTEE_MAKEOPTS	= CROSS_COMPILE=/usr/local/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-
OPTEE_MAKEOPTS	+= CROSS_COMPILE64=$(CROSS_COMPILE)
OPTEE_MAKEOPTS	+= CFG_ARM64_core=y
OPTEE_MAKEPOTS	+= CFG_WITH_SOFTWARE_PRNG=y
OPTEE_MAKEOPTS	+= PLATFORM=k3-am62x

$(OPTEE_SRC):
	git clone --branch master --depth 1 $(OPTEE_URL) $(OPTEE_SRC)
	cp $(OPTEE_SRC)/LICENSE release/LICENSE.op-tee

$(OPTEE_BIN): $(OPTEE_SRC)
	$(MAKE) -C $(OPTEE_SRC) $(OPTEE_MAKEOPTS)
	touch $@

optee: $(OPTEE_BIN)

###############################################################################

# Fetch firmware

FW_URL		:= https://git.ti.com/git/processor-firmware/ti-linux-firmware.git
FW_SRC		:= $(shell pwd)/ti-linux-firmware.src

$(FW_SRC):
	git clone --branch ti-linux-firmware --depth 1 $(FW_URL) $(FW_SRC)
	cp $(FW_SRC)/LICENCE.ti-connectivity release/LICENSE.ti

firmware: $(FW_SRC)

###############################################################################

# Build U-Boot

UBOOT_URL	:= https://github.com/u-boot/u-boot.git
UBOOT_SRC	:= uboot.src
UBOOT_BIN	:= $(UBOOT_SRC)/u-boot.img

UBOOT_MAKEOPTS	:= BL31=$(BL31_BIN) CROSS_COMPILE=$(CROSS_COMPILE)

UBOOT_MAKEOPTS	+= CROSS_COMPILE=$(CROSS_COMPILE)
UBOOT_MAKEOPTS	+= BINMAN_INDIRS=$(FW_SRC)
UBOOT_MAKEOPTS	+= BL31=$(BL31_BIN)
UBOOT_MAKEOPTS	+= TEE=$(OPTEE_BIN)

$(UBOOT_SRC):
	git clone --branch master --depth 1 $(UBOOT_URL) $(UBOOT_SRC)
	cd $(UBOOT_SRC) ; patch -b -p0 <../uboot.patch
	cp $(UBOOT_SRC)/Licenses/README release/LICENSE.u-boot
	touch $@

defconfig: $(UBOOT_SRC)
	$(MAKE) -C $(UBOOT_SRC) $(UBOOT_MAKEOPTS) am62x_beagleplay_a53_defconfig
	cp $(UBOOT_SRC)/.config uboot.config

menuconfig: $(UBOOT_SRC)
	cp uboot.config $(UBOOT_SRC)/.config
	$(MAKE) -C $(UBOOT_SRC) $(UBOOT_MAKEOPTS) oldconfig
	$(MAKE) -C $(UBOOT_SRC) $(UBOOT_MAKEOPTS) menuconfig
	cp $(UBOOT_SRC)/.config uboot.config

oldconfig: $(UBOOT_SRC)
	cp uboot.config $(UBOOT_SRC)/.config
	$(MAKE) -C $(UBOOT_SRC) $(UBOOT_MAKEOPTS) oldconfig
	cp $(UBOOT_SRC)/.config uboot.config

$(UBOOT_BIN): $(BL31_BIN) $(OPTEE_BIN) $(FW_SRC) $(UBOOT_SRC)
	cp uboot.config $(UBOOT_SRC)/.config
	$(MAKE) -C $(UBOOT_SRC) $(UBOOT_MAKEOPTS) oldconfig
	$(MAKE) -C $(UBOOT_SRC) $(UBOOT_MAKEOPTS)
	touch $@
	cp $(UBOOT_BIN) release
	cd release && md5sum -b * | grep -v u-boot.md5 >u-boot.md5

uboot: $(UBOOT_BIN)

###############################################################################

tarball:
	rm -rf			bootfiles.d
	mkdir -p		bootfiles.d/u-boot
	cp release/*		bootfiles.d/u-boot
	$(MAKE) -C scripts
	cp scripts/*.scr	bootfiles.d
	cd bootfiles.d && find * -type f -exec md5sum -b {} ";" | LC_ALL=C sort -k 2 >bootfiles.md5
	cd bootfiles.d && tar czf ../$(BOOTFILESTGZ) * --owner=root --group=root --mode=ugo-w --sort=name

###############################################################################

sources: $(BL31_SRC) $(OPTEE_SRC) $(FW_SRC) $(UBOOT_SRC)

###############################################################################

# Remove working files

clean:
	$(MAKE) -C scripts clean
	rm -rf bootfiles.d

reallyclean: clean
	rm -rf *.scr *.src

distclean: reallyclean
