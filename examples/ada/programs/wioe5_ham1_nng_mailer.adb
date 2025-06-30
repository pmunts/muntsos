-- Wio-E5 LoRa Transceiver NNG Subscriber Message Mailer

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

WITH Ada.Directories;
WITH Ada.Environment_Variables;
WITH Ada.Strings.Fixed;
WITH Ada.Strings.Maps.Constants;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Debug;
WITH Email_Mail;
WITH libLinux;
WITH Messaging.Text;
WITH NNG.Sub;

PROCEDURE wioe5_ham1_nng_mailer IS

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

  sockname : CONSTANT String := "ipc:///tmp/wioe5.sock";

  err      : Integer;
  client   : NNG.Sub.Client;
  relay    : Messaging.Text.Relay := Email_Mail.Create;

BEGIN
  IF Debug.Enabled THEN
    New_Line;
    Put_Line("Wio-E5 LoRa Transceiver NNG Subscriber Message Mailer");
    New_Line;
  ELSE
    New_Line;
    Put("Wio-E5 LoRa Transceiver NNG Subscriber Message Mailer");
    libLinux.Detach(err);
  END IF;

  WHILE NOT dir.Exists(sockname) LOOP
    DELAY 0.1;
  END LOOP;

  client.Initialize(sockname);

  LOOP
    DECLARE
      message   : String := client.Get;
      srcnode   : String := GetToken(message, 1);
      username  : String := srcnode(5 .. srcnode'Last);
      sender    : String := ToLower(username) & '@' & GetEnv("EMAIL_DOMAIN");
      recipient : String := GetEnv("EMAIL_RECIPIENT");
    BEGIN
      Debug.Put("Sender    => " & sender);
      Debug.Put("Recipient => " & recipient);
      Debug.Put("Message   => " & message);
      Debug.Put("");

      relay.Send(sender, recipient, message, "Message from LoRa Station " &
        username);
    END;
  END LOOP;
END wioe5_ham1_nng_mailer;
