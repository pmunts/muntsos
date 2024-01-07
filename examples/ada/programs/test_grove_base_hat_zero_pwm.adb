-- Grove Base Hat Zero PWM Output Test

-- Copyright (C)2020-2024, Philip Munts dba Munts Technologies.
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

-- NOTE: The following device tree overlay must be added to /boot/config.txt
-- to enable both PWM outputs on socket PWM:
--
-- dtoverlay=pwm-2chan,pin=12,func=4,pin2=13,func2=4

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Grove_Base_Hat_Zero;
WITH PWM.libsimpleio;

PROCEDURE test_grove_base_hat_zero_pwm IS

  PWM12 : PWM.Output;
  PWM13 : PWM.Output;

BEGIN
  New_Line;
  Put_Line("Grove Base Hat Zero PWM Output Test");
  New_Line;

  -- Create PWM output objects

  PWM12 := PWM.libsimpleio.Create(Grove_Base_Hat_Zero.PWM12, 1000);
  PWM13 := PWM.libsimpleio.Create(Grove_Base_Hat_Zero.PWM13, 1000);

  -- Sweep the pulse width back and forth

  LOOP
    FOR d IN 0 .. 100 LOOP
      PWM12.Put(PWM.DutyCycle(d));
      PWM13.Put(PWM.DutyCycle(d));
      DELAY 0.05;
    END LOOP;

    FOR d IN REVERSE 0 .. 100 LOOP
      PWM12.Put(PWM.DutyCycle(d));
      PWM13.Put(PWM.DutyCycle(d));
      DELAY 0.05;
    END LOOP;
  END LOOP;
END test_grove_base_hat_zero_pwm;
