-- Raspberry Pi Sense Hat joystick services

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

WITH Joystick;

PACKAGE SenseHAT.Joystick IS

  -- Joystick device instance

  Joystick : CONSTANT Standard.Joystick.Device;

PRIVATE

  -- Joystick device class definition

  TYPE DeviceSubclass IS NEW Standard.Joystick.DeviceInterface WITH NULL RECORD;

  -- Joystick position method

  FUNCTION Position(self : DeviceSubclass) RETURN Standard.Joystick.Positions;

  -- Joystick pressed method

  FUNCTION Pressed(self : DeviceSubclass) RETURN Boolean;

  -- Joystick device instance

  Joystick : CONSTANT Standard.Joystick.Device :=
    NEW DeviceSubclass'(NULL RECORD);

END SenseHAT.Joystick;
