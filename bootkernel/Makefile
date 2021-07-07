# Makefile for boot kernel for an embedded Linux system

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

BOARDNAME	?= UNDEFINED
MUNTSOS		?= ..

include $(MUNTSOS)/include/$(BOARDNAME).mk

DESTDIR         = fakeroot
TARBALL         = $(BOARDNAME)-Kernel.tgz

SUBORDINATES	= initramfs kernel

REVISION	?= test

.PHONY: default download download_prebuilt clean reallyclean distclean

default: $(TARBALL)

###############################################################################

# Build the kernel

kernel/build.done:
	$(MAKE) -C kernel modules.done BOARDNAME=$(BOARDNAME) REVISION=$(REVISION)
	for S in $(SUBORDINATES) ; do $(MAKE) -C $$S default BOARDNAME=$(BOARDNAME) REVISION=$(REVISION) ; done

###############################################################################

# Build the kernel distribution tarball

$(TARBALL): kernel/build.done
	mkdir -p $(DESTDIR)
	cp initramfs/COPYING $(DESTDIR)
	cp kernel/$(KERNEL_IMG) $(DESTDIR)

ifneq ($(KERNEL_DTB),)
	for f in $(KERNEL_DTB) ; do cp kernel/$$f.dtb $(DESTDIR) ; done
endif

ifneq ($(KERNEL_OVL),)
	mkdir -p $(DESTDIR)/overlays
	for f in $(KERNEL_OVL) ; do cp kernel/$$f.dtbo $(DESTDIR)/overlays ; done
endif

	cd $(DESTDIR) ; find * -type f -exec md5sum -b {} ";" | sort -k 2 | grep -v kernel.md5 >kernel.md5
	cd $(DESTDIR) ; tar czf ../$@ * --owner=nobody --group=nobody --mode=ugo-w
	rm -rf $(DESTDIR)

# Rebuild the kernel distribution tarball with new initramfs

rebuild:
	rm -rf kernel/build.done kernel/*.dtb* kernel/*.img
	rm -rf initramfs/initramfs* initramfs/COPYING
	rm -f $(TARBALL)
	$(MAKE) $(TARBALL)

###############################################################################

# Download sources, for offline build

download:
	for S in $(SUBORDINATES) ; do $(MAKE) -C $$S $@ BOARDNAME=$(BOARDNAME); done

###############################################################################

# Download prebuilt kernel distribution tarball

download_prebuilt: $(TARBALL).downloaded

$(TARBALL).downloaded:
	wget -q -N $(DOWNLOADPREFIX)/kernels/$(TARBALL)
	touch $(TARBALL).downloaded

###############################################################################

# Clean out working files

clean:
	for S in $(SUBORDINATES) ; do $(MAKE) -C $$S $@ BOARDNAME=$(BOARDNAME); done
	rm -rf $(DESTDIR)
	if [ ! -f $(TARBALL).downloaded ]; then rm -rf $(TARBALL) ; fi

reallyclean: clean
	for S in $(SUBORDINATES) ; do $(MAKE) -C $$S $@ BOARDNAME=$(BOARDNAME); done
	rm -rf *.tgz *.downloaded

distclean: reallyclean
	for S in $(SUBORDINATES) ; do $(MAKE) -C $$S $@ BOARDNAME=$(BOARDNAME); done
