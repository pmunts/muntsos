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

using System;
using System.Net;
using org.acplt.oncrpc;

namespace GPIO
{
    /// <summary>
    /// This enumeration type encapsulates GPIO data direction configuration values.
    /// </summary>
    public enum Direction
    {
        /// <summary>
        /// Configure GPIO pin data direction as input.
        /// </summary>
        Input,
        /// <summary>
        /// Configure GPIO pin data direction as output.
        /// </summary>
        Output
    }

    /// <summary>
    /// This exception will be raised upon any error encountered while communicating with the ONC/RPC server.
    /// </summary>
    public class Exception : System.Exception
    {
        /// <summary>
        /// Default constructor without parameters.
        /// </summary>
        public Exception() : base()
        {
        }

        /// <summary>
        /// Constructor including an error message string
        /// </summary>
        /// <param name="message">Error message</param>
        public Exception(string message) : base(message)
        {
        }
    }

    /// <summary>
    /// This class encapsulates a connection to a single MuntsOS ONC/RPC GPIO server.
    /// </summary>
    public class Server
    {
        private gpio_server_oncrpcClient server = null;

        /// <summary>
        /// Open a connection to a ONC/RPC GPIO server.
        /// </summary>
        /// <param name="servername">Server domain name or IP address.</param>
        public Server(String servername)
        {
            IPAddress serveraddress;

            // Check for invalid parameter

            if (Uri.CheckHostName(servername) == UriHostNameType.Unknown)
            {
                throw new Exception("GPIO server name is invalid");
            }

            // Resolve the server IP address

            try
            {
                serveraddress = Dns.GetHostAddresses(servername)[0];
            }
            catch
            {
                throw new Exception("GPIO server name cannot be resolved");
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
                throw new Exception("GPIO server handle failed");
            }
        }

        /// <summary>
        /// This factory method configures the specified GPIO pin and returns a Pin object for it.
        /// </summary>
        /// <param name="number">GPIO pin number.</param>
        /// <param name="direction">GPIO pin direction, GPIO.Direction.Input or GPIO.Direction.Output.</param>
        /// <param name="state">GPIO output pin initial state, true or false.  Ignored for input pin.</param>
        /// <returns>Returns a configured GPIO Pin object.</returns>
        public Pin OpenPin(int number, Direction direction, bool state = false)
        {
            int status;

            try
            {
                status = server.gpio_open_1(number, (int) direction, state ? 1 : 0);
            }
            catch
            {
                throw new Exception("RPC gpio_open_1() failed");
            }

            if (status < 0)
            {
                throw new Exception("RPC gpio_open_1() returned error " + status.ToString());
            }
            try
            {
                return new Pin(this.server, number);
            }
            catch
            {
                throw new Exception("Failed to construct Pin object");
            }
        }
    }

    /// <summary>
    /// This class encapsulates a single GPIO pin.
    /// </summary>
    public class Pin
    {
        private gpio_server_oncrpcClient server = null;
        private int number;

        /// <summary>
        /// GPIO pin object constructor.
        /// </summary>
        /// <param name="server">ONC/RPC server handle.</param>
        /// <param name="number">GPIO pin number.</param>
        /// <remarks>
        /// Do not call this constructor directly; use the Server.OpenPin() factory method instead.
        /// </remarks>
        public Pin(gpio_server_oncrpcClient server, int number)
        {
            this.server = server;
            this.number = number;
        }

        /// <summary>
        /// Pin object destructor
        /// </summary>
        ~Pin()
        {
            try
            {
                server.gpio_close_1(this.number);
            }
            catch
            {
            }
        }

        /// <summary>
        /// This read/write property reflects the state of the GPIO pin.
        /// </summary>
        /// <value>
        /// Allowed values are true or false.
        /// </value>
        /// <remarks>
        /// Writing to a pin configured for input has no effect.
        /// </remarks>
        public bool state
        {
            get
            {
                int status;

                try
                {
                    status = server.gpio_read_1(this.number);
                }
                catch
                {
                    throw new Exception("RPC gpio_read_1() failed");
                }

                if (status < 0)
                {
                    throw new Exception("RPC gpio_read_1() returned error " + status.ToString());
                }

                if (status > 1)
                {
                    throw new Exception("Invalid state value");
                }

                return status == 1;
            }

            set
            {
                int status;

                try
                {
                    status = server.gpio_write_1(this.number, value ? 1 : 0);
                }
                catch
                {
                    throw new Exception("RPC gpio_write_1() failed");
                }

                if (status < 0)
                {
                    throw new Exception("RPC gpio_write_1() returned error " + status.ToString());
                }
            }
        }
    }
}
