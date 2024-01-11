-- Support for the Waveshare CM4-Duino: https://www.waveshare.com/wiki/CM4-Duino

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

WITH Device;
WITH GPIO.libsimpleio;
WITH I2C.libsimpleio;
WITH PWM.libsimpleio;
WITH SPI.libsimpleio;
WITH RaspberryPi;

PACKAGE Arduino.CM4_Duino IS

  -- Define enumeration values for each of the available resources

  TYPE Buttons    IS (USER1, USER2);
  TYPE Indicators IS (LED);
  TYPE I2CBuses   IS (I2C1);
  TYPE PWMOutputs IS (PWM0, PWM1);
  TYPE SPIDevices IS (SPI0);

  -- Instantiate enumeration I/O packages

  PACKAGE Buttons_IO    IS NEW Ada.Text_IO.Enumeration_IO(Buttons);
  PACKAGE Indicators_IO IS NEW Ada.Text_IO.Enumeration_IO(Indicators);
  PACKAGE I2CBuses_IO   IS NEW Ada.Text_IO.Enumeration_IO(I2CBuses);
  PACKAGE PWMOutputs_IO IS NEW Ada.Text_IO.Enumeration_IO(PWMOutputs);
  PACKAGE SPIDevices_IO IS NEW Ada.Text_IO.Enumeration_IO(SPIDevices);

  -- GPIO pin object constructors

  FUNCTION Create
   (desg      : Arduino.DigitalPins;
    dir       : GPIO.Direction;
    state     : Boolean := False;
    driver    : GPIO.libsimpleio.Driver   := GPIO.libsimpleio.PushPull;
    edge      : GPIO.libsimpleio.Edge     := GPIO.libsimpleio.None;
    polarity  : GPIO.libsimpleio.Polarity := GPIO.libsimpleio.ActiveHigh) RETURN GPIO.Pin;

  FUNCTION Create
   (desg      : Buttons;
    edge      : GPIO.libsimpleio.Edge     := GPIO.libsimpleio.None;
    polarity  : GPIO.libsimpleio.Polarity := GPIO.libsimpleio.ActiveHigh) RETURN GPIO.Pin;

  FUNCTION Create
   (desg      : Indicators;
    state     : Boolean := False) RETURN GPIO.Pin;

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
