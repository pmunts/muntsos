// MuntsOS GPIO Thin Server Button and LED Test

// Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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
using System.Threading;
using GPIO;

namespace Button_And_LED
{
    class Program
    {
        static void Main(string[] args)
        {
            bool ButtonOld = false;
            bool ButtonNew = false;

            Console.WriteLine("\nMuntsOS GPIO Thin Server Button and LED Test\n");

            if (args.Length != 1)
            {
                Console.WriteLine("Usage: Button_And_LED <servername>");
                Environment.Exit(1);
            }

            // Open connection to the GPIO server
            Server s = new Server(args[0]);

            // Configure GPIO pins
            Pin GPIO19 = s.OpenPin(19, Direction.Input);
            Pin GPIO26 = s.OpenPin(26, Direction.Output);

            // Force initial state change
            ButtonOld = !GPIO19.state;

            // Main event loop
            for (;;)
            {
                // Sample button state
                ButtonNew = GPIO19.state;

                // If button state changed, print message and update LED
                if (ButtonNew != ButtonOld)
                {
                    Console.WriteLine(ButtonNew ? "PRESSED" : "RELEASED");
                    GPIO26.state = ButtonNew;
                    ButtonOld = ButtonNew;
                }

                Thread.Sleep(100);
            }
        }
    }
}
