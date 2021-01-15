// GPIO pin toggle speed test using Remote Tea ONC/RPC

// Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

import java.io.*;

import com.munts.interfaces.GPIO.Pin;
import com.munts.interfaces.GPIO.Direction;

public class Toggle_Speed
{
  public static void main(String args[])
  {
    com.munts.muntsos.examples.GPIO.ONCRPC.Server s;
    int iterations;
    int i;
    long start_time;
    long stop_time;
    double deltat;
    double rate;
    double cycletime;

    System.out.println("\nMuntsOS GPIO Thin Server Toggle Speed Test\n");

    if (args.length != 3)
    {
      System.out.println("Usage: java -jar ToggleSpeed.jar <servername> " +
        "<pin number> <iterations>\n");
      System.exit(1);
    }

    // Connect to the server

    s = new com.munts.muntsos.examples.GPIO.ONCRPC.Server(args[0]);

    // Create a GPIO pin object

    Pin p = new com.munts.muntsos.examples.GPIO.ONCRPC.Pin(s,
     Integer.parseInt(args[1]), Direction.Output);

    iterations = Integer.parseInt(args[2]);

    System.out.println("Performing " + Integer.toString(iterations) +
      " GPIO writes...\n");

    // Perform GPIO toggle speed test

    start_time = System.currentTimeMillis();

    for (i = 0; i < iterations/2; i++)
    {
      p.write(true);
      p.write(false);
    }

    stop_time = System.currentTimeMillis();

    // Display results

    deltat = (stop_time - start_time)/1000.0;
    rate = iterations/deltat;
    cycletime = deltat/iterations;

    System.out.println("Performed " + Integer.toString(iterations) +
      " in " + String.format("%1.1f", deltat) + " seconds");

    System.out.println("  " + String.format("%1.1f", rate) +
      " iterations per second");

    System.out.println("  " + String.format("%1.1f", cycletime*1E6) +
      " microseconds per iteration\n");
  }
}
