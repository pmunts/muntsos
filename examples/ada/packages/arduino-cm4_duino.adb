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

WITH Ada.Containers.Bounded_Vectors;
WITH Ada.Directories;

WITH Device;
WITH GPIO.libsimpleio;
WITH I2C.libsimpleio;
WITH SPI.libsimpleio;
WITH RaspberryPi;

USE TYPE Device.Designator;
USE TYPE GPIO.Direction;

PACKAGE BODY Arduino.CM4_Duino IS

  -- Define resource mapping tables

  MGPIOs      : CONSTANT ARRAY (Arduino.DigitalPins) OF Device.Designator :=
   (D0    => RaspberryPi.GPIO15,  -- aka RXD
    D1    => RaspberryPi.GPIO14,  -- aka TXD
    D2    => RaspberryPi.GPIO16,
    D3    => RaspberryPi.GPIO17,
    D4    => RaspberryPi.GPIO20,
    D5    => RaspberryPi.GPIO19,  -- aka PWM1
    D6    => RaspberryPi.GPIO18,  -- aka PWM0
    D7    => RaspberryPi.GPIO21,
    D8    => RaspberryPi.GPIO22,
    D9    => RaspberryPi.GPIO23,
    D10   => RaspberryPi.GPIO8,   -- aka SPI CE0
    D11   => RaspberryPi.GPIO10,  -- aka SPI MOSI
    D12   => RaspberryPi.GPIO9,   -- aka SPI MISO
    D13   => RaspberryPi.GPIO11); -- aka SPI SCLK

  MButtons    : CONSTANT ARRAY (Buttons)    OF Device.Designator :=
   (USER1 => RaspberryPi.GPIO4,
    USER2 => RaspberryPi.GPIO5);

  MIndicators : CONSTANT ARRAY (Indicators) OF Device.Designator :=
   (LED   => RaspberryPi.GPIO6);

  MI2CBuses   : CONSTANT ARRAY (I2CBuses)   OF Device.Designator :=
   (I2C1  => RaspberryPi.I2C1);

  MPWMOutputs : CONSTANT ARRAY (PWMOutputs) OF Device.Designator :=
   (PWM0  => RaspberryPi.PWM0,
    PWM1  => RaspberryPi.PWM1);

  MSPIDevices : CONSTANT ARRAY (SPIDevices) OF Device.Designator :=
   (SPI0  => RaspberryPi.SPI0_0);

  -- GPIO pin object constructors

  FUNCTION Create
   (desg     : Arduino.DigitalPins;
    dir      : Standard.GPIO.Direction;
    state    : Boolean := False;
    driver   : GPIO.libsimpleio.Driver   := GPIO.libsimpleio.PushPull;
    edge     : GPIO.libsimpleio.Edge     := GPIO.libsimpleio.None;
    polarity : GPIO.libsimpleio.Polarity := GPIO.libsimpleio.ActiveHigh) RETURN GPIO.Pin IS

  BEGIN
    -- Check for pin conflicts

    IF desg < D2 AND Ada.Directories.Exists("/dev/ttyAMA0") THEN
      RAISE GPIO.GPIO_Error WITH desg'Image & " is already configured for UART0.";
    END IF;

    IF desg = D5 AND Ada.Directories.Exists("/sys/class/pwm/pwmchip0/pwm1") THEN
      RAISE GPIO.GPIO_Error WITH desg'Image & " is already configured for PWM1.";
    END IF;

    IF desg = D6 AND Ada.Directories.Exists("/sys/class/pwm/pwmchip0/pwm0") THEN
      RAISE GPIO.GPIO_Error WITH desg'Image & " is already configured for PWM0.";
    END IF;

    IF desg > D9 AND Ada.Directories.Exists("/dev/spidev0.0") THEN
      RAISE GPIO.GPIO_Error WITH desg'Image & " is already configured for SPI0.";
    END IF;

    RETURN GPIO.libsimpleio.Create(MGPIOs(desg), dir, state, driver, edge, polarity);
  END Create;

  FUNCTION Create
   (desg      : Buttons;
    edge      : GPIO.libsimpleio.Edge     := GPIO.libsimpleio.None;
    polarity  : GPIO.libsimpleio.Polarity := GPIO.libsimpleio.ActiveHigh) RETURN GPIO.Pin IS

  BEGIN
    RETURN GPIO.libsimpleio.Create(MButtons(desg), GPIO.Input, False,
      GPIO.libsimpleio.PushPull, edge, polarity);
  END Create;

  FUNCTION Create
   (desg      : Indicators;
    state     : Boolean := False) RETURN GPIO.Pin IS

  BEGIN
    RETURN GPIO.libsimpleio.Create(MIndicators(desg), GPIO.Output, state,
      GPIO.libsimpleio.OpenDrain);
  END Create;

  -- I2C bus object constructor

  FUNCTION Create
   (desg      : I2CBuses) RETURN I2C.Bus IS

  BEGIN
    IF NOT Ada.Directories.Exists("/dev/i2c-1") THEN
      RAISE I2C.I2C_Error WITH desg'Image & " is not available.";
    END IF;

    RETURN I2C.libsimpleio.Create(MI2CBuses(desg));
  END Create;

  -- PWM output object constructor

  FUNCTION Create
   (desg      : PWMOutputs;
    frequency : Positive;
    dutycycle : PWM.DutyCycle := PWM.MinimumDutyCycle;
    polarity  : PWM.libsimpleio.Polarities := PWM.libsimpleio.ActiveHigh) RETURN PWM.Output IS

  BEGIN
    IF NOT Ada.Directories.Exists("/sys/class/pwm/pwmchip0") THEN
      RAISE PWM.PWM_Error WITH desg'Image & " is not available.";
    END IF;

    RETURN PWM.libsimpleio.Create(MPWMOutputs(desg), frequency, dutycycle, polarity);
  END Create;

  -- SPI slave device constructor

  FUNCTION Create
   (desg      : SPIDevices;
    mode      : Natural;
    wordsize  : Natural;
    speed     : Natural) RETURN SPI.Device IS

  BEGIN
    IF NOT Ada.Directories.Exists("/dev/spidev0.0") THEN
      RAISE SPI.SPI_Error WITH desg'Image & " is not available.";
    END IF;

    RETURN SPI.libsimpleio.Create(MSPIDevices(desg), mode, wordsize, speed);
  END Create;

END Arduino.CM4_Duino;
