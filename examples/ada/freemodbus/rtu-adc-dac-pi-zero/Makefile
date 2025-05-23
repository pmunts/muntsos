# Copyright (C)2020-2024, Philip Munts dba Munts Technologies.
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

# Override the following macro to build out of tree

MUNTSOS		?= $(HOME)/muntsos

MODBUS_SRC	:= $(MUNTSOS)/examples/ada/freemodbus

LIBSIMPLEIO	?= /usr/local/share/libsimpleio

include $(MUNTSOS)/examples/ada/include/examples.mk
include $(MODBUS_SRC)/freemodbus.mk

default: rtu-adc-dac-pi-zero

rtu-adc-dac-pi-zero: modbus_rtu_mk_freemodbus
	mkdir -p $(ADA_OBJ)
	$(GNATMAKE) $(GNATMAKEFLAGS) -c freemodbus-services.adb -cargs $(GNATMAKECFLAGS)
	$(GNATBIND) -n $(ADA_OBJ)/*.ali
	$(GNATLINK) $(ADA_OBJ)/voltage.ali $(MODBUS_SRC)/obj/*.o -o $@ -lpthread -lsimpleio
	$(GNATSTRIP) $@

clean: modbus_rtu_mk_clean
	rm -f rtu-adc-dac-pi-zero

reallyclean: clean modbus_rtu_mk_reallyclean

distclean: reallyclean modbus_rtu_mk_distclean
