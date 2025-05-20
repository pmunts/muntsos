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

// MySQL script to create table LoRaMessages:
//
// drop table if exists LoRaMessages;
//
// create table LoRaMessages
// (
//   time     datetime,
//   sender   varchar(20),
//   receiver varchar(20),
//   RSS      int,
//   SNR      int,
//   message  varchar(256)
// );

using MySql.Data.MySqlClient;
using static System.Environment;

// Configure the Wio-E5 LoRa transceiver module

var dev = new IO.Devices.WioE5.Ham1.Device();

// Create a MySQL connection object

var connstr =
  "Server="   + GetEnvironmentVariable("MYSQL_SERVER") + ";" +
  "Port="     + GetEnvironmentVariable("MYSQL_PORT")   + ";" +
  "Database=" + GetEnvironmentVariable("MYSQL_DB")     + ";" +
  "uid="      + GetEnvironmentVariable("MYSQL_USER")   + ";" +
  "pwd="      + GetEnvironmentVariable("MYSQL_PASS");

var db = new MySqlConnection(connstr);

// Connect to the database server.  Keep trying once a second until the
// connection succeeds, because it will fail before the network interface
// has been configured.

for (;;)
{
  try
  {
    db.Open();
    break;
  }

  catch
  {
    System.Threading.Thread.Sleep(1000);
  }
}

// Create a MySQL command object

var cmd = db.CreateCommand();
cmd.Connection = db;

// Start the watchdog timer

var wd = new IO.Objects.SimpleIO.Watchdog.Timer("/dev/watchdog");
wd.timeout = 5;

// Message loop

var msg = new byte[255];

for (;;)
{
  dev.Receive(msg, out int len, out string srcnet, out int srcnode,
    out string dstnet, out int dstnode, out int RSS, out int SNR);

  if (len > 0)
  {
    // Build the MySQL command

    var cmdstr = $"INSERT LoRaMessages VALUES (" +
      $"'{System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")}', " +
      $"'{srcnet}-{srcnode}', '{dstnet}-{dstnode}', {RSS}, {SNR}, " +
      $"'{System.Text.Encoding.UTF8.GetString(msg, 0, len)}');";

    // Dispatch the MySQL command

    cmd.CommandText = cmdstr;
    cmd.ExecuteNonQuery();
  }

  wd.Kick();
}
