-- Digilent Pmod HYGRO Internet Thermometer Example Program

-- Copyright (C)2018-2025, Philip Munts dba Munts Technologies.
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

PRAGMA Warnings(Off, """error"" modified by call, but value overwritten");

WITH Ada.Calendar.Formatting;
WITH Ada.Strings.Fixed;
WITH ClickBoard.SevenSegment.SimpleIO;
WITH ClickBoard.SimpleIO;
WITH HDC1080;
WITH Humidity;
WITH I2C.libsimpleio;
WITH Temperature;
WITH Watchdog.libsimpleio;
WITH Webserver.HashTable;
WITH libLinux;

USE TYPE Humidity.Relative;
USE TYPE Temperature.Celsius;

USE Humidity.Relative_IO;
USE Temperature.Celsius_IO;

PROCEDURE thermometer_pmod_hygro IS

  newline : CONSTANT String := ASCII.CR & ASCII.LF;
  refresh : CONSTANT String := "<META HTTP-EQUIV='Refresh' CONTENT=5>" &
    newline;
  title   : CONSTANT String := "<h1>Ada Internet of Things Thermometer</h1>" &
    newline & "<h2>Using the Digilent Pmod HYGRO Module</h2>" & newline;
  sep     : CONSTANT String := "&nbsp;&nbsp;&nbsp;";
  bus     : I2C.Bus;
  sensor  : HDC1080.Device;
  display : ClickBoard.SevenSegment.Display;
  wd      : Watchdog.Timer;
  error   : Integer;
  T       : Temperature.Celsius;
  H       : Humidity.Relative;
  outbuf1 : String(1 .. 20);
  outbuf2 : String(1 .. 20);

BEGIN
  bus     := I2C.libsimpleio.Create(ClickBoard.SimpleIO.Create(1).I2C);
  sensor  := HDC1080.Create(bus);
  display := ClickBoard.SevenSegment.SimpleIO.Create(socknum => 2, pwmfreq => 0);
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
    H := sensor.Get;

    Put(outbuf1, T, 1, 0);
    Put(outbuf2, H, 1, 0);

    Webserver.HashTable.Publish("/", refresh & title & "<p>" &
      Ada.Calendar.Formatting.Image(Ada.Calendar.Clock) & " UTC" & sep &
      Ada.Strings.Fixed.Trim(outbuf1, Ada.Strings.Left) & " &deg;C" & sep &
      Ada.Strings.Fixed.Trim(outbuf2, Ada.Strings.Left) & " % RH</p>" &
      newline);

    IF T < -0.5 THEN
      display.Put(Natural(abs T), ClickBoard.SevenSegment.FEATURES_7SEG_LDP);
    ELSE
      display.Put(Natural(abs T));
    END IF;

    DELAY 0.3;

    wd.Kick;
  END LOOP;
END thermometer_pmod_hygro;
