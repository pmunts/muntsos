// GPIO services using HTTP

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

package com.munts.muntsos.examples.GPIO.HTTP;

import com.munts.interfaces.GPIO.Direction;
import java.io.*;
import java.net.*;

public class Pin implements com.munts.interfaces.GPIO.Pin
{
  private String server;
  private Integer number;
  private String response0;
  private String response1;

  // Fetch a web page and return its contents as a string

  private static String GET(String request)
  {
    StringBuilder result = new StringBuilder();

    try
    {
      URL url = new URL(request);
      HttpURLConnection conn = (HttpURLConnection) url.openConnection();
      conn.setRequestMethod("GET");
      BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
      String line;
      while ((line = rd.readLine()) != null) result.append(line);
      rd.close();
    }
    catch (Exception e)
    {
      throw new RuntimeException("ERROR: HTTP GET failed");
    }

    return result.toString();
  }

  // GPIO pin object constructor

  public Pin(String servername, int pin, Direction dir)
  {
    server    = servername;
    number    = new Integer(pin);
    response0 = "GPIO" + number.toString() + "=0";
    response1 = "GPIO" + number.toString() + "=1";

    // Dispatch GPIO configure command

    String request = "http://" + server + ":8083/GPIO/DDR/" + number.toString() +
      "," + (dir == Direction.Input ? 0 : 1);

    // Get GPIO configure response

    String response = GET(request);

    // Check for valid response

    if ((dir == Direction.Input) &&
        (!response.equals("DDR" + number.toString() + "=0")))
      throw new RuntimeException("ERROR: Invalid response: " + response);

    if ((dir == Direction.Output) &&
        (!response.equals("DDR" + number.toString() + "=1")))
      throw new RuntimeException("ERROR: Invalid response: " + response);
  }

  // Write to GPIO pin

  public void write(boolean state)
  {
    // Dispatch GPIO write command

    String request = "http://" + this.server + ":8083/GPIO/PUT/" + number.toString() +
      "," + (state ? "1" : "0");

    // Get GPIO write response

    String response = GET(request);

    // Check for valid response

    if (!response.equals(state ? this.response1 : this.response0))
      throw new RuntimeException("ERROR: Invalid response: " + response);
  }

  // Read from GPIO pin

  public boolean read()
  {
    // Dispatch GPIO read command

    String request = "http://" + this.server + ":8083/GPIO/GET/" + number.toString();

    // Get GPIO read response

    String response = GET(request);

    // Check for valid response

    if (response.equals(this.response0))
      return false;
    else if (response.equals(this.response1))
      return true;
    else
      throw new RuntimeException("Invalid response: " + response);
  }
}
