// Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

using Microsoft.SmallBasic.Library;
using System;
using System.Net;
using org.acplt.oncrpc;

namespace GPIO
{
    /// <summary>
    /// The GPIO object allows you to send commands to a MuntsOS GPIO Thin Server.
    /// </summary>
    [SmallBasicType]
    public static class GPIO
    {
        private static gpio_server_oncrpcClient server = null;

        /// <summary>
        /// Open a connection to the specified GPIO server.
        /// </summary>
        /// <param name="servername">Server domain name or IP address.</param>
        public static void Connect(Primitive servername)
        {
            IPAddress serveraddress;

            // Check for invalid parameter

            if (Uri.CheckHostName((string)servername) == UriHostNameType.Unknown)
            {
                throw new GPIOException("GPIO server name is invalid");
            }

            // Resolve the server IP address

            try
            {
                serveraddress = Dns.GetHostAddresses((string)servername)[0];
            }
            catch
            {
                throw new GPIOException("GPIO server name cannot be resolved");
            }

            try
            {
                // Create RPC client object

                server = new gpio_server_oncrpcClient(serveraddress, OncRpcProtocols.ONCRPC_UDP);

                // Reduce timeout to 2 seconds

                OncRpcUdpClient c = (OncRpcUdpClient)server.GetClient();

                c.setTimeout(2000);
                c.setRetransmissionTimeout(500);
            }
            catch
            {
                throw new GPIOException("GPIO server handle failed");
            }
        }

        /// <summary>
        /// Convert a Small Basic Primitive value to GPIO data direction
        /// </summary>
        /// <param name="p">Data direction: "input", "output", 0, or 1.</param>
        /// <returns></returns>
        private static int ToDirection(Primitive p)
        {
            string s = (string)p;

            if (String.Equals(s, "input", StringComparison.OrdinalIgnoreCase) ||
                String.Equals(s, "0"))
                return GPIO_DIRECTION.GPIO_DIRECTION_INPUT;

            if (String.Equals(s, "output", StringComparison.OrdinalIgnoreCase) ||
                String.Equals(s, "1"))
                return GPIO_DIRECTION.GPIO_DIRECTION_OUTPUT;

            throw new GPIOException("Invalid value for GPIO data direction");
        }

        /// <summary>
        /// Convert a Small Basic Primitive value to GPIO logic level
        /// </summary>
        /// <param name="p">Logic level: "true", "false", "high", "low", "on", off", 1, or 0.</param>
        /// <returns></returns>
        private static int ToLogicLevel(Primitive p)
        {
            string s = (string)p;

            if (String.Equals(s, "true", StringComparison.OrdinalIgnoreCase) ||
                String.Equals(s, "high", StringComparison.OrdinalIgnoreCase) ||
                String.Equals(s, "on", StringComparison.OrdinalIgnoreCase) ||
                String.Equals(s, "1"))
                return 1;

            if (String.Equals(s, "false", StringComparison.OrdinalIgnoreCase) ||
                String.Equals(s, "low", StringComparison.OrdinalIgnoreCase) ||
                String.Equals(s, "off", StringComparison.OrdinalIgnoreCase) ||
                String.Equals(s, "0"))
                return 0;

            throw new GPIOException("Invalid value for GPIO logic level");
        }

        /// <summary>
        /// Configure a GPIO pin
        /// </summary>
        /// <param name="pin">Pin number.</param>
        /// <param name="direction">Data direction: "input" or "output".  The values 0 and 1 are also allowed.</param>
        /// <param name="state">Initial output logic level: "true" or "false".  The values "high", "low", "on", "off", 1 and 0 are also allowed.  Ignored for input pins.</param>
        public static void Configure(Primitive pin, Primitive direction, Primitive state)
        {
            int p = (int)pin;
            int d = ToDirection(direction);
            int s = ToLogicLevel(state);
            int status;

            try
            {
                status = server.gpio_open_1(p, d, s);
            }
            catch
            {
                throw new GPIOException("RPC gpio_open_1() failed");
            }

            if (status < 0)
            {
                throw new GPIOException("RPC gpio_open_1() returned error " + status.ToString() + " " + p.ToString() + " " + d.ToString() + " " + s.ToString());
            }
        }

        /// <summary>
        /// Read a GPIO pin
        /// </summary>
        /// <param name="pin">Pin number.</param>
        /// <returns>Logic level: "true" or "false".</returns>
        public static Primitive Read(Primitive pin)
        {
            int p = (int)pin;
            int status;

            try
            {
                status = server.gpio_read_1(p);
            }
            catch
            {
                throw new GPIOException("RPC gpio_read_1() failed");
            }

            if (status < 0)
            {
                throw new GPIOException("RPC gpio_read_1() returned error " + status.ToString());
            }

            if (status > 1)
            {
                throw new GPIOException("RPC gpio_read_1() returned invalid value " + status.ToString());
            }

            return (Primitive)(status == 0 ? "false" : "true");
        }

        /// <summary>
        /// Write to GPIO pin
        /// </summary>
        /// <param name="pin">Pin number.</param>
        /// <param name="state">Output state: "true" or "false".  The values "high", "low", "on", "off", 1 and 0 are also allowed.</param>
        public static void Write(Primitive pin, Primitive state)
        {
            int p = (int)pin;
            int s = ToLogicLevel(state);
            int status;

            try
            {
                status = server.gpio_write_1(p, s);
            }
            catch
            {
                throw new GPIOException("RPC gpio_write_1() failed");
            }

            if (status < 0)
            {
                throw new GPIOException("RPC gpio_write_1() returned error " + status.ToString());
            }
        }
    }
}
