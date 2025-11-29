// PocketBeagle Analog Input Test

// Copyright (C)2018-2024, Philip Munts dba Munts Technologies.
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

namespace test_beaglebone_adc
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\nPocketBeagle Analog Input Test\n");

            // Create analog input objects

            IO.Interfaces.ADC.Input[] inputs = new IO.Interfaces.ADC.Input[8]
            {
                new IO.Interfaces.ADC.Input(new IO.Objects.SimpleIO.ADC.Sample(IO.Objects.SimpleIO.Platforms.PocketBeagle.AIN0, 12), 1.8),
                new IO.Interfaces.ADC.Input(new IO.Objects.SimpleIO.ADC.Sample(IO.Objects.SimpleIO.Platforms.PocketBeagle.AIN1, 12), 1.8),
                new IO.Interfaces.ADC.Input(new IO.Objects.SimpleIO.ADC.Sample(IO.Objects.SimpleIO.Platforms.PocketBeagle.AIN2, 12), 1.8),
                new IO.Interfaces.ADC.Input(new IO.Objects.SimpleIO.ADC.Sample(IO.Objects.SimpleIO.Platforms.PocketBeagle.AIN3, 12), 1.8),
                new IO.Interfaces.ADC.Input(new IO.Objects.SimpleIO.ADC.Sample(IO.Objects.SimpleIO.Platforms.PocketBeagle.AIN4, 12), 1.8),
                new IO.Interfaces.ADC.Input(new IO.Objects.SimpleIO.ADC.Sample(IO.Objects.SimpleIO.Platforms.PocketBeagle.AIN5, 12), 1.8, 0.5),
                new IO.Interfaces.ADC.Input(new IO.Objects.SimpleIO.ADC.Sample(IO.Objects.SimpleIO.Platforms.PocketBeagle.AIN6, 12), 1.8, 0.5),
                new IO.Interfaces.ADC.Input(new IO.Objects.SimpleIO.ADC.Sample(IO.Objects.SimpleIO.Platforms.PocketBeagle.AIN7, 12), 1.8),
            };

            Console.WriteLine("Press CONTROL-C to quit\n");

            // Display analog input voltages

            for (;;)
            {
                foreach (IO.Interfaces.ADC.Input i in inputs)
                    Console.Write("{0,6:F3}", i.voltage);

                Console.WriteLine();

                System.Threading.Thread.Sleep(2000);
            }
        }
    }
}
