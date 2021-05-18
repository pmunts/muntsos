{ Mikroelektronika 7Seg Click Test for PocketBeagle }

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

PROGRAM test_click_7seg;

USES
  Click_7Seg,
  GPIO,
  GPIO_libsimpleio,
  PocketBeagle,
  PWM,
  PWM_libsimpleio,
  SPI,
  SPI_libsimpleio,
  SPI_Shift_Register_74HC595,
  SysUtils;

VAR
  spidev : SPI.Device;
  pwmout : PWM.Output;
  rstpin : GPIO.Pin;
  disp   : Click_7Seg.Display;
  n      : Cardinal;

BEGIN
  Writeln;
  Writeln('Mikroelektronika 7Seg Click Test for PocketBeagle');
  Writeln;

  spidev := SPI_libsimpleio.DeviceSubclass.Create(SPI2_1,
    SPI_Shift_Register_74HC595.SPI_Clock_Mode, 8,
    SPI_Shift_Register_74HC595.SPI_Clock_Max);
  pwmout := PWM_libsimpleio.OutputSubclass.Create(PWM0_0, 1000);
  rstpin := GPIO_libsimpleio.PinSubclass.Create(GPIO45, GPIO.Output, True);
  disp   := Click_7Seg.Display.Create(spidev, pwmout, rstpin);

  FOR n := 0 TO 99 DO
    BEGIN
      disp.Write(n, True, True, False, 100.0);
      sleep(200);
    END;

  sleep(1000);

  FOR n := 99 DOWNTO 0 DO
    BEGIN
      disp.Write(n, False, False, True, 75.0);
      sleep(200);
    END;

  sleep(1000);

  FOR n := 0 TO 255 DO
    BEGIN
      disp.WriteHex(n, True, True, False, 50.0);
      sleep(200);
    END;

  sleep(1000);

  FOR n := 255 DOWNTO 0 DO
    BEGIN
      disp.WriteHex(n, False, False, True, 25.0);
      sleep(200);
    END;

  sleep(1000);

  disp.WriteSegments($00, $00);
END.
