# Copyright (C)2019-2021, Philip Munts, President, Munts AM Corp.
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
include $(LIBSIMPLEIO)/ada/include/ada.mk
include $(LIBSIMPLEIO)/ada/include/libsimpleio.mk

CFLAGS	+= -I$(MUNTSOS)/examples/ada/freemodbus

FREEMODBUS_NAME		= freemodbus
FREEMODBUS_VER		= v1.6
FREEMODBUS_SRC		= $(FREEMODBUS_NAME)-$(FREEMODBUS_VER)
FREEMODBUS_ZIP		= $(FREEMODBUS_SRC).zip
FREEMODBUS_SERVER	= https://www.embedded-solutions.at/wp-content/uploads/2018/09
FREEMODBUS_URL		= $(FREEMODBUS_SERVER)/$(FREEMODBUS_ZIP)
FREEMODBUS_DIST		= $(TEMP)/$(FREEMODBUS_ZIP)

CC	= $(CROSS_COMPILE)gcc
CCFLAGS	+= -c -Wall $(DEBUGFLAGS) $(EXTRAFLAGS) -pthread
CCFLAGS	+= -I$(MODBUS_SRC)/$(FREEMODBUS_SRC)/demo/LINUX/port
CCFLAGS	+= -I$(MODBUS_SRC)/$(FREEMODBUS_SRC)/modbus/rtu
CCFLAGS	+= -I$(MODBUS_SRC)/$(FREEMODBUS_SRC)/modbus/ascii
CCFLAGS	+= -I$(MODBUS_SRC)/$(FREEMODBUS_SRC)/modbus/include

CSRC	=  $(MODBUS_SRC)/freemodbus-rtu.c
CSRC	+= $(MODBUS_SRC)/$(FREEMODBUS_SRC)/demo/LINUX/port/portevent.c
CSRC	+= $(MODBUS_SRC)/$(FREEMODBUS_SRC)/demo/LINUX/port/porttimer.c
CSRC	+= $(MODBUS_SRC)/$(FREEMODBUS_SRC)/demo/LINUX/port/portother.c
CSRC	+= $(MODBUS_SRC)/$(FREEMODBUS_SRC)/demo/LINUX/port/portserial.c
CSRC	+= $(MODBUS_SRC)/$(FREEMODBUS_SRC)/modbus/ascii/mbascii.c
CSRC	+= $(MODBUS_SRC)/$(FREEMODBUS_SRC)/modbus/functions/mbfunccoils.c
CSRC	+= $(MODBUS_SRC)/$(FREEMODBUS_SRC)/modbus/functions/mbfuncdiag.c
CSRC	+= $(MODBUS_SRC)/$(FREEMODBUS_SRC)/modbus/functions/mbfuncdisc.c
CSRC	+= $(MODBUS_SRC)/$(FREEMODBUS_SRC)/modbus/functions/mbfuncholding.c
CSRC	+= $(MODBUS_SRC)/$(FREEMODBUS_SRC)/modbus/functions/mbfuncinput.c
CSRC	+= $(MODBUS_SRC)/$(FREEMODBUS_SRC)/modbus/functions/mbfuncother.c
CSRC	+= $(MODBUS_SRC)/$(FREEMODBUS_SRC)/modbus/functions/mbutils.c
CSRC	+= $(MODBUS_SRC)/$(FREEMODBUS_SRC)/modbus/mb.c
CSRC	+= $(MODBUS_SRC)/$(FREEMODBUS_SRC)/modbus/rtu/mbcrc.c
CSRC	+= $(MODBUS_SRC)/$(FREEMODBUS_SRC)/modbus/rtu/mbrtu.c

modbus_rtu_mk_default: default

###############################################################################

# Download FreeModbus library source distribution

$(FREEMODBUS_DIST):
	wget -nv -P $(TEMP) $(FREEMODBUS_URL)

# Unpack source distribution

$(MODBUS_SRC)/source.done: $(FREEMODBUS_DIST)
	cd $(MODBUS_SRC) && unzip $(FREEMODBUS_DIST)
	cd $(MODBUS_SRC)/$(FREEMODBUS_SRC) && patch -b -p0 <../address.patch
	cd $(MODBUS_SRC)/$(FREEMODBUS_SRC) && patch -b -p0 <../serialgadget.patch
	touch $@

# Compile C files

$(MODBUS_SRC)/compile.done: $(MODBUS_SRC)/source.done
	mkdir -p $(MODBUS_SRC)/obj
	for F in $(CSRC) ; do $(CC) $(CCFLAGS) -o$(MODBUS_SRC)/obj/`basename $$F .c`.o $$F ; done
	touch $@

modbus_rtu_mk_freemodbus: $(MODBUS_SRC)/source.done $(MODBUS_SRC)/compile.done

###############################################################################

# Remove working files

modbus_rtu_mk_clean: ada_mk_clean

modbus_rtu_mk_reallyclean: ada_mk_reallyclean modbus_rtu_mk_clean
	rm -rf $(MODBUS_SRC)/$(FREEMODBUS_SRC) $(MODBUS_SRC)/obj $(MODBUS_SRC)/source.done $(MODBUS_SRC)/compile.done

modbus_rtu_mk_distclean: ada_mk_distclean modbus_rtu_mk_reallyclean
	rm $(FREEMODBUS_DIST)
