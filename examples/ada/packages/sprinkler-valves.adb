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

WITH Ada.Containers.Hashed_Maps;

USE TYPE Ada.Containers.Hash_Type;

PACKAGE BODY Sprinkler.Valves IS

  -- Simplest numeric index hash
  -- From "The Art of Computer Programming, Volume 3" by Donald E. Knuth

  FUNCTION Hash(K : ZoneNumber) RETURN Ada.Containers.Hash_Type IS

  BEGIN
    RETURN Ada.Containers.Hash_Type(K) MOD 1009;
  END Hash;

  PACKAGE ValveMap IS NEW Ada.Containers.Hashed_Maps(ZoneNumber, Valve, Hash,
    "=", "=");

  Valves : ValveMap.Map;

  -- Register a watering zone valve

  PROCEDURE Register(z : ZoneNumber; v : Sprinkler.Valve) IS

  BEGIN
    IF Valves.Contains(z) THEN
      RAISE Error WITH "Zone number has already been registered";
    END IF;

    Valves.Insert(z, v);
  END Register;

  -- Look up a watering zone valve

  FUNCTION Lookup(z : ZoneNumber) RETURN Sprinkler.Valve IS

  BEGIN
    IF NOT Valves.Contains(z) THEN
      RAISE Error WITH "Zone number has not been registered";
    END IF;

    RETURN Valves.Element(z);
  END Lookup;

END Sprinkler.Valves;
