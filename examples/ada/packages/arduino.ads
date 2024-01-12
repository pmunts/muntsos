-- Arduino I/O Resource Designators

-- Copyright (C)2018-2024, Philip Munts dba Munts Technologies.
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

PACKAGE Arduino IS

  -- The following enumeration values represent the I/O resources available
  -- on a typical Arduino board.  Not every board will implement every one
  -- of these resources.  The canonical set of resources is: Analog inputs
  -- A0..A5, digital GPIO pins D0..D13, I2C bus I2C0, and possibly SPI slave
  -- device SPI0.  Even the canonical set is not carved in stone:  An I2C
  -- bus is sometimes routed to A4 and A5, any or all of A0..A5 can sometimes
  -- be configured for GPIO instead of analog input, and D10..13 may be
  -- configured as either an SPI bus or just GPIO pins.

  TYPE Resources IS
   (A0, A1, A2, A3, A4, A5, A6, A7,
    D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15,
    BTN0, BTN1, BTN2, BTN3, BTN4, BTN5, BTN6, BTN7,
    LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7,
    I2C0, I2C1, I2C2, I2C3, I2C4, I2C5, I2C6, I2C7,
    PWM0, PWM1, PWM2, PWM3, PWM4, PWM5, PWM6, PWM7,
    SPI0, SPI1, SPI2, SPI3, SPI4, SPI5, SPI6, SPI7);

  SUBTYPE AnalogInputs IS Resources RANGE A0 .. A7;
  SUBTYPE DigitalIOs   IS Resources RANGE D0 .. LED7;
  SUBTYPE Buttons      IS Resources RANGE BTN0 .. BTN7;
  SUBTYPE LEDs         IS Resources RANGE LED0 .. LED7;
  SUBTYPE I2CBuses     IS Resources RANGE I2C0 .. I2C7;
  SUBTYPE PWMOutputs   IS Resources RANGE PWM0 .. PWM7;
  SUBTYPE SPIDevices   IS Resources RANGE SPI0 .. SPI7;

  PACKAGE Resources_IO IS NEW Ada.Text_IO.Enumeration_IO(Resources);

END Arduino;
