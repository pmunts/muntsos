# Makefile for an embedded Linux boot kernel

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

MUNTSOS		?= ../..
BOARDNAME	?= UNDEFINED
MAKEJOBS	?= -j 2

include $(MUNTSOS)/include/$(BOARDNAME).mk

default: build.done

###############################################################################

# Prepare kernel source tree

src.done: $(KERNEL_DIST)
	rm -rf $(KERNEL_SRC)
	mkdir $(KERNEL_SRC)
	tar xf $(KERNEL_DIST)
	if [ -f $(KERNEL_PATCH) ]; then cd $(KERNEL_SRC) ; patch -b -p0 <../$(KERNEL_PATCH) ; fi
	touch $@

###############################################################################

# Configure kernel

config.done: src.done
	cp $(KERNEL_CONFIG) $(KERNEL_SRC)/.config
	$(MAKE) -C $(KERNEL_SRC) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) oldconfig
	cp $(KERNEL_SRC)/.config $(KERNEL_CONFIG)
	touch $@

menuconfig: src.done
	cp $(KERNEL_CONFIG) $(KERNEL_SRC)/.config
	$(MAKE) -C $(KERNEL_SRC) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) menuconfig
	$(MAKE) -C $(KERNEL_SRC) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) oldconfig
	cp $(KERNEL_SRC)/.config $(KERNEL_CONFIG)
	touch config.done

###############################################################################

# Build kernel modules

modules.done: config.done
	$(MAKE) $(MAKEJOBS) -C $(KERNEL_SRC) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	$(MAKE) -C $(KERNEL_SRC) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules_install INSTALL_MOD_PATH=$(shell pwd)/modules
	rm modules/lib/modules/*/build
	rm modules/lib/modules/*/source
	rm -rf modules/lib/modules/*/kernel/drivers/net/wireless/realtek/rtl8192cu
ifneq ($(EXTRAMODULES),)
	$(MAKE) $(EXTRAMODULES)
endif
	touch $@

###############################################################################

# Build kernel device tree blobs

dtbs.done: config.done
	$(MAKE) $(MAKEJOBS) -C $(KERNEL_SRC) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) dtbs
	touch $@

###############################################################################

# Build kernel and stage binaries

build.done: config.done modules.done dtbs.done
	$(MAKE) $(MAKEJOBS) -C $(KERNEL_SRC) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) $(KERNEL_TARGETS)
	cp $(KERNEL_SRC)/arch/$(ARCH)/boot/$(KERNEL_IMGSRC) $(KERNEL_IMG)

ifneq ($(KERNEL_DTB),)
# Special precopy for Raspberry Pi 3 and 4
	-cp $(KERNEL_DTS)/broadcom/*.dtb $(KERNEL_DTS)
# Copy device tree blobs
	for f in $(KERNEL_DTB) ; do cp $(KERNEL_DTS)/$$f.dtb . ; done
endif

ifneq ($(KERNEL_OVL),)
# Copy device tree overlays
	for f in $(KERNEL_OVL) ; do cp $(KERNEL_DTS)/overlays/$$f.dtbo . ; done
endif

	chmod 644 $(KERNEL_IMG)
	touch $@

###############################################################################

# Refresh kernel configuration files

allconfig:
	$(MAKE) config.done reallyclean BOARDNAME=BeagleBone
	$(MAKE) config.done reallyclean BOARDNAME=RaspberryPi1
	$(MAKE) config.done reallyclean BOARDNAME=RaspberryPi1Gadget
	$(MAKE) config.done reallyclean BOARDNAME=RaspberryPi2
	$(MAKE) config.done reallyclean BOARDNAME=RaspberryPi2Gadget
	$(MAKE) config.done reallyclean BOARDNAME=RaspberryPi3
	$(MAKE) config.done reallyclean BOARDNAME=RaspberryPi3Gadget
	$(MAKE) config.done reallyclean BOARDNAME=RaspberryPi4
	$(MAKE) config.done reallyclean BOARDNAME=RaspberryPi4Gadget

###############################################################################

# Clean out working files

clean:
	-$(MAKE) -C $(KERNEL_SRC) mrproper
	rm -rf *.img *.dtb *.dtbo modules config.done dtbs.done modules.done build.done

reallyclean: clean
	rm -rf $(KERNEL_SRC) src.done

distclean: reallyclean
	rm -f $(KERNEL_DIST)
