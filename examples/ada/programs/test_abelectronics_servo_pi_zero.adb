-- AB Electronics Servo Pi Zero Hat Test

-- Copyright (C)2016-2024, Philip Munts dba Munts Technologies.
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

WITH ABElectronics_Servo_Pi_Zero;
WITH PCA9685.PWM;
WITH Motor.Servo;
WITH Servo.PWM;

PROCEDURE test_abelectronics_servo_pi_zero IS

  dev    : PCA9685.device RENAMES ABElectronics_Servo_Pi_Zero.dev;
  Servo0 : Servo.Output;  -- Standard servo
  Servo1 : Motor.Output;  -- Continuous rotation servo

BEGIN
  Put_Line("AB Electronics Servo Pi Zero Hat Test");
  New_Line;

  -- Create servo objects

  Servo0 := Servo.PWM.Create(PCA9685.PWM.Create(dev, 0));
  Servo1 := Motor.Servo.Create(Servo.PWM.Create(PCA9685.PWM.Create(dev, 1)));

  -- Move servo on channel 0 back and forth

  Put_Line("Move servo forward...");

  FOR p IN Integer RANGE -100 .. 100 LOOP
    Servo0.Put(Servo.Position(Float(p)/100.0));
    DELAY 0.02;
  END LOOP;

  Put_Line("Move servo reverse...");

  FOR p IN REVERSE Integer RANGE -100 .. 100 LOOP
    Servo0.Put(Servo.Position(Float(p)/100.0));
    DELAY 0.02;
  END LOOP;

  DELAY 1.0;

  -- Run continuous rotation servo on channel 1

  Put_Line("Rotate servo forward...");

  FOR v IN Integer RANGE 0 .. 100 LOOP
    Servo1.Put(Motor.Velocity(Float(v)/100.0));
    DELAY 0.05;
  END LOOP;

  FOR v IN REVERSE Integer RANGE 0 .. 100 LOOP
    Servo1.Put(Motor.Velocity(Float(v)/100.0));
    DELAY 0.05;
  END LOOP;

  Put_Line("Rotate servo reverse...");

  FOR v IN Integer RANGE 0 .. 100 LOOP
    Servo1.Put(Motor.Velocity(Float(-v)/100.0));
    DELAY 0.05;
  END LOOP;

  FOR v IN REVERSE Integer RANGE 0 .. 100 LOOP
    Servo1.Put(Motor.Velocity(Float(-v)/100.0));
    DELAY 0.05;
  END LOOP;
END test_abelectronics_servo_pi_zero;
