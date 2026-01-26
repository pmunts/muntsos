// GPIO services using Remote Tea ONC/RPC

// Copyright (C)2017-2026, Philip Munts dba Munts Technologies.
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

package com.munts.muntsos.examples.GPIO.ONCRPC;

import com.munts.interfaces.GPIO.Direction;

public class Pin implements com.munts.interfaces.GPIO.Pin
{
  private gpio_server_oncrpcClient handle;
  private int number;

  // GPIO pin object constructor

  public Pin(Server server, int pin, Direction dir)
  {
    handle = server.GetHandle();
    number = pin;

    try
    {
      handle.gpio_open_1(number, dir.ordinal(), 0);
    }

    catch (Exception e)
    {
      throw new RuntimeException("ERROR: GPIO configure RPC failed, " +
        e.toString());
    }
  }

  // Write to GPIO pin

  public void write(boolean state)
  {
    try
    {
      this.handle.gpio_write_1(this.number, (state ? 1 : 0));
    }

    catch (Exception e)
    {
      throw new RuntimeException("ERROR: GPIO write RPC failed, " +
        e.toString());
    }
  }

  // Read from GPIO pin

  public boolean read()
  {
    int result = 0;

    try
    {
      result = this.handle.gpio_read_1(this.number);
    }

    catch (Exception e)
    {
      throw new RuntimeException("ERROR: GPIO read RPC failed, " +
        e.toString());
    }

    return (result == 1 ? true : false);
  }
}
