{ Control /dev/userled as if it were a GPIO pin }

{ Copyright (C)2019-2024, Philip Munts dba Munts Technologies.                }
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

namespace IO.Objects.UserLED.GPIO;

interface

  type
    Pin = public class(IO.Interfaces.GPIO.Pin)
      private f : RemObjects.Elements.RTL.FileHandle;

      private method Get : Boolean;

      private method Put(s : Boolean);

      public constructor(s : Boolean := false);

      public property state : Boolean read Get write Put;
    end;

implementation

  constructor Pin(s : Boolean);

  begin
    self.f := new RemObjects.Elements.RTL.FileHandle('/dev/userled',
      RemObjects.Elements.RTL.FileOpenMode.ReadWrite);
    self.Put(s);
  end;

  method Pin.Get : Boolean;

  begin
    var inbuf : array [0 .. 3] of Byte := [0, 0, 0, 0];

    self.f.Position := 0;
    self.f.Read(inbuf, 4);

    Get := not ((inbuf[0] = ord('0')) and (inbuf[1] = 10));
  end;

  const PutStrings : array [Boolean] of array [0 .. 1] of Byte =
    [[ord('0'), 10], [ord('1'), 10]];

  method Pin.Put(s: Boolean);

  begin
    self.f.Write(PutStrings[s]);
    self.f.Flush();
  end;

end.
