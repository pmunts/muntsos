-- MuntsOS Embedded Linux Lawn Sprinkler Unit Tests

-- Copyright (C)2020-2025, Philip Munts dba Munts Technologies.
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

PRAGMA Warnings(Off, "variable ""valve"" is assigned but never read");

WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Exceptions;

WITH Sprinkler.Program;
WITH Sprinkler.Valves;

PROCEDURE test_sprinkler_packages IS

  valve : Sprinkler.Valve;

BEGIN
  New_Line;
  Put_Line("MuntsOS Embedded Linux Lawn Sprinkler Unit Tests");
  New_Line;

  -- Try to register a valve

  BEGIN
    Put_Line("Register valve for zone 1");
    Sprinkler.Valves.Register(1, NULL);
  EXCEPTION
    WHEN e : OTHERS =>
      Put(Ada.Exceptions.Exception_Information(e));
  END;

  -- Try to register a duplicate valve

  BEGIN
    Put_Line("Register valve for zone 1");
    Sprinkler.Valves.Register(1, NULL);
  EXCEPTION
    WHEN e : OTHERS =>
      Put(Ada.Exceptions.Exception_Information(e));
  END;

  -- Try to lookup a valve

  BEGIN
    Put_Line("Look up valve for zone 1");
    valve := Sprinkler.Valves.Lookup(1);
  EXCEPTION
    WHEN e : OTHERS =>
      Put(Ada.Exceptions.Exception_Information(e));
  END;

  -- Try to lookup valve a nonexistent valve

  BEGIN
    Put_Line("Look up valve for zone 2");
    valve := Sprinkler.Valves.Lookup(2);
  EXCEPTION
    WHEN e : OTHERS =>
      Put(Ada.Exceptions.Exception_Information(e));
  END;

  -- Try to add a valid watering program step

  BEGIN
    Put_Line("Add watering program step for zone 1");
    Sprinkler.Program.Add(1, 1.0, 2.0);
  EXCEPTION
    WHEN e : OTHERS =>
      Put(Ada.Exceptions.Exception_Information(e));
  END;

  -- Try to add a watering program step with start time after stop time

  BEGIN
    Put_Line("Add watering program step for zone 1");
    Sprinkler.Program.Add(1, 2.0, 1.0);
  EXCEPTION
    WHEN e : OTHERS =>
      Put(Ada.Exceptions.Exception_Information(e));
  END;

  -- Try to add a watering program step for nonexistent zone

  BEGIN
    Put_Line("Add watering program step for zone 2");
    Sprinkler.Program.Add(2, 1.0, 2.0);
  EXCEPTION
    WHEN e : OTHERS =>
      Put(Ada.Exceptions.Exception_Information(e));
  END;
END test_sprinkler_packages;
