// Copyright (C)2025, Philip Munts dba Munts Technologies.
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

using System.Device.Gpio;

using static System.Console;
using static System.Threading.Thread;

#if BeaglePlay
var LED_Desg = IO.Objects.SimpleIO.Platforms.BeaglePlay.INT;
#elif OrangePiZero2W
var LED_Desg = IO.Objects.SimpleIO.Platforms.OrangePiZero2W_RaspberryPi.GPIO26;
#else
var LED_Desg = IO.Objects.SimpleIO.Platforms.RaspberryPi.GPIO26;
#endif

WriteLine("\n.Net IoT GPIO Test\n");

var LED = new IO.Objects.IoT.GPIO.Pin(LED_Desg, PinMode.Output, false);

for (;;)
{
  LED.state = !LED.state;
  Sleep(500);
}
