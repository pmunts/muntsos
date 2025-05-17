-- Wio-E5 LoRa Transceiver Mail Forwarder

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

WITH Ada.Environment_Variables;
WITH Ada.Strings.Fixed;
WITH Ada.Strings.Maps.Constants;

WITH Email_Sendmail;
WITH libLinux;
WITH Messaging.Text;
WITH Watchdog.libsimpleio;
WITH Wio_E5.Ham2;

PROCEDURE wioe5_ham2_mailer IS

  FUNCTION getenv(s : String) RETURN String RENAMES Ada.Environment_Variables.Value;

  FUNCTION tolower(s : string) RETURN String IS

  BEGIN
    RETURN Ada.Strings.Fixed.Translate(s, Ada.Strings.Maps.Constants.Lower_Case_Map);
  END tolower;

  FUNCTION trim(s : String) RETURN String IS

  BEGIN
    RETURN Ada.Strings.Fixed.Trim(s, Ada.Strings.Both);
  END trim;

  PACKAGE LoRa IS NEW Wio_E5.Ham2;

  err     : Integer;
  wd      : Watchdog.Timer;
  dev     : LoRa.Device;
  msg     : LoRa.Payload;
  len     : Natural;
  srcnet  : LoRa.NetworkID;
  srcnode : LoRa.NodeID;
  dstnet  : LoRa.NetworkID;
  dstnode : LoRa.NodeID;
  RSS     : Integer;
  SNR     : Integer;

  relay : CONSTANT Messaging.Text.Relay := Email_Sendmail.Create;

BEGIN
  libLinux.Detach(err);

  -- Create a watchdog timer device object

  wd := Watchdog.libsimpleio.Create;

  -- Change the watchdog timeout period to 5 seconds

  wd.SetTimeout(5.0);

  -- Create a LoRa transceiver object

  dev := LoRa.Create;

  LOOP
    dev.Receive(msg, len, srcnet, srcnode, dstnet, dstnode, RSS, SNR);

    IF len > 0 THEN
      DECLARE
        username  : String := trim(srcnet) & '-' & trim(srcnode'Image);
        address   : String := tolower(username) & '@' & getenv("WIOE5_DOMAIN");
        sender    : String := username & " <" & address & ">";
        recipient : String := getenv("WIOE5_MAILTO");
      BEGIN
        relay.Send(sender, recipient, LoRa.ToString(msg, len), "Forwarded Message");
      END;
    END IF;

    wd.Kick;
  END LOOP;
END wioe5_ham2_mailer;
