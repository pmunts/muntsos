# Makefile for an embedded Linux boot kernel

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

.PHONY: default src oldconfig defconfig menuconfig dtbs modules initramfs build allconfig clean reallyclean distclean

BOARDNAME	?= UNDEFINED
MUNTSOS		?= $(shell pwd)/../..
MAKEJOBS	?= -j 2

include $(MUNTSOS)/include/$(BOARDNAME).mk

MAKE_ARGS	= -C $(KERNEL_SRC)
MAKE_ARGS	+= ARCH=$(ARCH)
MAKE_ARGS	+= CROSS_COMPILE=$(CROSS_COMPILE)

ifneq ($(KERNEL),)
MAKE_ARGS	+= KERNEL=$(KERNEL)
endif

default: $(KERNEL_WORK)/build.done

###############################################################################

# Prepare kernel source tree

$(KERNEL_WORK)/src.done: $(KERNEL_DIST)
	rm -rf $(KERNEL_WORK)
	mkdir -p $(KERNEL_WORK)
	tar xzf $(KERNEL_DIST) --directory=$(KERNEL_WORK)
	if [ -f $(KERNEL_PATCH) ] ; then cd $(KERNEL_SRC) && patch -b -p0 <../../$(KERNEL_PATCH) ; fi
	touch $@

src: $(KERNEL_WORK)/src.done

###############################################################################

# Configure kernel

$(KERNEL_WORK)/config.done: $(KERNEL_WORK)/src.done
	cp $(KERNEL_CONFIG) $(KERNEL_SRC)/.config
	$(MAKE) $(MAKE_ARGS) oldconfig
	cp $(KERNEL_SRC)/.config $(KERNEL_CONFIG)
	touch $@

oldconfig: $(KERNEL_WORK)/config.done

defconfig: $(KERNEL_WORK)/src.done
	$(MAKE) $(MAKE_ARGS) $(KERNEL_DEFCONF)
	$(MAKE) $(MAKE_ARGS) oldconfig
	cp $(KERNEL_SRC)/.config $(KERNEL_CONFIG)
	touch $(KERNEL_WORK)/config.done

menuconfig: $(KERNEL_WORK)/src.done
	cp $(KERNEL_CONFIG) $(KERNEL_SRC)/.config
	$(MAKE) $(MAKE_ARGS) menuconfig
	$(MAKE) $(MAKE_ARGS) oldconfig
	cp $(KERNEL_SRC)/.config $(KERNEL_CONFIG)
	touch $(KERNEL_WORK)/config.done

###############################################################################

# Build device tree blobs and overlays

$(KERNEL_WORK)/dtbs.done: $(KERNEL_WORK)/config.done
	$(MAKE) $(MAKE_ARGS) dtbs
	$(MAKE) $(MAKE_ARGS) dtbs_install INSTALL_DTBS_PATH=$(KERNEL_WORK)/dtbs
	-cd $(KERNEL_WORK)/dtbs && mv overlays ..
	touch $@

dtbs: $(KERNEL_WORK)/dtbs.done

###############################################################################

# Build modules

$(KERNEL_WORK)/modules.done: $(KERNEL_WORK)/config.done
	$(MAKE) $(MAKEJOBS) $(MAKE_ARGS) modules
	$(MAKE) $(MAKE_ARGS) modules_install INSTALL_MOD_PATH=$(KERNEL_WORK)/modules
	rm $(KERNEL_WORK)/modules/lib/modules/*/build
	rm $(KERNEL_WORK)/modules/lib/modules/*/source
	rm -rf modules/lib/modules/*/kernel/drivers/net/wireless/realtek/rtl8192cu
	touch $@

modules: $(KERNEL_WORK)/modules.done

###############################################################################

# Build initramfs

$(KERNEL_WORK)/initramfs.done: $(KERNEL_WORK)/dtbs.done $(KERNEL_WORK)/modules.done
	rm -rf ../initramfs/COPYING ../initramfs/initramfs*
	$(MAKE) -C ../initramfs
	touch $@

initramfs: $(KERNEL_WORK)/initramfs.done

###############################################################################

# Build kernel

$(KERNEL_WORK)/build.done: $(KERNEL_WORK)/initramfs.done
	$(MAKE) $(MAKEJOBS) $(MAKE_ARGS) $(KERNEL_TARGETS)
	cp $(KERNEL_SRC)/arch/$(ARCH)/boot/$(KERNEL_IMGSRC) $(KERNEL_WORK)/$(KERNEL_IMG)
	chmod 644 $(KERNEL_WORK)/$(KERNEL_IMG)
	touch $@

build: $(KERNEL_WORK)/build.done

###############################################################################

# Refresh kernel configuration files

allconfig:
	#$(MAKE) oldconfig reallyclean BOARDNAME=BeagleBone
	#$(MAKE) oldconfig reallyclean BOARDNAME=RaspberryPi1
	#$(MAKE) oldconfig reallyclean BOARDNAME=RaspberryPi1Gadget
	#$(MAKE) oldconfig reallyclean BOARDNAME=RaspberryPi2
	#$(MAKE) oldconfig reallyclean BOARDNAME=RaspberryPi2Gadget
	$(MAKE) oldconfig reallyclean BOARDNAME=RaspberryPi3
	$(MAKE) oldconfig reallyclean BOARDNAME=RaspberryPi3Gadget
	$(MAKE) oldconfig reallyclean BOARDNAME=RaspberryPi4
	$(MAKE) oldconfig reallyclean BOARDNAME=RaspberryPi4Gadget
	$(MAKE) oldconfig reallyclean BOARDNAME=RaspberryPi5

###############################################################################

# Clean out working files

clean:
	$(MAKE) -C ../initramfs reallyclean
	rm -rf $(KERNEL_WORK)

reallyclean: clean

distclean: reallyclean
	$(MAKE) -C ../initramfs distclean
	rm -f $(KERNEL_COMMIT) $(KERNEL_DIST)
