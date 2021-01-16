# Copyright (C)2020-2021, Philip Munts, President, Munts AM Corp.
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

MUNTSOS		?= $(HOME)/arm-linux-mcu

MODBUS_SRC	:= $(MUNTSOS)/examples/ada/freemodbus

include $(MUNTSOS)/examples/ada/include/examples.mk
include $(MODBUS_SRC)/freemodbus.mk

default: rtu-raspberrypi-gpio

rtu-raspberrypi-gpio: modbus_rtu_mk_freemodbus
	mkdir -p $(ADA_OBJ)
	$(GNATMAKE) $(GNATMAKEFLAGS) -c freemodbus-services.adb -cargs $(GNATMAKECFLAGS)
	$(GNATBIND) -n $(ADA_OBJ)/*.ali
	$(GNATLINK) $(ADA_OBJ)/logging.ali $(MODBUS_SRC)/obj/*.o -o $@ -lpthread -lsimpleio
	$(GNATSTRIP) $@

clean: modbus_rtu_mk_clean
	rm -f rtu-raspberrypi-gpio

reallyclean: clean modbus_rtu_mk_reallyclean

distclean: reallyclean modbus_rtu_mk_distclean
