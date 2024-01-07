{ PocketBeagle PWM Output Test                                                }

{ Copyright (C)2018-2024, Philip Munts dba Munts Technologies.                }
{                                                                             }
{ Redistribution and use in source and binary forms, with or without          }
{ modification, are permitted provided that the following conditions are met: }
{                                                                             }
{ * Redistributions of source code must retain the above copyright notice,    }
{   this list of conditions and the following disclaimer.                     }
{                                                                             }
{ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" }
{ AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   }
{ IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  }
{ ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE   }
{ LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR         }
{ CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF        }
{ SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS    }
{ INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     }
{ CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)     }
{ ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE  }
{ POSSIBILITY OF SUCH DAMAGE.                                                 }

PROGRAM test_pocketbeagle_pwm;

USES
  SysUtils,
  PocketBeagle,
  PWM,
  PWM_libsimpleio;

VAR
  PWM1 : PWM.Output;
  PWM2 : PWM.Output;
  n    : Integer;

BEGIN
  Writeln;
  Writeln('PocketBeagle PWM Output Test');
  Writeln;

  { Create some PWM output objects }

  PWM1 := PWM_libsimpleio.OutputSubclass.Create(PWM0_0, 100);
  PWM2 := PWM_libsimpleio.OutputSubclass.Create(PWM2_0, 100);

  { Sweep the pulse width back and forth }

  FOR n := 0 TO 100 DO
    BEGIN
      PWM1.dutycycle := n;
      PWM2.dutycycle := n;
      Sleep(50);
    END;

  FOR n := 100 DOWNTO 0 DO
    BEGIN
      PWM1.dutycycle := n;
      PWM2.dutycycle := n;
      Sleep(50);
    END;
END.
