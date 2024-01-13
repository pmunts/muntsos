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

IMPLEMENTATION MODULE Enviro_pHAT;

  IMPORT
    RaspberryPi;

  FROM ErrorHandling IMPORT CheckError;

  CONST
    ADS1015_REFERENCE = 2.048;  (* Internal voltage reference *)
    ADS1015_GAIN      = 3.0;    (* Internal PGA gain *)
    ADS1015_STEPS     = 2048;   (* 11 bits single ended input resolution *)
    EXTERNAL_GAIN     = 1.0;
    EXTERNAL_RANGE    = ADS1015_REFERENCE*ADS1015_GAIN/EXTERNAL_GAIN;
    STEPSIZE          = EXTERNAL_RANGE/FLOAT(ADS1015_STEPS);

  PROCEDURE ReadVoltage
   (pin         : adc_libsimpleio.Pin;
    VAR voltage : REAL;
    VAR error   : CARDINAL);

  VAR
    sample : INTEGER;

  BEGIN
    adc_libsimpleio.Read(pin, sample, error);

    IF error <> 0 THEN
      RETURN;
    END;

    voltage := FLOAT(sample)*STEPSIZE;
  END ReadVoltage;

  VAR
    n     : CARDINAL;
    error : CARDINAL;

BEGIN

  (* Configure analog inputs *)

  FOR n := 0 TO 3 DO
    adc_libsimpleio.Open(0, n, AIN[n], error);
    CheckError(error, "adc_libsimpleio.Open() failed");
  END;

  (* Configure GPIO outputs *)

  gpio_libsimpleio.OpenChannel(RaspberryPi.GPIO4,
    gpio_libsimpleio.Output, FALSE, gpio_libsimpleio.PushPull,
    gpio_libsimpleio.None, gpio_libsimpleio.ActiveHigh, LED, error);
  CheckError(error, "gpio_libsimpleio.Open() failed");

END Enviro_pHAT.
