WITH Ada.Text_IO; USE Ada.Text_IO;

WITH NNG.Sub;

PROCEDURE Get_Messages IS

  client : NNG.Sub.Client;

BEGIN
  New_Line;
  Put_Line("Get messages from wioe5_ham1_nng_publisher");
  New_Line;

  client.Initialize("ipc:///tmp/wioe5.sock");

  LOOP
    Put_Line(client.Get);
  END LOOP;
END Get_Messages;
