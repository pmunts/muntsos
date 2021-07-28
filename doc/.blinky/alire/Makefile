# Build an Alire crate to contain the Ada blinky program

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

LIBSIMPLEIO	?= /usr/local/share/libsimpleio
ADA_SRC		?= $(LIBSIMPLEIO)/ada

CRATE_NAME	:= muntsos_blinky
CRATE_VERSION	:= 1.0.0

PROJECT_NAME	:= muntsos_blinky

default: pack

include $(ADA_SRC)/include/alire.mk

# Load the crate

populate.done: alire_mk_init_prog
	install -cm 0644 ../../AppNote7-Flash-LED-Ada-Alire.pdf $(CRATE_DIR)
	install -cm 0644 ../blinky.adb $(CRATE_DIR)/src
	ln -s /usr/local/gcc-arm-linux-gnueabihf-muntsos-RaspberryPi1-crosstool/share/gpr/RaspberryPi1.cgpr $(CRATE_DIR)/default.cgpr
ifneq ($(GNATPP),)
	cd $(CRATE_DIR)/src && find * -type f -exec $(GNATPP) {} ";"
endif
	touch $@

# Pack the crate

pack: populate.done alire_mk_pack

# Build the crate

build: alire_mk_build

# Publish the crate

publish: alire_mk_publish

# Remove working files

clean: alire_mk_clean
	rm -f *.done

reallyclean: alire_mk_reallyclean clean

distclean: alire_mk_reallyclean reallyclean
