{ MuntsOS GPIO Thin Server Toggle Speed Test Using HTTP                       }

{ Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.             }
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

PROGRAM Toggle_Speed(input, output);

USES
  DateUtils,
  GPIO,
  GPIO_HTTP,
  SysUtils;

VAR
  p          : GPIO.Pin;
  iterations : Integer;
  starttime  : TDateTime;
  i          : Integer;
  endtime    : TDateTime;
  deltat     : double;
  rate       : double;
  cycletime  : double;

BEGIN
  writeln;
  writeln('MuntsOS GPIO Thin Server Toggle Speed Test Using HTTP');
  writeln;

  IF ParamCount <> 3 THEN
    BEGIN
      writeln('Usage: Toggle_Speed <servername> <pin number> <iterations>');
      writeln;
      Halt(1);
    END;

  { Configure GPIO pins }

  p := GPIO_HTTP.PinSubclass.Create(ParamStr(1), StrToInt(ParamStr(2)), Output);

  iterations := StrToInt(ParamStr(3));

  writeln('Performing ', iterations, ' GPIO writes...');
  writeln;

  { Perform GPIO toggle speed test }

  starttime := TimeOf(Now);

  FOR i := 1 to iterations DIV 2 DO
    BEGIN
      p.state := True;
      p.state := False;
    END;

  endtime := TimeOf(Now);

  { Display results }

  deltat := SecondSpan(starttime, endtime);
  rate := iterations/deltat;
  cycletime := deltat/iterations;

  writeln('Performed ', iterations, ' GPIO writes in ', deltat : 1 : 1,
    ' seconds');
  writeln('  ', rate : 1 : 1, ' iterations per second');
  writeln('  ', cycletime*1E6 : 1 : 1, ' microseconds per iteration');
  writeln;
END.
