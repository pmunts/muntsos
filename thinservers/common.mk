# Makefile for building a MuntsOS SSH Thin Server

# Copyright (C)2018-2022, Philip Munts, President, Munts AM Corp.
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

ifeq ($(BOARDNAME), RaspberryPiGadget)
include $(MUNTSOS)/include/RaspberryPi.mk
else
include $(MUNTSOS)/include/$(BOARDNAME).mk
endif

ifeq ($(BOARDNAME), RaspberryPi)
BOOTFILES	:= bootfiles.tgz bootfiles4.tgz
BOARDS		:= RaspberryPi1 RaspberryPi2 RaspberryPi3 RaspberryPi4
BASES		:= RaspberryPi1 RaspberryPi2 RaspberryPi3
else ifeq ($(BOARDNAME), RaspberryPiGadget)
BOOTFILES	:= bootfiles.tgz bootfiles4.tgz
BOARDS		:= RaspberryPi1Gadget RaspberryPi2Gadget RaspberryPi3Gadget RaspberryPi4Gadget
BASES		:= RaspberryPi1 RaspberryPi2 RaspberryPi3
else ifeq ($(findstring RaspberryPi4, $(BOARDNAME)), RaspberryPi4)
BOOTFILES	:= bootfiles4.tgz
BOARDS		:= $(BOARDNAME)
BASES		:= $(BOARDBASE)
else
BOOTFILES	:= bootfiles.tgz
BOARDS		:= $(BOARDNAME)
BASES		:= $(BOARDBASE)
endif

SED		?= sed
TAR		?= tar
ZIP		?= zip

ZIPDIR		= zipdir
ZIPFILE		?= muntsos-$(THINSERVERNAME)-$(BOARDNAME).zip

common_mk_default: default

###############################################################################

# Download prebuilt binaries

common_mk_prebuilt:
	for T in $(BOARDS) ; do $(MAKE) -C $(MUNTSOS)/bootkernel download_prebuilt MUNTSOS=$(MUNTSOS) BOARDNAME=$$T ; done

###############################################################################

# Populate the boot file system for a MuntsOS Thin Server

common_mk_populate:
	for S in $(BASES) ; do mkdir -p $(ZIPDIR)/autoexec.d/$$S ; done
	mkdir -p					$(ZIPDIR)/tarballs
	for S in $(BASES) ; do mkdir -p $(ZIPDIR)/packages/$$S ; done
	for B in $(BOOTFILES) ; do $(TAR) xzf $(BOOTFILESDIR)/$$B -C $(ZIPDIR) ; done
	for K in $(BOARDS) ; do $(TAR) xzf $(MUNTSOS)/bootkernel/$$K-Kernel.tgz --skip-old-files -C $(ZIPDIR) ; done
ifneq ($(findstring RaspberryPi, $(BOARDNAME)),)
	cp $(BOOTFILESDIR)/cmdline.txt.$(BOARDNAME)	$(ZIPDIR)/cmdline.txt
endif
	cp $(BOOTFILESDIR)/config.txt.$(BOARDNAME)	$(ZIPDIR)/config.txt
	cp $(MUNTSOS)/scripts/00-wlan-init		$(ZIPDIR)/autoexec.d
	find $(ZIPDIR) -type f -exec chmod 644 {} ";"
	find $(ZIPDIR)/autoexec.d -type f -exec chmod 755 {} ";"
	cd $(ZIPDIR) ; find * -type f -exec md5sum -b {} ";" | sort -k 2 | grep -v checksums >checksums.md5

###############################################################################

# Create MuntsOS Thin Server installation zip file

$(ZIPFILE): populate.done
	chmod -R -w $(ZIPDIR)
	cd $(ZIPDIR) ; $(ZIP) -r ../$(ZIPFILE) *
	chmod -R +w $(ZIPDIR)

###############################################################################

# Clean out working files

common_mk_clean:
	rm -rf $(ZIPFILE) $(ZIPDIR) populate.done

common_mk_reallyclean: common_mk_clean
	for T in $(BOARDS) ; do $(MAKE) -C $(MUNTSOS)/bootkernel clean MUNTSOS=$(MUNTSOS) BOARDNAME=$$T ; done

common_mk_distclean: common_mk_reallyclean
	for T in $(BOARDS) ; do $(MAKE) -C $(MUNTSOS)/bootkernel reallyclean MUNTSOS=$(MUNTSOS) BOARDNAME=$$T ; done
	rm -rf prebuilt.done
