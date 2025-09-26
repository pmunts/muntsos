-- Support for the Waveshare CM4-Duino: https://www.waveshare.com/wiki/CM4-Duino

-- Copyright (C)2024-2025, Philip Munts dba Munts Technologies.
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

WITH GPIO.libsimpleio;
WITH I2C;
WITH PWM.libsimpleio;
WITH SPI;

PACKAGE Arduino.CM4_Duino IS

  -- Define subranges for I/O resources the CM4-Duino board provides

  SUBTYPE GPIOs      IS Arduino.Resources RANGE D0 .. D13;
  SUBTYPE Buttons    IS Arduino.Resources RANGE BTN1 .. BTN2;
  SUBTYPE LEDs       IS Arduino.Resources RANGE LED1 .. LED1;
  SUBTYPE I2CBuses   IS Arduino.Resources RANGE I2C1 .. I2C1;
  SUBTYPE PWMOutputs IS Arduino.Resources RANGE PWM0 .. PWM1;
  SUBTYPE SPIDevices IS Arduino.Resources RANGE SPI0 .. SPI0;

  -- Define some constants that match the CM4-Duino board silkscreen

  LED   : CONSTANT Resources := LED1;
  USER1 : CONSTANT Resources := BTN1;
  USER2 : CONSTANT Resources := BTN2;

  -- GPIO pin object constructors

  FUNCTION Create
   (desg      : Arduino.DigitalIOs;
    dir       : GPIO.Direction;
    state     : Boolean := False;
    driver    : GPIO.libsimpleio.Driver   := GPIO.libsimpleio.PushPull;
    edge      : GPIO.libsimpleio.Edge     := GPIO.libsimpleio.None;
    polarity  : GPIO.libsimpleio.Polarity := GPIO.libsimpleio.ActiveHigh) RETURN GPIO.Pin;

  -- I2C bus object constructor

  FUNCTION Create
   (desg      : I2CBuses) RETURN I2C.Bus;

  -- PWM output object constructor

  FUNCTION Create
   (desg      : PWMOutputs;
    frequency : Positive;
    dutycycle : PWM.DutyCycle := PWM.MinimumDutyCycle;
    polarity  : PWM.libsimpleio.Polarities := PWM.libsimpleio.ActiveHigh) RETURN PWM.Output;

  -- SPI slave device object constructor

  FUNCTION Create
   (desg      : SPIDevices;
    mode      : Natural;
    wordsize  : Natural;
    speed     : Natural) RETURN SPI.Device;

END Arduino.CM4_Duino;
