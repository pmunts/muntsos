// Linux Simple I/O Library HID button and LED test

// Copyright (C)2020-2024, Philip Munts dba Munts Technologies.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

using System;

namespace test_hid_button_led
{
  class Program
  {
    static void Main(string[] args)
    {
      Console.WriteLine("\nHID Button and LED Test\n");

      // Open the raw HID device

      IO.Interfaces.Message64.Messenger dev =
        new IO.Objects.SimpleIO.HID.Messenger(IO.Devices.USB.Munts.HID.Vendor,
          IO.Devices.USB.Munts.HID.Product, 0);

      IO.Interfaces.Message64.Message ButtonState =
        new IO.Interfaces.Message64.Message(0);

      IO.Interfaces.Message64.Message LEDCommand =
        new IO.Interfaces.Message64.Message(0);

      // Process incoming keypress reports

      for (;;)
      {
        dev.Receive(ButtonState);

        switch (ButtonState.payload[0])
        {
          case 0 :
            Console.WriteLine("RELEASE");
            LEDCommand.payload[0] = 0;
            dev.Send(LEDCommand);
            break;

          case 1 :
            Console.WriteLine("PRESS");
            LEDCommand.payload[0] = 1;
            dev.Send(LEDCommand);
            break;

          default :
            Console.WriteLine("ERROR: Unexpected keypress status value");
            break;
        }
      }
    }
  }
}
