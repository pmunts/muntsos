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

MODULE test_automation_phat_relay;

IMPORT
   gpio_libsimpleio;

FROM STextIO IMPORT WriteString, WriteLn;
FROM FIO IMPORT FlushOutErr;

FROM Automation_pHAT IMPORT RELAY;
FROM ErrorHandling IMPORT CheckError;
FROM liblinux IMPORT LINUX_usleep;

VAR
  error   : CARDINAL;

BEGIN
  WriteLn;
  WriteString("Raspberry Pi Automation pHAT Relay Test");
  WriteLn;
  WriteLn;
  WriteString("Press CONTROL-C to exit");
  WriteLn;
  WriteLn;
  FlushOutErr;

  LOOP
    gpio_libsimpleio.Write(RELAY, TRUE, error);
    CheckError(error, "gpio_libsimpleio.Write() failed");

    LINUX_usleep(1000000, error);
    CheckError(error, "LINUX_usleep() failed");

    gpio_libsimpleio.Write(RELAY, FALSE, error);
    CheckError(error, "gpio_libsimpleio.Write() failed");

    LINUX_usleep(1000000, error);
    CheckError(error, "LINUX_usleep() failed");
  END;
END test_automation_phat_relay.
