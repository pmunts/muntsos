-- MuntsOS Embedded Linux Lawn Sprinkler Controller

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

WITH Ada.Text_IO;
WITH Ada.Calendar;

WITH Debug;
WITH Sprinkler.Program;
WITH Sprinkler.Valves.GPIO.libsimpleio;
WITH Watchdog.libsimpleio;
WITH libLinux;

PROCEDURE Sprinkler_Controller IS

  wd    : CONSTANT Watchdog.Timer :=
   (IF NOT Debug.Enabled THEN Watchdog.libsimpleio.Create ELSE NULL);

  error : Integer;

BEGIN
  Ada.Text_IO.Put_Line("MuntsOS Embedded Linux Lawn Sprinkler Controller");

  -- Read configuration files

  Ada.Text_IO.Put_Line("Registering zone valves");
  Sprinkler.Valves.GPIO.libsimpleio.LoadFromFile("/usr/local/etc/valves.config");

  Ada.Text_IO.Put_Line("Loading watering program");
  Sprinkler.Program.LoadFromFile("/usr/local/etc/watering.config");

  -- Switch to background execution, unless we are in debug mode

  IF NOT Debug.Enabled THEN
    Ada.Text_IO.Put_Line("Switching to background execution");
    libLinux.Detach(error);
  END IF;

  -- Wait for the system real time clock to be set by ntpd

  Ada.Text_IO.Put_Line("Waiting for valid RTC");

  WHILE Ada.Calendar.Year(Ada.Calendar.Clock) < 2020 LOOP
    IF NOT Debug.Enabled THEN
      wd.Kick;
    END IF;

    DELAY 1.0;
  END LOOP;

  -- Trivial main loop: Execute the watering program once a second

  Ada.Text_IO.Put_Line("Entering watering program loop");

  LOOP
    IF NOT Debug.Enabled THEN
      wd.Kick;
    END IF;

    Sprinkler.Program.Execute;

    DELAY 1.0;
  END LOOP;
END Sprinkler_Controller;
