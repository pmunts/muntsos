-- Raspberry Pi Sense Hat parent package

-- Copyright (C)2016-2023, Philip Munts dba Munts Technologies.
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

WITH I2C.libsimpleio;
WITH RaspberryPi;

PACKAGE SenseHAT IS

  -- I2C addresses of the devices on the sense hat.

  Address_AVR             : CONSTANT I2C.Address := 16#46#;
  Address_HTS221          : CONSTANT I2C.Address := 16#5F#;
  Address_LPS25H          : CONSTANT I2C.Address := 16#5C#;
  Address_LSM9DS1_AccGyro : CONSTANT I2C.Address := 16#6A#;
  Address_LSM9DS1_Magnet  : CONSTANT I2C.Address := 16#1C#;

  -- This I2C bus device will be shared among all SenseHAT child packages
  -- because everything on the Sense Hat is connected to the same I2C bus.

  bus : I2C.Bus := I2C.libsimpleio.Create(RaspberryPi.I2C1);

END SenseHAT;
