{ BeagleBone Analog Input Test                                                }

{ Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.             }
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

PROGRAM test_beaglebone_adc(input, output);

USES
  ADC,
  ADC_libsimpleio,
  BeagleBone,
  SysUtils,
  Voltage;

VAR
  inputs : ARRAY [0 .. 6] OF Voltage.Input;
  i      : Voltage.Input;

BEGIN
  Writeln;
  Writeln('BeagleBone Analog Input Test');
  Writeln;

  { Create analog input objects }

  inputs[0] := Voltage.InputClass.Create(ADC_libsimpleio.InputSubclass.Create(AIN0, 12), 1.8);
  inputs[1] := Voltage.InputClass.Create(ADC_libsimpleio.InputSubclass.Create(AIN1, 12), 1.8);
  inputs[2] := Voltage.InputClass.Create(ADC_libsimpleio.InputSubclass.Create(AIN2, 12), 1.8);
  inputs[3] := Voltage.InputClass.Create(ADC_libsimpleio.InputSubclass.Create(AIN3, 12), 1.8);
  inputs[4] := Voltage.InputClass.Create(ADC_libsimpleio.InputSubclass.Create(AIN4, 12), 1.8);
  inputs[5] := Voltage.InputClass.Create(ADC_libsimpleio.InputSubclass.Create(AIN5, 12), 1.8);
  inputs[6] := Voltage.InputClass.Create(ADC_libsimpleio.InputSubclass.Create(AIN6, 12), 1.8);

  { Display analog samples }

  Writeln('Press CONTROL-C to exit.');
  Writeln;

  REPEAT
    FOR i IN inputs DO
      Write(i.Read : 6 : 2);

    Writeln;

    Sleep(2000);
  UNTIL False;
END.
