{ MuntsOS GPIO Thin Server Button and LED Test Using HTTP                     }

{ Copyright (C)2016-2024, Philip Munts dba Munts Technologies.                }
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

PROGRAM Button_And_LED(input, output);

USES
  CRT,
  GPIO,
  GPIO_HTTP,
  SysUtils;

VAR
  Button     : GPIO.Pin;
  LED        : GPIO.Pin;
  ButtonNew  : Boolean;
  ButtonOld  : Boolean;

BEGIN
  writeln;
  writeln('MuntsOS GPIO Thin Server Button and LED Test Using HTTP');
  writeln;

  IF ParamCount <> 1 THEN
    BEGIN
      writeln('Usage: Button_And_LED <servername>');
      writeln;
      Halt(1);
    END;

  { Configure GPIO pins }

  Button := GPIO_HTTP.PinSubclass.Create(ParamStr(1), 19, Input);
  LED := GPIO_HTTP.PinSubclass.Create(ParamStr(1), 26, Output);

  { Force initial state change }

  ButtonOld := NOT Button.state;

  REPEAT

    { Read button input }

    ButtonNew := Button.state;

    { See if button state has changed }

    IF ButtonNew <> ButtonOld THEN
      BEGIN
        IF ButtonNew THEN
          writeln('PRESSED')
        ELSE
          writeln('RELEASED');

        LED.state := ButtonNew;
        ButtonOld := ButtonNew;
      END;

    Sleep(100);
  UNTIL keypressed;
END.
