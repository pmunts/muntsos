-- Ada email test client using /usr/bin/mail

-- Copyright (C)2020-2024, Philip Munts dba Munts Technologies.
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

WITH Ada.Command_Line;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Email_Mail;

PROCEDURE test_email IS

  relay : Email_Mail.RelaySubclass;

BEGIN

  -- Check command line parameters

  IF Ada.Command_Line.Argument_Count /= 4 THEN
    New_Line;
    Put_Line("Email Send Test");
    New_Line;
    Put_Line("Usage: test_email <recipient> <subject> <message> <attachment>");
    New_Line;
    RETURN;
  END IF;

  -- Create a mail relay object

  relay.Initialize;

  -- Send the email message

  relay.Send
   (sender     => "",
    recipient  => Ada.Command_Line.Argument(1),
    subject    => Ada.Command_Line.Argument(2),
    message    => Ada.Command_Line.Argument(3),
    attachment => Ada.Command_Line.Argument(4));
END test_email;
