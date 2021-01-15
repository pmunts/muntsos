-- Pimoroni Enviro pHAT Light/Color Sensor Test

-- Copyright (C)2017-2019, Philip Munts, President, Munts AM Corp.
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

WITH Pimoroni_Enviro_pHAT;
WITH TCS3472;

PROCEDURE test_pimoroni_enviro_phat_color IS

  sample : TCS3472.Sample;

BEGIN
  New_Line;
  Put_Line("Pimoroni Enviro pHAT Light/Color Sensor Test");
  New_Line;

  -- Display brightness levels

  Put_Line("Press CONTROL-C to exit.");
  New_Line;

  LOOP
    Put("Brightness (C-R-G-B):");

    sample := Pimoroni_Enviro_pHAT.Light_Color.Get(100, Gain => TCS3472.X60);

    FOR b OF sample LOOP
      TCS3472.Brightness_IO.Put(b, 6);
    END LOOP;

    New_Line;
    DELAY 1.0;
  END LOOP;
END test_pimoroni_enviro_phat_color;
