-- System information services package

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

WITH Ada.Characters.Handling;
WITH Ada.Directories;
WITH Ada.Environment_Variables;
WITH Ada.Text_IO;

PACKAGE BODY SystemInfo IS

  model : CONSTANT String := "/sys/firmware/devicetree/base/model";

  FUNCTION ToLower(s : String) RETURN String RENAMES Ada.Characters.Handling.To_Lower;

  FUNCTION GetEnv(e : String) RETURN String IS

  BEGIN
    IF Ada.Environment_Variables.Exists(e) THEN
      RETURN Ada.Environment_Variables.Value(e);
    ELSE
      RETURN "unknown";
    END IF;
  END GetEnv;

  FUNCTION ModelName RETURN String IS

    m : Ada.Text_IO.File_Type;

  BEGIN
    IF NOT Ada.Directories.Exists(model) THEN
      RETURN "unknown";
    END IF;

    Ada.Text_IO.Open(m, Ada.Text_IO.In_File, model);

    DECLARE
      buf : CONSTANT String := Ada.Text_IO.Get_Line(m);
    BEGIN
      Ada.Text_IO.Close(m);
      RETURN buf;
    END;
  END ModelName;

  -- The following functions all return lower case strings!

  FUNCTION OSName RETURN String IS

  BEGIN
    RETURN ToLower(GetEnv("OSNAME"));
  END OSName;

  FUNCTION BoardFamily RETURN String IS

  BEGIN
    RETURN ToLower(GetEnv("BOARDBASE"));
  END BoardFamily;

  FUNCTION BoardName RETURN String IS

  BEGIN
    RETURN ToLower(GetEnv("BOARDNAME"));
  END BoardName;

  FUNCTION ShieldName RETURN String IS

  BEGIN
    RETURN ToLower(GetEnv("SHIELDNAME"));
  END ShieldName;

END SystemInfo;
