// Analog Input Test using libsimpleio

// Copyright (C)2017-2026, Philip Munts, President, Munts AM Corp.
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

// Test Configuration:
//
// Raspberry Pi microcomputer with Mikroelektronica Pi 3 Click Shield
// MIKROE-2756 (https://www.mikroe.com/pi-3-click-shield).
//
// Add dtoverlay=Pi3ClickShield to /boot/config.txt.

import com.munts.interfaces.ADC.*;
import com.munts.libsimpleio.objects.ADC.*;

public class test_adc
{
  public static final int MAX_CHANNELS = 2;
  public static final int RESOLUTION   = 12;
  public static final double VREF      = 4.096;
  public static final double GAIN      = 1.0;

  public static void main(String args[]) throws InterruptedException
  {
    System.out.println("\nAnalog Input Test using libsimpleio\n");

    Voltage[] inputs = new Voltage[MAX_CHANNELS];

    for (int c = 0; c < inputs.length; c++)
      inputs[c] = new Input(new SampleSubclass(0, c, RESOLUTION), VREF, GAIN);

    for (;;)
    {
      for (Voltage ain : inputs)
        System.out.print(String.format("%6.3f", ain.voltage()));

      System.out.println();
      Thread.sleep(2000);
    }
  }
}
