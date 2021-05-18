{ Pimoroni Automation PHAT A/D Test                                           }

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

PROGRAM test_automation_phat_adc(input, output);

USES
  ADS1015,
  I2C,
  I2C_libsimpleio,
  Pimoroni_PHAT_Automation,
  SysUtils,
  Voltage;

VAR
  bus    : I2C.Bus;
  dev    : ADS1015.Device;
  Input0 : Voltage.Input;
  Input1 : Voltage.Input;
  Input2 : Voltage.Input;

BEGIN
  Writeln;
  Writeln('Pimoroni Automation PHAT A/D Test');
  Writeln;
  Writeln('Press CONTROL-C to exit.');
  Writeln;

  bus := I2C_libsimpleio.BusSubclass.Create(I2CDEV);
  dev := ADS1015.Device.Create(bus, ADS1015_ADDR);

  Input0 := Voltage.InputClass.Create(ADS1015.InputSubclass.Create(dev, AIN0, FSR4096), 4.096, ADS1015_GAIN);
  Input1 := Voltage.InputClass.Create(ADS1015.InputSubclass.Create(dev, AIN1, FSR4096), 4.096, ADS1015_GAIN);
  Input2 := Voltage.InputClass.Create(ADS1015.InputSubclass.Create(dev, AIN2, FSR4096), 4.096, ADS1015_GAIN);

  REPEAT
    Writeln(Input0.Read : 1 : 2, ' ', Input1.Read : 1 : 2, ' ',
      Input2.Read : 1 : 2);

    sleep(1000);
  UNTIL False;
END.
