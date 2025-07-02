-- Wio-E5 LoRa Transceiver NNG Message MySQL Client

-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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

-- MySQL script to create table LoRaMessages:
--
-- drop table if exists LoRaMessages;
--
-- create table LoRaMessages
-- (
--   sender   varchar(20) not null,
--   receiver varchar(20) not null,
--   RSS      int not null,
--   SNR      int not null,
--   message  varchar(256) not null,
--   time     datetime not null default current_timestamp
-- );

WITH Ada.Directories;
WITH Ada.Environment_Variables;
WITH Ada.Strings.Fixed;
WITH Ada.Strings.Maps.Constants;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Debug;
WITH libLinux;
WITH MySQL.libmysqlclient;
WITH NNG.Sub;

PROCEDURE wioe5_nng_mysql IS

  PACKAGE dir RENAMES Ada.Directories;
  PACKAGE env RENAMES Ada.Environment_Variables;
  PACKAGE map RENAMES Ada.Strings.Maps;
  PACKAGE str RENAMES Ada.Strings.Fixed;

  FUNCTION GetEnv(s : String) RETURN String RENAMES env.Value;

  FUNCTION ToLower(s : string) RETURN String IS

  BEGIN
    RETURN str.Translate(s, map.Constants.Lower_Case_Map);
  END ToLower;

  FUNCTION Trim(s : String) RETURN String IS

  BEGIN
    RETURN str.Trim(s, Ada.Strings.Both);
  END Trim;

  FUNCTION GetToken(s : String; num : Positive) RETURN String IS

    Delimiters : CONSTANT map.Character_Set :=
      map.To_Set(' ');

    F : Positive;
    L : Natural := 0;
    N : Natural := 0;

  BEGIN
    WHILE N < num LOOP
      str.Find_Token(s, Delimiters, L + 1, Ada.Strings.Outside, F, L);
      N := N + 1;
    END LOOP;

    RETURN s(F .. L);

  EXCEPTION
    WHEN Ada.Strings.Index_Error => RETURN "";
  END GetToken;

  FUNCTION StripFieldName(field : String) RETURN String IS

  BEGIN
    RETURN field(field'First + 4 .. field'Last);
  END StripFieldName;

  err       : Integer;
  nngsock   : CONSTANT String := "/var/run/wioe5.sock";
  nngserver : NNG.Sub.Client;
  dbserver  : MySQL.libmysqlclient.Server;

BEGIN
  IF Debug.Enabled THEN
    New_Line;
    Put_Line("Wio-E5 LoRa Transceiver NNG Message MySQL Client");
    New_Line;
  ELSE
    New_Line;
    Put("Wio-E5 LoRa Transceiver NNG Message MySQL Client");
    libLinux.Detach(err);
  END IF;

  -- Connect to the NNC publisher

  WHILE NOT dir.Exists(nngsock) LOOP
    DELAY 0.1;
  END LOOP;

  nngserver.Initialize("ipc://" & nngsock);

  -- Connect to the MySQL server

  dbserver := MySQL.libmysqlclient.Create(GetEnv("MYSQL_SERVER"),
    GetEnv("MYSQL_USER"), GetEnv("MYSQL_PASS"), GetEnv("MYSQL_DB"),
    Positive'Value(GetEnv("MYSQL_PORT")));

  -- NNG message loop

  LOOP
    DECLARE
      inbuf     : String := nngserver.Get;
      srcnode   : String := StripFieldName(GetToken(inbuf, 1));
      dstnode   : String := StripFieldName(GetToken(inbuf, 2));
      RSS       : String := StripFieldName(GetToken(inbuf, 3));
      SNR       : String := StripFieldName(GetToken(inbuf, 4));
      message   : String := StripFieldName(inbuf(str.Index(inbuf  , "MSG:", 1) .. inbuf'Last));
      cmd       : String := "INSERT LoRaMessages VALUES ('" & srcnode & "', " &
                            "'" & dstnode & "', " & RSS & ", " & SNR & ", " &
                            "'" & message & "', DEFAULT)";
    BEGIN
      Debug.Put("inbuf   => " & inbuf);
      Debug.Put("srcnode => " & srcnode);
      Debug.Put("dstnode => " & dstnode);
      Debug.Put("RSS     => " & RSS);
      Debug.Put("SNR     => " & SNR);
      Debug.Put("message => " & message);
      Debug.Put("cmd     => " & cmd);
      Debug.Put("");

      dbserver.Dispatch(cmd);
    END;
  END LOOP;
END wioe5_nng_mysql;
