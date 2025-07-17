WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Debug;
WITH libLinux;
WITH Watchdog.libsimpleio;

PROCEDURE extension_program_template IS

  err : Integer;
  wd  : Watchdog.Timer;

  -- Add your application specific data declarations here

BEGIN
  Put_Line("Starting Ada Extension Program");

  IF NOT Debug.Enabled THEN
    -- Run as background process
    libLinux.Detach(err);

    -- Create a watchdog timer device object
    wd := Watchdog.libsimpleio.Create;
    wd.SetTimeout(5.0);
  END IF;

  -- Add your application specific initialization code here

  LOOP
    -- Add your application specific event handling code here

    IF NOT Debug.Enabled THEN
      -- Reset the watchdog timer
      wd.Kick;
    END IF;
  END LOOP;
END extension_program_template;
