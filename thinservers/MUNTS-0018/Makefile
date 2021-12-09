# Makefile for building a MUNTS-0018 Tutorial I/O Board Remote I/O Protocol
# Thin Server

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

BOARDNAME	?= UNDEFINED
MUNTSOS		?= $(shell pwd)/../..

THINSERVERNAME	= munts-0018-remoteio-server

include $(MUNTSOS)/thinservers/common.mk

default: prebuilt.done $(ZIPFILE)

download_prebuilt: prebuilt.done

prebuilt.done: common_mk_prebuilt
	touch $@

populate.done: common_mk_populate
	sed -i '/#dtoverlay=Pi3ClickShield/d'	$(ZIPDIR)/config.txt
	sed -i '/#dtoverlay=pwm/d'		$(ZIPDIR)/config.txt
	echo dtoverlay=anyspi,spi0-1,dev="microchip,mcp3204",speed=1000000	>>$(ZIPDIR)/config.txt
	echo dtoverlay=pwm-2chan,pin=12,func=4,pin2=19,func2=2			>>$(ZIPDIR)/config.txt
	$(MAKE) -C $(MUNTSOS)/examples/ada/programs remoteio_server_munts_0018
	cp $(MUNTSOS)/examples/ada/programs/remoteio_server_munts_0018		$(ZIPDIR)/autoexec.d
	touch $@

clean: common_mk_clean
	$(MAKE) -C $(MUNTSOS)/examples/ada/programs clean

reallyclean: clean common_mk_reallyclean

distclean: reallyclean common_mk_distclean
	for B in $(BASES) ; do $(MAKE) -C reallyclean MUNTSOS=$(MUNTSOS) BOARDNAME=$$B ; done
