{ Linux Simple I/O Library HID button and LED test                            }

{ Copyright (C)2016-2021, Philip Munts, President, Munts AM Corp.             }
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

PROGRAM test_hid_button_led(input, output);

USES
  HID_Munts,
  HID_libsimpleio,
  Message64;

VAR
  dev         : Message64.Messenger;
  LEDCommand  : Message64.Message;
  ButtonState : Message64.Message;

BEGIN
  Writeln;
  Writeln('HID Button and LED Test');
  Writeln;

  FillByte(ButtonState, 0, SizeOf(ButtonState));
  FillByte(LEDCommand, 0, SizeOf(LEDCommand));

  { Open the raw HID device }

  dev := HID_libsimpleio.MessengerSubclass.Create(HID_Munts.VID, HID_Munts.PID, '', -1);

  { Process incoming keypress reports }

  REPEAT
    dev.Receive(ButtonState);

    CASE ButtonState[0] OF
      0 :
        BEGIN
          Writeln('RELEASE');
          LEDCommand[0] := 0;
          dev.Send(LEDCommand);
        END;

      1 :
        BEGIN
          Writeln('PRESS');
          LEDCommand[0] := 1;
          dev.Send(LEDCommand);
        END;
    ELSE
      Writeln('ERROR: Unexpected keypress status value');
    END;
  UNTIL False;
END.
