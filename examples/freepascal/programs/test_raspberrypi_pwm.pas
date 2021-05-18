{ Raspberry Pi PWM Output Test                                                }

{ Copyright (C)2018, Philip Munts, President, Munts AM Corp.                  }
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

{ NOTE: This program requires the PWM01 device tree overlay to be applied, by }
{ appending the following to /boot/config.txt:                                }
{                                                                             }
{ dtoverlay=PWM01                                                             }

PROGRAM test_raspberrypi_pwm;

USES
  SysUtils,
  RaspberryPi,
  PWM,
  PWM_libsimpleio;

VAR
  PWM0 : PWM.Output;
  PWM1 : PWM.Output;
  n    : Integer;

BEGIN
  Writeln;
  Writeln('Raspberry Pi PWM Output Test');
  Writeln;

  { Create some PWM output objects }

  PWM0 := PWM_libsimpleio.OutputSubclass.Create(RaspberryPi.PWM0, 100);
  PWM1 := PWM_libsimpleio.OutputSubclass.Create(RaspberryPi.PWM1, 100);

  { Sweep the pulse width back and forth }

  FOR n := 0 TO 100 DO
    BEGIN
      PWM0.dutycycle := n;
      PWM1.dutycycle := n;
      Sleep(50);
    END;

  FOR n := 100 DOWNTO 0 DO
    BEGIN
      PWM0.dutycycle := n;
      PWM1.dutycycle := n;
      Sleep(50);
    END;
END.
