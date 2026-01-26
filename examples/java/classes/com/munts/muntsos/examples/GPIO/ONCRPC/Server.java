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

import java.io.IOException;
import java.net.InetAddress;
import org.acplt.oncrpc.*;

public class Server
{
  private gpio_server_oncrpcClient handle;

  // GPIO server object constructor

  public Server(String servername)
  {
    // Connect to the server

    try
    {
      handle = new gpio_server_oncrpcClient(InetAddress.getByName(servername),
        OncRpcProtocols.ONCRPC_UDP);
    }
    catch (OncRpcProgramNotRegisteredException e)
    {
      System.out.println("ERROR: ONC/RPC Program not found at server " +
        servername);
      System.exit(1);
    }
    catch (OncRpcException e)
    {
      System.out.println("ERROR: ONC/RPC error: " + e.toString());
      System.exit(1);
    }
    catch (IOException e)
    {
      System.out.println("ERROR: I/O error: " + e.toString());
      System.exit(1);
    }
  }

  gpio_server_oncrpcClient GetHandle()
  {
    return this.handle;
  }
}
