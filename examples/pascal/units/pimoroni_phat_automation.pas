{ Board level declarations for the Pimoroni Automation PHAT                   }
{ https://shop.pimoroni.com/products/automation-phat                          }

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

UNIT Pimoroni_PHAT_Automation;

INTERFACE

  USES
    libsimpleio;

  CONST

    { Device names }

    I2CDEV         = '/dev/i2c-1';

    { ADS1015 A/D converter constants }

    ADS1015_ADDR = $48;
    ADS1015_GAIN = 0.128;

    { GPIO pin assignments }

    GPIO_INPUT1  : libsimpleio.Designator = (chip : 0; chan : 26);
    GPIO_INPUT2  : libsimpleio.Designator = (chip : 0; chan : 20);
    GPIO_INPUT3  : libsimpleio.Designator = (chip : 0; chan : 21);

    GPIO_OUTPUT1 : libsimpleio.Designator = (chip : 0; chan : 5);
    GPIO_OUTPUT2 : libsimpleio.Designator = (chip : 0; chan : 12);
    GPIO_OUTPUT3 : libsimpleio.Designator = (chip : 0; chan : 6);

    GPIO_RELAY   : libsimpleio.Designator = (chip : 0; chan : 16);

IMPLEMENTATION
END.
