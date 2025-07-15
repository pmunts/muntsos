-- MuntsOS Embedded Linux Ada Program Extension Template

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Debug;
WITH libLinux;
WITH Watchdog.libsimpleio;

PROCEDURE extension_program_template IS

  err      : Integer;
  wd       : Watchdog.Timer;

  -- Declare your application specific variables here

BEGIN
  IF Debug.Enabled THEN
    New_Line;
    Put_Line("MuntsOS Embedded Linux Ada Program Extension Template");
    New_Line;
  ELSE
    Put("MuntsOS Embedded Linux Ada Program Extension Template");

    -- Run as background process

    libLinux.Detach(err);

    -- Create a watchdog timer device object

    wd := Watchdog.libsimpleio.Create;
    wd.SetTimeout(5.0);

    -- Any unhandled exception or signal after this point cause the target
    -- computer to reset.
  END IF;

  -- Add your application specific initialization code here

  LOOP

    -- Add your application specific event handling code here

    IF NOT Debug.Enabled THEN
      wd.Kick;
    END IF;
  END LOOP;
END extension_program_template;
