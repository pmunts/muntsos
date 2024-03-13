# Makefile for boot kernel for an embedded Linux system

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

BOARDNAME	?= UNDEFINED
MUNTSOS		:= $(shell pwd)/..

include $(MUNTSOS)/include/$(BOARDNAME).mk

DESTDIR         = fakeroot
TARBALL         = $(BOARDNAME)-Kernel.tgz

REVISION	?= test

.PHONY: default download download_prebuilt clean reallyclean distclean

default: $(TARBALL)

###############################################################################

# Build the kernel

$(KERNEL_WORK)/build.done:
	$(MAKE) -C kernel BOARDNAME=$(BOARDNAME) REVISION=$(REVISION)

###############################################################################

# Build the kernel distribution tarball

$(TARBALL): $(KERNEL_WORK)/build.done
	mkdir -p $(DESTDIR)
	cp initramfs/COPYING $(DESTDIR)
	cp $(KERNEL_WORK)/$(KERNEL_IMG) $(DESTDIR)

ifneq ($(KERNEL_DTB),)
	for f in $(KERNEL_DTB) ; do cp $(KERNEL_WORK)/dtbs/$$f.dtb $(DESTDIR) ; done
endif

ifneq ($(KERNEL_OVL),)
	mkdir -p $(DESTDIR)/overlays
	for f in $(KERNEL_OVL) ; do cp $(KERNEL_WORK)/overlays/$$f.dtb* $(DESTDIR)/overlays ; done
endif

ifeq ($(BOARDBASE), BeagleBone)
	$(MAKE) -C $(MUNTSOS)/boot/BeagleBone/overlays DTC=$(KERNEL_DTC)
	mkdir -p $(DESTDIR)/overlays
	cp $(MUNTSOS)/boot/BeagleBone/overlays/*.dtbo $(DESTDIR)/overlays
endif

ifneq ($(findstring RaspberryPi, $(BOARDNAME)),)
	$(MAKE) -C $(MUNTSOS)/boot/RaspberryPi/overlays DTC=$(KERNEL_DTC)
	mkdir -p $(DESTDIR)/overlays
	cp $(MUNTSOS)/boot/RaspberryPi/overlays/*.dtbo     $(DESTDIR)/overlays
	cp $(MUNTSOS)/boot/RaspberryPi/overlays/README.txt $(DESTDIR)/overlays
ifeq ($(findstring RaspberryPi4, $(BOARDNAME)),)
	rm -f $(DESTDIR)/overlays/*-pi4.dtbo
endif
ifeq ($(findstring RaspberryPi5, $(BOARDNAME)),)
	rm -f $(DESTDIR)/overlays/*-pi5.dtbo
else
	rm -f $(DESTDIR)/overlays/Pi3ClickShield.dtbo
	rm -f $(DESTDIR)/overlays/pwmchip0.dtbo
endif
endif

	cd $(DESTDIR) ; find * -type f -exec md5sum -b {} ";" | sort -k 2 | grep -v kernel.md5 >kernel.md5
	cd $(DESTDIR) ; tar czf ../$@ * --owner=nobody --group=nobody --mode=ugo-w
	rm -rf $(DESTDIR)

###############################################################################

# Rebuild the kernel distribution tarball with new initramfs

rebuild:
	rm -rf initramfs/initramfs.*
	rm -f $(KERNEL_WORK)/build.done
	rm -f $(KERNEL_WORK)/config.done
	rm -f $(KERNEL_WORK)/dtbs.done
	rm -f $(KERNEL_WORK)/initramfs.done
	rm -f $(KERNEL_WORK)/modules.done
	rm -f $(KERNEL_WORK)/$(KERNEL_IMG)
	rm -rf $(KERNEL_WORK)/dtbs
	rm -rf $(KERNEL_WORK)/modules
	rm -rf $(KERNEL_WORK)/overlays
	rm -f $(TARBALL)
	$(MAKE) $(TARBALL)

###############################################################################

# Download prebuilt kernel distribution tarball

download_prebuilt: $(TARBALL).downloaded

$(TARBALL).downloaded:
	wget -q -N $(DOWNLOADPREFIX)/kernels/$(TARBALL)
	touch $(TARBALL).downloaded

###############################################################################

# Clean out working files

clean:
	rm -rf $(DESTDIR)
	if [ ! -f $(TARBALL).downloaded ]; then rm -rf $(TARBALL) ; fi

reallyclean: clean
	$(MAKE) -C initramfs reallyclean
	$(MAKE) -C kernel reallyclean
	rm -rf *.tgz *.downloaded
	$(MAKE) -C $(MUNTSOS)/boot/BeagleBone/overlays clean
	$(MAKE) -C $(MUNTSOS)/boot/RaspberryPi/overlays clean

distclean: reallyclean
	$(MAKE) -C initramfs distclean
	$(MAKE) -C kernel distclean
