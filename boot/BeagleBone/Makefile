# Build boot file tarballs for BeagleBone platform boards

# Copyright (C)2017-2024, Philip Munts dba Munts Technologies.
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
BOARDNAME	?= BeagleBone

include $(MUNTSOS)/include/$(BOARDNAME).mk

UBOOT_NAME	= u-boot
UBOOT_VER	= 2018.03
UBOOT_SRC	= $(UBOOT_NAME)-$(UBOOT_VER)
UBOOT_TARBALL	= $(UBOOT_SRC).tar.bz2
UBOOT_SERVER	= ftp://ftp.denx.de/pub/u-boot
UBOOT_URL	= $(UBOOT_SERVER)/$(UBOOT_TARBALL)
UBOOT_DIST	= $(TEMP)/$(UBOOT_TARBALL)

DESTDIR		= fakeroot
TARBALL		= bootfiles.tgz

default: tarball.done boards.img

# Download U-Boot source distribution

$(UBOOT_DIST):
	wget -nv -P $(TEMP) $(UBOOT_URL)

# Unpack and patch U-Boot source distribution

src.done: $(UBOOT_DIST)
	tar xjf $(UBOOT_DIST)
	cd $(UBOOT_SRC) ; patch -p1 <../fixes.patch
	cd $(UBOOT_SRC) ; patch -b -p0 <../muntsos.patch
	touch $@

# Configure U-Boot

config.done: src.done
	cp uboot.config $(UBOOT_SRC)/.config
	$(MAKE) -C $(UBOOT_SRC) CROSS_COMPILE=$(CROSS_COMPILE) oldconfig
	touch $@

defconfig: src.done
	$(MAKE) -C $(UBOOT_SRC) CROSS_COMPILE=$(CROSS_COMPILE) am335x_evm_defconfig
	cp $(UBOOT_SRC)/.config uboot.config
	touch config.done

menuconfig: src.done
	cp uboot.config $(UBOOT_SRC)/.config
	$(MAKE) -C $(UBOOT_SRC) CROSS_COMPILE=$(CROSS_COMPILE) menuconfig
	cp $(UBOOT_SRC)/.config uboot.config
	touch config.done

# Build U-Boot

build.done: config.done
	$(MAKE) -C $(UBOOT_SRC) CROSS_COMPILE=$(CROSS_COMPILE)
	touch $@

# Build board detection script image

boards.img: boards.script
	mkimage -T script -C none -n 'Board Detection' -d boards.script boards.img

# Build distribution/archival tarball of necessary boot files

tarball.done: build.done boards.img
	rm -rf					$(DESTDIR)
	mkdir -p				$(DESTDIR)
	cp $(UBOOT_SRC)/MLO			$(DESTDIR)
	cp $(UBOOT_SRC)/u-boot.img		$(DESTDIR)
	cp boards.img				$(DESTDIR)
	cd $(DESTDIR) && tar czf ../$(TARBALL) * --owner=root --group=root --mode=ugo-w
	touch $@

# Remove working files

clean:
	rm -rf boards.img $(UBOOT_SRC) *.done $(DESTDIR)

reallyclean: clean

distclean: reallyclean
	rm -rf $(UBOOT_DIST)
