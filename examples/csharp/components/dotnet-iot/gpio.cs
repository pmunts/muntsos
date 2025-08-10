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

using System.Device.Gpio;

namespace IO.Objects.IoT.GPIO
{
    /// <summary>
    /// Encapsulates Linux GPIO pins using <c>System.Device.Gpio</c>.
    /// </summary>
    public class Pin : IO.Interfaces.GPIO.Pin
    {
        private readonly GpioController mydev;
        private readonly int mynum;
        private readonly PinMode mymode;
        private bool mystate = false;

        /// <summary>
        /// Constructor for a single GPIO pin.
        /// </summary>
        /// <param name="dev">GPIO controller device instance.</param>
        /// <param name="num">Logical GPIO pin number.</param>
        /// <param name="mode">Pin mode.</param>
        /// <param name="state">Initial GPIO output state.</param>
        public Pin(GpioController dev, int num, PinMode mode, bool state = false)
        {
            this.mydev = dev;
            this.mynum = num;
            this.mymode = mode;

            this.mydev.OpenPin(this.mynum, this.mymode);

            if (mode == PinMode.Output) this.state = state;
        }

        /// <summary>
        /// Constructor for a single GPIO pin.
        /// </summary>
        /// <param name="dev">GPIO controller device instance.</param>
        /// <param name="desg">GPIO pin designator.</param>
        /// <param name="mode">Pin mode.</param>
        /// <param name="state">Initial GPIO output state.</param>
        public Pin(GpioController dev, IO.Objects.SimpleIO.Device.Designator desg,
          PinMode mode, bool state = false)
        {
            this.mydev = dev;
            this.mynum = (int) desg.chan;
            this.mymode = mode;

            this.mydev.OpenPin(this.mynum, this.mymode);

            if (mode == PinMode.Output) this.state = state;
        }

        /// <summary>
        /// Read/Write GPIO state property.
        /// </summary>
        public bool state
        {
            get
            {
                if (this.mymode == PinMode.Output)
                    return this.mystate;
                else
                    return this.mydev.Read(this.mynum) == PinValue.High ? true : false;
            }

            set
            {
                if (this.mymode == PinMode.Output)
                {
                    this.mydev.Write(this.mynum, value ? PinValue.High : PinValue.Low);
                    this.mystate = value;
                }
                else
                    throw new System.Exception("Cannot write to input pin");
            }
        }
    }
}
