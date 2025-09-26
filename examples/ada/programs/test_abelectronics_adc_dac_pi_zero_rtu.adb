-- AB Electronics ADC DAC Pi Zero RTU test

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

WITH Modbus.InputShortFloat;
WITH Modbus.OutputShortFloat;
WITH Voltage;

PROCEDURE test_abelectronics_adc_dac_pi_zero_rtu IS

  PACKAGE VoltageInput  IS NEW Modbus.InputShortFloat(Voltage.Volts);
  PACKAGE VoltageOutput IS NEW Modbus.OutputShortFloat(Voltage.Volts);

  bus  : Modbus.Bus;
  IN1  : VoltageInput.Input;
  IN2  : VoltageInput.Input;
  OUT1 : VoltageOutput.Output;
  OUT2 : VoltageOutput.Output;

BEGIN
  New_Line;
  Put_Line("AB Electronics ADC DAC Pi Zero RTU test");
  New_Line;

  bus  := Modbus.Create("/dev/ttyACM0");
  IN1  := VoltageInput.Create(bus, 10, 0);
  IN2  := VoltageInput.Create(bus, 10, 2);
  OUT1 := VoltageOutput.Create(bus, 10, 0, 0.0);
  OUT2 := VoltageOutput.Create(bus, 10, 2, 0.0);

  Put_Line("Press CONTROL-C to stop program.");
  New_Line;

  LOOP
    Put("Analog Inputs:");
    Voltage.Volts_IO.Put(IN1.Get, 2, 2, 0);
    Voltage.Volts_IO.Put(IN2.Get, 2, 2, 0);
    Put("  Analog Outputs:");
    Voltage.Volts_IO.Put(OUT1.Get, 2, 2, 0);
    Voltage.Volts_IO.Put(OUT2.Get, 2, 2, 0);
    New_Line;

    BEGIN
      OUT1.Put(IN1.Get);
    EXCEPTION
      WHEN OTHERS =>
        NULL;
    END;

    BEGIN
      OUT2.Put(IN2.Get);
    EXCEPTION
      WHEN OTHERS =>
        NULL;
    END;

    DELAY 1.0;
  END LOOP;
END test_abelectronics_adc_dac_pi_zero_rtu;
