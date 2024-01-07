// MuntsOS GPIO Thin Server Toggle Speed Test

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
using System.Diagnostics;
using System.Threading;
using GPIO;


namespace Toggle_Speed
{
    class Program
    {
        static void Main(string[] args)
        {
            const int ITERATIONS = 50000;
            Stopwatch timer = new Stopwatch();

            Console.WriteLine("\nMuntsOS GPIO Thin Server Toggle Speed Test\n");

            if (args.Length != 1)
            {
                Console.WriteLine("Usage: Toggle_Speed <servername>");
                Environment.Exit(1);
            }

            // Open connection to the GPIO server

            Server s = new Server(args[0]);

            // Configure GPIO pins

            Pin GPIO26 = s.OpenPin(26, Direction.Output);

            //  Conduct speed test

            Console.WriteLine("Performing " + ITERATIONS.ToString() + " GPIO writes...\n");

            timer.Start();

            for (int i = 0; i < ITERATIONS/2; i++)
            {
                GPIO26.state = true;
                GPIO26.state = false;
            }

            timer.Stop();

            // Display statistics

            double duration = timer.ElapsedMilliseconds / 1000.0;
            double rate = ITERATIONS / duration;
            double cycletime = duration / ITERATIONS * 1.0E6;

            Console.WriteLine("Performed " + ITERATIONS.ToString() + " loopback tests in " + duration.ToString("F2") + " seconds");
            Console.WriteLine("  " + rate.ToString("F2") + " iterations per second");
            Console.WriteLine("  " + cycletime.ToString("F2") + " microseconds per iteration");
        }
    }
}
