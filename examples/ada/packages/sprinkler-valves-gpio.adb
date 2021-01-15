-- Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY Sprinkler.Valves.GPIO IS

  -- Implement ValveInterface using a GPIO pin

  TYPE ValveSubclass IS NEW ValveInterface WITH RECORD
    pin : Standard.GPIO.Pin;
  END RECORD;

  FUNCTION Get(Self : IN OUT ValveSubclass) RETURN Boolean;

  PROCEDURE Put(Self : IN OUT ValveSubclass; state : Boolean);

  FUNCTION Get(Self : IN OUT ValveSubclass) RETURN Boolean IS

  BEGIN
    RETURN Self.pin.Get;
  END Get;

  PROCEDURE Put(Self : IN OUT ValveSubclass; state : Boolean) IS

  BEGIN
    Self.pin.Put(state);
  END Put;

  -- Register a watering zone valve controlled by a GPIO pin

  PROCEDURE Register(zone : ZoneNumber; pin : Standard.GPIO.Pin) IS

  BEGIN
    Sprinkler.Valves.Register(zone, NEW ValveSubclass'(pin => pin));
  END Register;

END Sprinkler.Valves.GPIO;
