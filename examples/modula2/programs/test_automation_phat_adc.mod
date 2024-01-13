(* Copyright (C)2018-2023, Philip Munts dba Munts Technologies.                *)
(*                                                                             *)
(* Redistribution and use in source and binary forms, with or without          *)
(* modification, are permitted provided that the following conditions are met: *)
(*                                                                             *)
(* * Redistributions of source code must retain the above copyright notice,    *)
(*   this list of conditions and the following disclaimer.                     *)
(*                                                                             *)
(* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" *)
(* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   *)
(* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  *)
(* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE   *)
(* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR         *)
(* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF        *)
(* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS    *)
(* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     *)
(* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)     *)
(* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE  *)
(* POSSIBILITY OF SUCH DAMAGE.                                                 *)

MODULE test_automation_phat_adc;

FROM STextIO IMPORT WriteString, WriteLn;
FROM SWholeIO IMPORT WriteCard;
FROM SRealIO IMPORT WriteFixed;
FROM FIO IMPORT FlushOutErr;

FROM Automation_pHAT IMPORT AIN, ReadVoltage;
FROM ErrorHandling IMPORT CheckError;
FROM liblinux IMPORT LINUX_usleep;

VAR
  channel : CARDINAL;
  voltage : REAL;
  error   : CARDINAL;

BEGIN
  WriteLn;
  WriteString("Raspberry Pi Automation pHAT A/D Test");
  WriteLn;
  WriteLn;
  WriteString("Press CONTROL-C to exit");
  WriteLn;
  WriteLn;
  FlushOutErr;

  LOOP
    FOR channel := 0 TO 2 DO
      ReadVoltage(AIN[channel], voltage, error);
      CheckError(error, "ReadVoltage() failed");

      WriteString("AIN");
      WriteCard(channel, 0);
      WriteString("=");
      WriteFixed(voltage, 2, 4);
      WriteString(" V  ");
    END;

    WriteLn;
    FlushOutErr;

    LINUX_usleep(1000000, error);
    CheckError(error, "LINUX_usleep() failed");
  END;
END test_automation_phat_adc.
