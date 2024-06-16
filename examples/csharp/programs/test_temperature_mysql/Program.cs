// Log temperature samples to MySQL database

// Copyright (C)2024, Philip Munts dba Munts Technologies.
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


using DotNetConfig;
using MySql.Data.MySqlClient;
using System;

using static IO.Objects.SimpleIO.Platforms.MUNTS_0018.RaspberryPi;
using static System.Console;

// Copy config file template to /usr/local/etc, if necessary

const string configtmpl = "/usr/local/lib/test_temperature_mysql/config.template";
const string configname = "/usr/local/etc/test_temperature_mysql.config";

if (!System.IO.File.Exists(configname))
{
  [System.Runtime.InteropServices.DllImport("libc", SetLastError = true)]
  static extern int system(string pathname);

  system(String.Format("cp {0} {1}", configtmpl, configname));
  system(String.Format("chmod 0400 {0}", configname));
}

// Get configuration settings

var settings = Config.Build(configname);

var conn_string = String.Format("server={0};port={1};uid={2};pwd={3};database={4}",
  settings.GetString("server", "hostname"),
  settings.GetNumber("server", "port"),
  settings.GetString("server", "username"),
  settings.GetString("server", "password"),
  settings.GetString("server", "database"));

var sensor_name = settings.GetString("sensor", "name");

const string insert_template = "INSERT Temperature VALUES ('{0}', {1}, '{2}')";

// Create a Grove Temperature Sensor object

var V = AnalogInputFactory(J10A0);
var T = new IO.Devices.Grove.Temperature.Device(V);

// Periodically log temperature samples to MySQL database

for (;;)
{
  // Connect to the MySQL server

  var server = new MySqlConnection(conn_string);
  server.Open();

  // Log a temperature sample

  var cmd = new MySqlCommand(String.Format(insert_template, sensor_name,
    T.Celsius, DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss")), server);
  cmd.ExecuteNonQuery();

  // Disconnect from the MySQL server

  server.Close();

  System.Threading.Thread.Sleep(60000);
}
