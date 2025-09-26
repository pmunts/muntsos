-- Pimoroni Automation pHAT Modbus RTU test

-- Copyright (C)2020-2025, Philip Munts dba Munts Technologies.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH GPIO;
WITH Modbus.Coils;
WITH Modbus.DiscreteInputs;
WITH Modbus.InputShortFloat;
WITH Voltage;

PROCEDURE test_pimoroni_automation_phat_rtu IS

  PACKAGE VoltageInput IS NEW Modbus.InputShortFloat(Voltage.Volts);

  bus     : Modbus.Bus;
  adc1    : VoltageInput.Input;
  adc2    : VoltageInput.Input;
  adc3    : VoltageInput.Input;
  input1  : GPIO.Pin;
  input2  : GPIO.Pin;
  input3  : GPIO.Pin;
  output1 : GPIO.Pin;
  output2 : GPIO.Pin;
  output3 : GPIO.Pin;
  relay   : GPIO.Pin;

BEGIN
  New_Line;
  Put_Line("Pimoroni Automation pHAT Modbus RTU test");
  New_Line;

  bus     := Modbus.Create("/dev/ttyACM0");
  adc1    := VoltageInput.Create(bus, 10, 0);
  adc2    := VoltageInput.Create(bus, 10, 2);
  adc3    := VoltageInput.Create(bus, 10, 4);
  input1  := Modbus.DiscreteInputs.Create(bus, 10, 1);
  input2  := Modbus.DiscreteInputs.Create(bus, 10, 2);
  input3  := Modbus.DiscreteInputs.Create(bus, 10, 3);
  output1 := Modbus.Coils.Create(bus, 10, 1);
  output2 := Modbus.Coils.Create(bus, 10, 2);
  output3 := Modbus.Coils.Create(bus, 10, 3);
  relay   := Modbus.Coils.Create(bus, 10, 4);

  Put_Line("Press CONTROL-C to stop program.");
  New_Line;

  LOOP
    relay.Put(NOT relay.Get);
    Put("Digital Inputs:");
    Put(Natural'Image(Boolean'Pos(input1.Get)));
    Put(Natural'Image(Boolean'Pos(input2.Get)));
    Put(Natural'Image(Boolean'Pos(input3.Get)));
    Put(" Digital Outputs:");
    Put(Natural'Image(Boolean'Pos(output1.Get)));
    Put(Natural'Image(Boolean'Pos(output2.Get)));
    Put(Natural'Image(Boolean'Pos(output3.Get)));
    Put(" Analog Inputs:");
    Voltage.Volts_IO.Put(adc1.Get, 2, 2, 0);
    Voltage.Volts_IO.Put(adc2.Get, 2, 2, 0);
    Voltage.Volts_IO.Put(adc3.Get, 2, 2, 0);
    New_Line;
    DELAY 1.0;
  END LOOP;
END test_pimoroni_automation_phat_rtu;
