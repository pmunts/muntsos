// Wio-E5 LoRa to RabbitMQ Gateway

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

using RabbitMQ.Client;
using System.Text;
using static System.Environment;

// Create watchdog timer object

var wd = new IO.Objects.SimpleIO.Watchdog.Timer("/dev/watchdog");

// Change the watchdog timer period to 5 seconds

wd.timeout = 5;

// Configure RabbitMQ.Client

var factory         = new RabbitMQ.Client.ConnectionFactory();
factory.HostName    = GetEnvironmentVariable("RABBITMQ_SERVER");
factory.UserName    = GetEnvironmentVariable("RABBITMQ_USER");
factory.Password    = GetEnvironmentVariable("RABBITMQ_PASS");
factory.VirtualHost = GetEnvironmentVariable("RABBITMQ_VHOST");
var routingkey      = GetEnvironmentVariable("RABBITMQ_QUEUE");

IConnection connection;
IChannel channel;

// Connect to the RabbitMQ server.  Keep trying once a second until the
// connection succeeds, because it will fail before the network interface
// has been configured.

for (;;)
{
  try
  {
    connection = await factory.CreateConnectionAsync();
    channel    = await connection.CreateChannelAsync();
    break;
  }

  catch
  {
    wd.Kick();
    System.Threading.Thread.Sleep(1000);
  }
}

// Configure Wio-E5 LoRa transceiver module

var dev = new IO.Devices.WioE5.Ham1.Device();
var msg = new byte[255];

// Message loop

for (;;)
{
  dev.Receive(msg, out int len, out string srcnet, out int srcnode,
    out string dstnet, out int dstnode, out int RSS, out int SNR);

  if (len > 0)
  {
    var outbuf = $"{System.DateTime.Now}\t"          +
      $"{srcnet}-{srcnode}\t{dstnet}-{dstnode}\t"  +
      $"{len} bytes RSS:{RSS} dBm SNR: {SNR} dB\t" +
      $"{Encoding.UTF8.GetString(msg, 0, len)}";

    await channel.BasicPublishAsync(exchange: string.Empty,
      routingKey: routingkey, body: Encoding.UTF8.GetBytes(outbuf));
  }

  wd.Kick();
}
