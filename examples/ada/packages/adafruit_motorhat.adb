-- Adafruit Raspberry Pi Motor Hat services

-- Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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

-- NOTE: The Adafruit Motor Hat for the Raspberry Pi has two dual-channel
-- TB6612FNG H-Bridge MOSFET motor drivers, and is capable of controlling
-- the speed and direction of four DC motors.  Each motor channel has three
-- control inputs: PWM, IN1, and IN2.  Each control input is driven by one
-- PCA9685 output.  Careful study of the TB6612FNG truth table reveals that:
--
-- PWM (despite its name) should be driven high all of the time.
-- IN1 should be pulsed high and IN2 driven low for clockwise rotation.
-- IN2 should be pulsed high and IN1 driven low for counterclockwise rotation.
-- IN1 and IN2 can both be driven high momentarily for braking.
-- IN1 and IN2 can both be driven low to stop the motor without braking.
--
-- The directions "clockwise" and "counterclockwise" are arbitrary.  The
-- actual direction of rotation for each motor will depend on how it is wired.

WITH GPIO;
WITH I2C.libsimpleio;
WITH Motor.PWM;
WITH PCA9685.GPIO;
WITH PCA9685.PWM;
WITH PWM;
WITH RaspberryPi;

PACKAGE BODY Adafruit_MotorHat IS

  i2caddr : CONSTANT I2C.Address := 16#60#;

  dev     : PCA9685.Device;

  TYPE MotorChannelsElement IS RECORD
    PWM : PCA9685.ChannelNumber; -- Really motor enable output
    IN1 : PCA9685.ChannelNumber; -- Really motor CW pulse output
    IN2 : PCA9685.ChannelNumber; -- Really motor CCW pulse output
  END RECORD;

  MotorChannels : CONSTANT ARRAY (MotorIds) OF MotorChannelsElement :=
   ((8, 10, 0), (13, 12, 11), (2, 4, 3), (7, 6, 5));

  -- Package initializer.  Must be called before any other service.

  PROCEDURE Init(frequency : Positive) IS

  BEGIN
    dev := PCA9685.Create(I2C.libsimpleio.Create(RaspberryPi.I2C1), i2caddr, frequency);
  END Init;

  -- Motor constructor

  FUNCTION Create(id : MotorIds) RETURN Motor.Output IS

    PWMout : GPIO.Pin;
    CWout  : PWM.Output;
    CCWout : PWM.Output;

  BEGIN
    PWMout := PCA9685.GPIO.Create(dev, MotorChannels(id).PWM, True);
    CWout  := PCA9685.PWM.Create(dev, MotorChannels(id).IN1, 0.0);
    CCWout := PCA9685.PWM.Create(dev, MotorChannels(id).IN2, 0.0);

    RETURN Motor.PWM.Create(CWout, CCWout, 0.0);
  END Create;

END Adafruit_Motorhat;
