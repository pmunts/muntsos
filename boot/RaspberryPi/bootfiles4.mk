# Import latest boot files from Raspberry Pi OS aka Raspbian

# Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

# We want the following boot files

BOOTFILES4_LIST		+= LICENCE.broadcom
BOOTFILES4_LIST		+= fixup4.dat
BOOTFILES4_LIST		+= fixup4cd.dat
BOOTFILES4_LIST		+= fixup4db.dat
BOOTFILES4_LIST		+= fixup4x.dat
BOOTFILES4_LIST		+= start4.elf
BOOTFILES4_LIST		+= start4cd.elf
BOOTFILES4_LIST		+= start4db.elf
BOOTFILES4_LIST		+= start4x.elf

BOOTFILES4_SRCDIR	?= /boot
BOOTFILES4_DSTDIR	:= $(shell pwd)/bootfiles4
BOOTFILES4_TARBALL	:= $(BOOTFILES4_DSTDIR).tgz

default: $(BOOTFILES4_TARBALL)

# Copy boot files to staging directory

$(BOOTFILES4_DSTDIR):
	rm -rf $@
	mkdir -p $@
	for F in $(BOOTFILES4_LIST) ; do cp -p $(BOOTFILES4_SRCDIR)/$$F $@ ; done
	cd $(BOOTFILES4_DSTDIR) && md5sum -b * >checksums.md5 && touch -r LICENCE.broadcom checksums.md5
	chmod 644 $@/*
	touch $@

# Create boot files tarball

$(BOOTFILES4_TARBALL): $(BOOTFILES4_DSTDIR)
	cd $^ && tar czf $@ * --owner=root --group=root --mode=ugo-w
	touch $@
	rm -rf $^

# Remove working files

clean:
	rm -rf $(BOOTFILES4_DSTDIR) $(BOOTFILES4_TARBALL)
