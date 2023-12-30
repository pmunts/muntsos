# Makefile for building Beagle Bone device tree overlays

# Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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

BBOVERLAYSURL	= https://github.com/beagleboard/bb.org-overlays.git
BBOVERLAYSSRC	= bb.org-overlays

DTC		?= dtc

default: overlays.done

# Define a pattern rule for compiling device tree overlays

%.dtbo: %.dts
	$(DTC) -@ -b 0 -I dts -O dtb -o $@ $^

# Compile device tree overlays

overlays.done:
	# Compile BeagleBone overlays
	if [ ! -d $(BBOVERLAYSSRC) ]; then git clone $(BBOVERLAYSURL) ; fi
	$(MAKE) -C $(BBOVERLAYSSRC) DTC=$(DTC)
	cp bb.org-overlays/src/arm/PB-SPI1-ETH-CLICK.dtbo .
	cp bb.org-overlays/src/arm/PB-SPI0-ETH-CLICK.dtbo .
	cp bb.org-overlays/src/arm/PB-SPI0-ETH-WIZ-CLICK.dtbo .
	cp bb.org-overlays/src/arm/PB-SPI1-ETH-WIZ-CLICK.dtbo .
	# Compile MuntsOS custom overlays
	for F in *.dts ; do $(MAKE) `basename $$F .dts`.dtbo ; done
	touch $@

# Remove working files

clean:
	rm -rf *.dtbo overlays.done $(BBOVERLAYSSRC)

reallyclean: clean

distclean: reallyclean
