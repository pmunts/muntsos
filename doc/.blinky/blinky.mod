MODULE blinky;

IMPORT GPIO_libsimpleio, RaspberryPi;

FROM STextIO       IMPORT WriteString, WriteLn;
FROM FIO           IMPORT FlushOutErr;
FROM ErrorHandling IMPORT CheckError;
FROM liblinux      IMPORT Sleep;

VAR
  LED      : GPIO_libsimpleio.Pin;
  error    : CARDINAL;
  state    : BOOLEAN;

BEGIN
  WriteLn;
  WriteString("MuntsOS Modula-2 LED Test");
  WriteLn;
  WriteLn;
  FlushOutErr;

  (* Configure LED GPIO output *)

  GPIO_libsimpleio.Open(RaspberryPi.GPIO26, GPIO_libsimpleio.Output, FALSE,
    GPIO_libsimpleio.PushPull, GPIO_libsimpleio.None,
    GPIO_libsimpleio.ActiveHigh, LED, error);
  CheckError(error, "GPIO_libsimpleio.Open() failed");

  WriteString("Press CONTROL-C to exit");
  WriteLn;
  WriteLn;
  FlushOutErr;

  LOOP
    GPIO_libsimpleio.Read(LED, state, error);
    CheckError(error, "GPIO_libsimpleio.Read() failed");

    GPIO_libsimpleio.Write(LED, NOT state, error);
    CheckError(error, "GPIO_libsimpleio.Write() failed");

    Sleep(500000, error);
    CheckError(error, "LINUX_usleep() failed");
  END;
END blinky.
