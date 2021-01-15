-- Mikroelektronika Thermo Click Internet Thermometer Example Program

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

WITH Ada.Calendar.Formatting;
WITH Ada.Strings.Fixed;
WITH ClickBoard.SimpleIO;
WITH ClickBoard.Thermo.SimpleIO;
WITH ClickBoard.SevenSegment.SimpleIO;
WITH libLinux;
WITH MAX31855;
WITH Temperature;
WITH Watchdog.libsimpleio;
WITH Webserver.HashTable;

USE TYPE Temperature.Celsius;

USE Temperature.Celsius_IO;

PROCEDURE thermometer_thermo IS

  newline : CONSTANT String := ASCII.CR & ASCII.LF;
  refresh : CONSTANT String := "<META HTTP-EQUIV='Refresh' CONTENT=5>" &
    newline;
  title   : CONSTANT String := "<h1>Ada Internet of Things Thermometer</h1>" &
    newline & "<h2>Using the Mikroelektronika Thermo Click</h2>" & newline;
  sensor  : MAX31855.Device;
  display : ClickBoard.SevenSegment.Display;
  wd      : Watchdog.Timer;
  error   : Integer;
  T       : Temperature.Celsius;
  outbuf  : String(1 .. 20);

BEGIN
  sensor  := ClickBoard.Thermo.SimpleIO.Create(1);
  display := ClickBoard.SevenSegment.SimpleIO.Create(2);
  display.Clear;

  DELAY 5.0;

  wd := Watchdog.libsimpleio.Create;
  wd.SetTimeout(5.0);

  libLinux.Detach(error);

  Webserver.HashTable.Publish("/", title);
  Webserver.HashTable.Start;

  libLinux.DropPrivileges("nobody" & ASCII.NUL, error);

  LOOP
    T := sensor.Get;

    Put(outbuf, T, 1, 0);

    Webserver.HashTable.Publish("/", refresh & title & "<p>" &
      Ada.Calendar.Formatting.Image(Ada.Calendar.Clock) & " UTC -- " &
      Ada.Strings.Fixed.Trim(outbuf, Ada.Strings.Left) & " &deg;C</p>" &
      newline);

    IF T < -0.5 THEN
      display.Put(Natural(abs T), ClickBoard.SevenSegment.FEATURES_7SEG_LDP);
    ELSE
      display.Put(Natural(abs T));
    END IF;

    DELAY 0.3;

    wd.Kick;
  END LOOP;
END thermometer_thermo;
