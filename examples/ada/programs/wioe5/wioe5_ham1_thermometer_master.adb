-- Wio-E5 LoRa Thermometer Master

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

WITH Ada.Command_Line;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Wio_E5.Ham1;

PROCEDURE wioe5_ham1_thermometer_master IS

  PACKAGE LoRa IS NEW Wio_E5.Ham1;

  dev     : LoRa.Device;
  slave   : LoRa.NodeID;
  msg     : LoRa.Payload;
  len     : Natural := 0;
  srcnode : LoRa.NodeID;
  dstnode : LoRa.NodeID;
  RSS     : Integer;
  SNR     : Integer;

BEGIN
  New_Line;
  Put_Line("Wio-E5 LoRa Thermometer Master");
  New_Line;

  IF Ada.Command_Line.Argument_Count /= 1 THEN
    Put_Line("Usage: wioe5_ham1_thermometer_master <node id>");
    New_Line;
    Ada.Command_Line.Set_Exit_Status(1);
    RETURN;
  END IF;

  dev   := LoRa.Create;
  slave := LoRa.NodeID'Value(Ada.Command_Line.Argument(1));

  dev.Send("MEASURE", slave);

  DELAY 0.4;

  dev.Receive(msg, len, srcnode, dstnode, RSS, SNR);

  IF len > 0 THEN
    Put_Line(LoRa.ToString(msg, len));
  END IF;

  dev.Shutdown;
END wioe5_ham1_thermometer_master;
