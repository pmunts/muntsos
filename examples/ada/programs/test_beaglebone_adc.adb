-- BeagleBone Analog Input Test

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

WITH errno;
WITH libADC;
WITH ADC.libsimpleio;
WITH Voltage;

PROCEDURE test_beaglebone_adc IS

  name    : String(1 .. 256);
  error   : Integer;
  inputs  : ARRAY (0 .. 6) OF Voltage.Input;

BEGIN
  New_Line;
  Put_Line("BeagleBone Analog Input Test");
  New_Line;

  libADC.GetName(0, name, name'Length, error);

  IF error /= 0 THEN
    RAISE ADC.ADC_ERROR WITH "libADC.GetName() failed, " & errno.strerror(error);
  END IF;

  Put_Line("Device name: " & name);
  New_Line;

  FOR c IN inputs'Range LOOP
    inputs(c) := ADC.Create(ADC.libsimpleio.Create((0, c), 12), 1.8);
  END LOOP;

  Put_Line("Press CONTROL-C to exit.");
  New_Line;

  LOOP
    Put("Voltages:");

    FOR v OF inputs LOOP
      Voltage.Volts_IO.Put(v.Get, 3, 3, 0);
    END LOOP;

    New_Line;
    DELAY 2.0;
  END LOOP;
END test_beaglebone_adc;
