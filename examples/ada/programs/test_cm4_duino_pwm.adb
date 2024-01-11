-- Waveshare CM4-Duino (https://www.waveshare.com/wiki/CM4-Duino) PWM Output Test

-- Copyright (C)2024, Philip Munts dba Munts Technologies.
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

WITH Ada.Text_IO;
USE Ada.Text_IO;

WITH Arduino.CM4_Duino;
WITH PWM;

PROCEDURE test_cm4_duino_pwm IS

  desg : Arduino.CM4_Duino.PWMOutputs;
  outp : PWM.Output;

BEGIN
  New_Line;
  Put_Line("CM4-Duino PWM Output Test");
  New_Line;

  Put("Enter PWM output designator: ");
  Arduino.CM4_Duino.PWMOutputs_IO.Get(desg);
  New_Line;

  Put_Line("Press CONTROL-C to exit.");
  New_Line;

  -- Create PWM output object

  outp := Arduino.CM4_Duino.Create(desg, 1000);

  -- Sweep the pulse width back and forth

  LOOP
    FOR d IN 0 .. 100 LOOP
      outp.Put(PWM.DutyCycle(d));
      DELAY 0.05;
    END LOOP;

    FOR d IN REVERSE 0 .. 100 LOOP
      outp.Put(PWM.DutyCycle(d));
      DELAY 0.05;
    END LOOP;
  END LOOP;
END test_cm4_duino_pwm;
