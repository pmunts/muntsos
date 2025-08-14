-- Wio-E5 LoRa Transceiver NNG Message Publisher

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
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Debug;
WITH libLinux;
WITH NNG.Pub;
WITH Watchdog.libsimpleio;
WITH Wio_E5.Ham1;

PROCEDURE wioe5_ham1_nng_publisher IS

  FUNCTION getenv(s : String) RETURN String RENAMES Ada.Environment_Variables.Value;

  FUNCTION Trim(s : String) RETURN String IS

  BEGIN
    RETURN Ada.Strings.Fixed.Trim(s, Ada.Strings.Both);
  END Trim;

  PACKAGE LoRa IS NEW Wio_E5.Ham1;

  err      : Integer;
  wd       : Watchdog.Timer;
  dev      : LoRa.Device;
  msg      : LoRa.Payload;
  len      : Natural;
  srcnode  : LoRa.NodeID;
  dstnode  : LoRa.NodeID;
  RSS      : Integer;
  SNR      : Integer;

  sockname : CONSTANT String := "/var/run/wioe5.sock";
  server   : NNG.Pub.Server;

BEGIN
  IF Debug.Enabled THEN
    New_Line;
    Put_Line("Wio-E5 LoRa Transceiver NNG Message Publisher");
    New_Line;
  ELSE
    New_Line;
    Put("Wio-E5 LoRa Transceiver NNG Message Publisher");

    -- Run as background process

    libLinux.Detach(err);

    -- Create a watchdog timer device object

    wd := Watchdog.libsimpleio.Create;
    wd.SetTimeout(5.0);
  END IF;

  -- Create a LoRa transceiver object

  dev := LoRa.Create;

  server.Initialize("ipc://" & sockname);

  LOOP
    dev.Receive(msg, len, srcnode, dstnode, RSS, SNR);

    IF len > 0 THEN
      DECLARE
        sender    : String := getenv("WIOE5_NETWORK") & '-' & Trim(srcnode'Image);
        recipient : String := getenv("WIOE5_NETWORK") & '-' & Trim(dstnode'Image);

        outbuf    : String := "SRC:" & sender          & " " &
                              "DST:" & recipient       & " " &
                              "RSS:" & Trim(RSS'Image) & " " &
                              "SNR:" & Trim(SNR'Image) & " " &
                              "MSG:" & LoRa.ToString(msg, len);
      BEGIN
        Debug.Put(outbuf);
        server.Put(outbuf);
      END;
    END IF;

    IF NOT Debug.Enabled THEN
      wd.Kick;
    END IF;
  END LOOP;
END wioe5_ham1_nng_publisher;
