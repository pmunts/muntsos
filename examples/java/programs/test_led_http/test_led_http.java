// MuntsOS Remote LED Test via HTTP

// Copyright (C)2026, Philip Munts dba Munts Technologies.
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

// This program requires gpio_server_http running on the GPIO server.

import com.munts.interfaces.GPIO.Pin;
import com.munts.interfaces.GPIO.Direction;

class test_led_http
{
  public static void Delay(int milliseconds)
  {
    try
    {
      Thread.sleep(milliseconds);
    }
    catch (Exception e)
    {
    }
  }

  public static void main(String args[])
  {
    System.out.println("\nMuntsOS Remote LED Test via HTTP\n");

    if (args.length != 1)
    {
      System.out.println("Usage: java -jar test_led_http.jar <servername>\n");
      System.exit(1);
    }

    // Create a GPIO out pin object

    Pin LED = new com.munts.muntsos.examples.GPIO.HTTP.Pin(args[0], 26,
      Direction.Output);

    // Flash an LED connected to a GPIO output

    for (;;)
    {
      LED.write(true);
      Delay(500);
      LED.write(false);
      Delay(500);
    }
  }
}
