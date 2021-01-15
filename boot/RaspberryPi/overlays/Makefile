# Makefile for building Raspberry Pi device tree overlays

# Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

EMBLINUXBASE	?= ../../..
BOARDNAME	?= RaspberryPi1

include $(EMBLINUXBASE)/include/$(BOARDNAME).mk

default: overlays.done

# Define a pattern rule for compiling device tree overlays

%.dtbo: %.dts
	$(KERNEL_DTC) -@ -b 0 -I dts -O dtb -o $@ $^

# Compile the device tree compiler

dtc.done:
	$(MAKE) -C $(EMBLINUXBASE)/bootkernel/kernel dtbs BOARDNAME=$(BOARDNAME)
	touch $@

# Compile device tree overlays

overlays.done: dtc.done
	for F in *.dts ; do $(MAKE) `basename $$F .dts`.dtbo ; done
	touch $@

# Release compiled overlays

release: overlays.done
	cd .. ; md5sum -b overlays/README.txt overlays/*.dtbo | sort -k 2 >overlays.md5
	cd .. ; tar czf overlays.tgz overlays.md5 overlays/README.txt overlays/*.dtbo --owner=nobody --group=nobody --mode=ugo-w

# Remove working files

clean:
	rm -f overlays.done *.dtbo ../overlays.md5

reallyclean: clean
	$(MAKE) -C $(EMBLINUXBASE)/bootkernel/kernel reallyclean BOARDNAME=$(BOARDNAME)
	rm -f dtc.done

distclean: reallyclean
