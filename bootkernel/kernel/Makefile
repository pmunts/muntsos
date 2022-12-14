# Makefile for an embedded Linux boot kernel

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

.PHONY: default src config menuconfig dtbs modules initramfs build allconfig clean reallyclean distclean

BOARDNAME	?= UNDEFINED
MUNTSOS		?= $(shell pwd)/../..
MAKEJOBS	?= -j 2

include $(MUNTSOS)/include/$(BOARDNAME).mk

default: build

###############################################################################

# Prepare kernel source tree

$(KERNEL_WORK)/src.done: $(KERNEL_DIST)
	rm -rf $(KERNEL_WORK)
	mkdir -p $(KERNEL_WORK)
	tar xjf $(KERNEL_DIST) --directory=$(KERNEL_WORK)
	if [ -f $(KERNEL_PATCH) ] ; then cd $(KERNEL_SRC) && patch -b -p0 <../../$(KERNEL_PATCH) ; fi
	touch $@

src: $(KERNEL_WORK)/src.done

###############################################################################

# Configure kernel

$(KERNEL_WORK)/config.done: $(KERNEL_WORK)/src.done
	cp $(KERNEL_CONFIG) $(KERNEL_SRC)/.config
	$(MAKE) -C $(KERNEL_SRC) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) oldconfig
	cp $(KERNEL_SRC)/.config $(KERNEL_CONFIG)
	touch $@

config: $(KERNEL_WORK)/config.done

menuconfig: $(KERNEL_WORK)/src.done
	cp $(KERNEL_CONFIG) $(KERNEL_SRC)/.config
	$(MAKE) -C $(KERNEL_SRC) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) menuconfig
	$(MAKE) -C $(KERNEL_SRC) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) oldconfig
	cp $(KERNEL_SRC)/.config $(KERNEL_CONFIG)
	touch $(KERNEL_WORK)/config.done

###############################################################################

# Build device tree blobs and overlays

$(KERNEL_WORK)/dtbs.done: $(KERNEL_WORK)/config.done
	$(MAKE) -C $(KERNEL_SRC) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) dtbs dtbs_install INSTALL_DTBS_PATH=$(KERNEL_WORK)/dtbs
	cd $(KERNEL_WORK)/dtbs && mv overlays ..
	touch $@

dtbs: $(KERNEL_WORK)/dtbs.done

###############################################################################

# Build modules

$(KERNEL_WORK)/modules.done: $(KERNEL_WORK)/config.done
	$(MAKE) $(MAKEJOBS) -C $(KERNEL_SRC) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	$(MAKE) -C $(KERNEL_SRC) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules_install INSTALL_MOD_PATH=$(KERNEL_WORK)/modules
	rm $(KERNEL_WORK)/modules/lib/modules/*/build
	rm $(KERNEL_WORK)/modules/lib/modules/*/source
	rm -rf modules/lib/modules/*/kernel/drivers/net/wireless/realtek/rtl8192cu
	touch $@

modules: $(KERNEL_WORK)/modules.done

###############################################################################

# Build initramfs

$(KERNEL_WORK)/initramfs.done: $(KERNEL_WORK)/modules.done
	rm -rf ../initramfs/COPYING ../initramfs/initramfs*
	$(MAKE) -C ../initramfs
	touch $@

initramfs: $(KERNEL_WORK)/initramfs.done

###############################################################################

# Build kernel

$(KERNEL_WORK)/build.done: config dtbs modules initramfs
	$(MAKE) $(MAKEJOBS) -C $(KERNEL_SRC) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) $(KERNEL_TARGETS)
	cp $(KERNEL_SRC)/arch/$(ARCH)/boot/$(KERNEL_IMGSRC) $(KERNEL_WORK)/$(KERNEL_IMG)
	chmod 644 $(KERNEL_WORK)/$(KERNEL_IMG)
	touch $@

build: $(KERNEL_WORK)/build.done

###############################################################################

# Refresh kernel configuration files

allconfig:
	$(MAKE) config reallyclean BOARDNAME=BeagleBone
	$(MAKE) config reallyclean BOARDNAME=RaspberryPi1
	$(MAKE) config reallyclean BOARDNAME=RaspberryPi1Gadget
	$(MAKE) config reallyclean BOARDNAME=RaspberryPi2
	$(MAKE) config reallyclean BOARDNAME=RaspberryPi2Gadget
	$(MAKE) config reallyclean BOARDNAME=RaspberryPi3
	$(MAKE) config reallyclean BOARDNAME=RaspberryPi3Gadget
	$(MAKE) config reallyclean BOARDNAME=RaspberryPi4
	$(MAKE) config reallyclean BOARDNAME=RaspberryPi4Gadget

###############################################################################

# Clean out working files

clean:
	-if [ -d $(KERNEL_SRC) -a "$(MAKECMDGOALS)" = "clean" ] ; then $(MAKE) -C $(KERNEL_SRC) mrproper ; fi
	$(MAKE) -C ../initramfs clean
	rm -rf $(KERNEL_WORK)/config.done
	rm -rf $(KERNEL_WORK)/dtbs.done
	rm -rf $(KERNEL_WORK)/modules.done
	rm -rf $(KERNEL_WORK)/initramfs.done
	rm -f  $(KERNEL_WORK)/*.img
	rm -rf $(KERNEL_WORK)/dtbs $(KERNEL_WORK)/modules $(KERNEL_WORK)/overlays

reallyclean: clean
	$(MAKE) -C ../initramfs reallyclean
	rm -rf $(KERNEL_WORK)

distclean: reallyclean
	$(MAKE) -C ../initramfs distclean
	rm -f  $(KERNEL_DIST)
