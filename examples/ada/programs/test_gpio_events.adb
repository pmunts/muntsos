-- Raspberry Pi GPIO interrupt input test program

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Device;
WITH errno;
WITH libEvent;
WITH GPIO.libsimpleio;
WITH RaspberryPi; USE RaspberryPi;

PROCEDURE test_gpio_events IS


  epfd      : Integer;
  error     : Integer;
  GPIO_Pins : CONSTANT ARRAY (Integer RANGE <>) OF Device.Designator :=
   (GPIO4, GPIO18, GPIO13, GPIO17);
  GPIO_Objs : ARRAY (GPIO_Pins'Range) OF GPIO.libsimpleio.PinSubclass;
  fd        : Integer;
  event     : Integer;
  handle    : Integer;

BEGIN
  Put("Raspberry Pi GPIO Interrupt Input Test");
  New_Line;

  -- Initialize the event handling package

  libEvent.Open(epfd, error);

  IF error /= 0 THEN
    Put_Line("ERROR: Event.Open() failed, " & errno.strerror(error));
    RETURN;
  END IF;

  -- Configure some GPIO inputs

  FOR i IN GPIO_Pins'Range LOOP

    -- Configure a GPIO input for edge detection

    GPIO.libsimpleio.Initialize(GPIO_Objs(i), GPIO_Pins(i), GPIO.Input,
      false, GPIO.libsimpleio.PushPull, GPIO.libsimpleio.Both,
      GPIO.libsimpleio.ActiveHigh);

    -- Register the GPIO input for EPOLLIN events

    libEvent.Register(epfd, GPIO_Objs(i).fd, libEvent.EPOLLIN, i, error);

    IF error /= 0 THEN
      Put_Line("ERROR: Event.Register() failed, " & errno.strerror(error));
      RETURN;
    END IF;
  END LOOP;

  -- Detect transitions

  LOOP
    libEvent.Wait(epfd, fd, event, handle, 1000, error);

    IF error = 0 THEN
      Put_Line("GPIO" & Natural'Image(GPIO_Pins(handle).chan) & " is now " &
        Boolean'Image(GPIO_Objs(handle).Get));
    ELSIF error = errno.EAGAIN THEN
      Put_Line("Timeout");
    ELSE
      Put_Line("ERROR: Event.Wait() failed, " & errno.strerror(error));
    END IF;
  END LOOP;
END test_gpio_events;
