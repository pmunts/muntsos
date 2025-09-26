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

PRAGMA Warnings(Off, "redundant with clause in body");
PRAGMA Warnings(Off, "condition can only be False if invalid values present");

WITH Ada.Directories;

WITH Device;
WITH GPIO.libsimpleio;
WITH I2C.libsimpleio;
WITH SPI.libsimpleio;
WITH RaspberryPi;

USE TYPE Device.Designator;
USE TYPE GPIO.Direction;

PACKAGE BODY Arduino.CM4_Duino IS

  -- Map Arduino resource designators to Raspberry Pi device designators

  RPiDesignators : CONSTANT ARRAY (Arduino.Resources) OF Device.Designator :=
   (D0     => RaspberryPi.GPIO15,  -- aka RXD
    D1     => RaspberryPi.GPIO14,  -- aka TXD
    D2     => RaspberryPi.GPIO16,
    D3     => RaspberryPi.GPIO17,
    D4     => RaspberryPi.GPIO20,
    D5     => RaspberryPi.GPIO19,  -- aka PWM1
    D6     => RaspberryPi.GPIO18,  -- aka PWM0
    D7     => RaspberryPi.GPIO21,
    D8     => RaspberryPi.GPIO22,
    D9     => RaspberryPi.GPIO23,
    D10    => RaspberryPi.GPIO8,   -- aka SPI CE0
    D11    => RaspberryPi.GPIO10,  -- aka SPI MOSI
    D12    => RaspberryPi.GPIO9,   -- aka SPI MISO
    D13    => RaspberryPi.GPIO11,  -- aka SPI SCLK
    BTN1   => RaspberryPi.GPIO4,   -- aka USER1
    BTN2   => RaspberryPi.GPIO5,   -- aka USER2
    LED1   => RaspberryPi.GPIO6,   -- aka LED
    I2C1   => RaspberryPi.I2C1,
    PWM0   => RaspberryPi.PWM0,    -- aka GPIO18
    PWM1   => RaspberryPi.PWM1,    -- aka GPIO19
    SPI0   => RaspberryPi.SPI0_0,  -- aka GPIO8-11
    OTHERS => Device.Unavailable);

  -- GPIO pin object constructors

  FUNCTION Create
   (desg     : Arduino.DigitalIOs;
    dir      : Standard.GPIO.Direction;
    state    : Boolean := False;
    driver   : GPIO.libsimpleio.Driver   := GPIO.libsimpleio.PushPull;
    edge     : GPIO.libsimpleio.Edge     := GPIO.libsimpleio.None;
    polarity : GPIO.libsimpleio.Polarity := GPIO.libsimpleio.ActiveHigh) RETURN GPIO.Pin IS

  BEGIN
    IF RPiDesignators(desg) = Device.Unavailable THEN
      RAISE GPIO.GPIO_Error WITH desg'Image & " is not available.";
    END IF;

    -- Buttons must be inputs

    IF desg IN Buttons AND dir = GPIO.Output THEN
      RAISE GPIO.GPIO_Error WITH desg'Image & " cannot be configured as an output.";
    END IF;

    -- LEDs must be outputs

    IF desg IN LEDs AND dir = GPIO.Input THEN
      RAISE GPIO.GPIO_Error WITH desg'Image & " cannot be configured as an input.";
    END IF;

    -- Check for GPIO pin configuration conflicts

    IF desg >= D0 AND desg <= D1 AND Ada.Directories.Exists("/dev/ttyAMA0") THEN
      RAISE GPIO.GPIO_Error WITH desg'Image & " is already configured for UART0.";
    END IF;

    IF desg = D5 AND Ada.Directories.Exists("/sys/class/pwm/pwmchip0/pwm1") THEN
      RAISE GPIO.GPIO_Error WITH desg'Image & " is already configured for PWM1.";
    END IF;

    IF desg = D6 AND Ada.Directories.Exists("/sys/class/pwm/pwmchip0/pwm0") THEN
      RAISE GPIO.GPIO_Error WITH desg'Image & " is already configured for PWM0.";
    END IF;

    IF desg >= D10 AND desg <= D13 AND Ada.Directories.Exists("/dev/spidev0.0") THEN
      RAISE GPIO.GPIO_Error WITH desg'Image & " is already configured for SPI0.";
    END IF;

    RETURN GPIO.libsimpleio.Create(RPiDesignators(desg), dir, state, driver,
      edge, polarity);
  END Create;

  -- I2C bus object constructor

  FUNCTION Create
   (desg : I2CBuses) RETURN I2C.Bus IS

  BEGIN
    IF RPIDesignators(desg) = Device.Unavailable THEN
      RAISE I2C.I2C_Error WITH desg'Image & " is not available.";
    END IF;

    IF NOT Ada.Directories.Exists("/dev/i2c-1") THEN
      RAISE I2C.I2C_Error WITH desg'Image & " is not available.";
    END IF;

    RETURN I2C.libsimpleio.Create(RPIDesignators(desg));
  END Create;

  -- PWM output object constructor

  FUNCTION Create
   (desg      : PWMOutputs;
    frequency : Positive;
    dutycycle : PWM.DutyCycle := PWM.MinimumDutyCycle;
    polarity  : PWM.libsimpleio.Polarities := PWM.libsimpleio.ActiveHigh) RETURN PWM.Output IS

  BEGIN
    IF RPIDesignators(desg) = Device.Unavailable THEN
      RAISE PWM.PWM_Error WITH desg'Image & " is not available.";
    END IF;

    IF NOT Ada.Directories.Exists("/sys/class/pwm/pwmchip0") THEN
      RAISE PWM.PWM_Error WITH desg'Image & " is not available.";
    END IF;

    RETURN PWM.libsimpleio.Create(RPIDesignators(desg), frequency, dutycycle, polarity);
  END Create;

  -- SPI slave device constructor

  FUNCTION Create
   (desg      : SPIDevices;
    mode      : Natural;
    wordsize  : Natural;
    speed     : Natural) RETURN SPI.Device IS

  BEGIN
    IF RPIDesignators(desg) = Device.Unavailable THEN
      RAISE SPI.SPI_Error WITH desg'Image & " is not available.";
    END IF;

    IF NOT Ada.Directories.Exists("/dev/spidev0.0") THEN
      RAISE SPI.SPI_Error WITH desg'Image & " is not available.";
    END IF;

    RETURN SPI.libsimpleio.Create(RPIDesignators(desg), mode, wordsize, speed);
  END Create;

END Arduino.CM4_Duino;
