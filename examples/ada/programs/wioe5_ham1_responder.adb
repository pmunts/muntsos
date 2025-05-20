-- Wio-E5 LoRa Transceiver Signal Level Responder

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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Debug;
WITH libLinux;
WITH Watchdog.libsimpleio;
WITH Wio_E5.Ham1;

PROCEDURE wioe5_ham1_responder IS

  PACKAGE LoRa IS NEW Wio_E5.Ham1;

  err     : Integer;
  wd      : Watchdog.Timer;
  dev     : LoRa.Device;
  msg     : LoRa.Payload;
  len     : Natural;
  srcnode : LoRa.NodeID;
  dstnode : LoRa.NodeID;
  RSS     : Integer;
  SNR     : Integer;

BEGIN
  IF Debug.Enabled THEN
    New_Line;
    Put_Line("Wio-E5 LoRa Transceiver Signal Level Responder");
    New_Line;
  ELSE
    New_Line;
    Put("Wio-E5 LoRa Transceiver Signal Level Responder");

    -- Run as background process

    libLinux.Detach(err);

    -- Create a watchdog timer device object

    wd := Watchdog.libsimpleio.Create;
    wd.SetTimeout(5.0);
  END IF;

  -- Create a LoRa transceiver object

  dev := LoRa.Create;

  LOOP
    dev.Receive(msg, len, srcnode, dstnode, RSS, SNR);

    IF len > 0 THEN
      dev.Send("LEN:" & len'Image & " bytes RSS:" & RSS'Image & " dBm SNR:" &
        SNR'Image & " dB", srcnode);
    END IF;

    IF NOT Debug.Enabled THEN
      wd.Kick;
    END IF;
  END LOOP;
END wioe5_ham1_responder;
