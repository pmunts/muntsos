# Makefile for building a MuntsOS SSH Thin Server

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

BOARDNAME	?= UNDEFINED
MUNTSOS		?= $(shell pwd)/../..

THINSERVERNAME	:= gpio-server
EXTPKGDIR1	:= $(MUNTSOS)/extensions/dma
EXTPKGPREFIX1	:= $(EXTPKGDIR1)/dma-muntsos
EXTPKGDIR2	:= $(MUNTSOS)/extensions/GPIO
EXTPKGPREFIX2	:= $(EXTPKGDIR2)/GPIO-server-muntsos

include $(MUNTSOS)/thinservers/common.mk

default: prebuilt.done $(ZIPFILE)

download_prebuilt: prebuilt.done

prebuilt.done: common_mk_prebuilt
	for B in $(BASES) ; do $(MAKE) -C $(EXTPKGDIR1) download_prebuilt MUNTSOS=$(MUNTSOS) BOARDNAME=$$B ; done
	for B in $(BASES) ; do $(MAKE) -C $(EXTPKGDIR2) download_prebuilt MUNTSOS=$(MUNTSOS) BOARDNAME=$$B ; done
	touch $@

populate.done: common_mk_populate
	for B in $(BASES) ; do cp $(EXTPKGPREFIX1)-$$B.deb $(ZIPDIR)/packages/$$B ; done
	for B in $(BASES) ; do cp $(EXTPKGPREFIX2)-$$B.deb $(ZIPDIR)/packages/$$B ; done
	touch $@

clean: common_mk_clean

reallyclean: clean common_mk_reallyclean

distclean: reallyclean common_mk_distclean
	for B in $(BASES) ; do $(MAKE) -C $(EXTPKGDIR1) reallyclean MUNTSOS=$(MUNTSOS) BOARDNAME=$$B ; done
	for B in $(BASES) ; do $(MAKE) -C $(EXTPKGDIR2) reallyclean MUNTSOS=$(MUNTSOS) BOARDNAME=$$B ; done
