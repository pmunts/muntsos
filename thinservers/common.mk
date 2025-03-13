# Makefile for building a MuntsOS SSH Thin Server

# Copyright (C)2018-2025, Philip Munts dba Munts Technologies.
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

include $(MUNTSOS)/include/$(BOARDNAME).mk

TAR		?= tar
ZIP		?= zip

ZIPDIR		:= zipdir
ifeq ($(FLAVOR),)
ZIPFILE		:= muntsos-$(BOARDNAME).zip
else
ZIPFILE		:= muntsos-$(FLAVOR)-$(BOARDNAME).zip
endif

common_mk_default: default

###############################################################################

# Populate the boot file system for a MuntsOS Thin Server

common_mk_populate:
	mkdir -p					$(ZIPDIR)/autoexec.d
	mkdir -p					$(ZIPDIR)/tarballs
	mkdir -p					$(ZIPDIR)/packages
	wget http://repo.munts.com/muntsos/$(TOOLCHAIN_REV)/kernels/$(BOARDNAME)-Kernel.tgz
	$(TAR) xzf $(BOARDNAME)-Kernel.tgz -C		$(ZIPDIR)
ifneq ($(NOBOOTFILES), yes)
	$(TAR) xzf $(BOOTFILESTGZ)  -C			$(ZIPDIR)
ifeq ($(BOARDNAME), BeaglePlay)
	cp $(ZIPDIR)/boota.scr				$(ZIPDIR)/boot.scr
endif
endif
ifneq ($(findstring RaspberryPi, $(BOARDNAME)),)
	cp $(BOOTFILESDIR)/cmdline.txt.$(BOARDNAME)	$(ZIPDIR)/cmdline.txt
endif
	cp $(BOOTFILESDIR)/config.txt.$(BOARDNAME)	$(ZIPDIR)/config.txt
	cp $(MUNTSOS)/scripts/00-wlan-init		$(ZIPDIR)/autoexec.d
	-for E in $(EXTENSIONS) ; do wget -P $(ZIPDIR)/packages   http://repo.munts.com/muntsos/$(TOOLCHAIN_REV)/extensions/$$E-muntsos-$(BOARDARCH).deb ; done
	-for E in $(EXTENSIONS) ; do wget -P $(ZIPDIR)/autoexec.d http://repo.munts.com/muntsos/$(TOOLCHAIN_REV)/extensions/$$E-$(BOARDARCH) ; done
	find $(ZIPDIR) -type f -exec chmod 644 {} ";"
	find $(ZIPDIR)/autoexec.d -type f -exec chmod 755 {} ";"

###############################################################################

# Create MuntsOS Thin Server installation zip file

$(ZIPFILE): common_mk_populate
	chmod -R -w $(ZIPDIR)
	cd $(ZIPDIR) ; $(ZIP) -r ../$(ZIPFILE) *
	chmod -R +w $(ZIPDIR)

###############################################################################

# Clean out working files

common_mk_clean:
	-chmod -R u+w $(ZIPDIR)
	rm -rf $(ZIPFILE) $(ZIPDIR) $(BOARDNAME)-Kernel.tgz

common_mk_reallyclean: common_mk_clean
	$(MAKE) -C $(MUNTSOS)/bootkernel reallyclean
	-for E in $(EXTENSIONS) ; do $(MAKE) -C $(MUNTSOS)/extensions/$$E reallyclean ; done

common_mk_distclean: common_mk_reallyclean
