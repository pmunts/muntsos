// C# Mono GTK# .NET RPC Client for the Dream Cheeky USB Missile Launcher

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

using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using Gtk;
using Pango;
using org.acplt.oncrpc;

public partial class MainWindow: Gtk.Window
{
    private const String RegistryKey = "HKEY_CURRENT_USER\\Software\\MuntsTechnologies\\MissileClient";
    private Dictionary<Button, int> CommandButtons = new Dictionary<Button, int>(5);
    private missileClient clnt = null;

    public MainWindow(): base(Gtk.WindowType.Toplevel)
    {
        Build();

        // Build dictionary mapping a command to each button
        CommandButtons.Add(ButtonUp, missile.CMD_UP);
        CommandButtons.Add(ButtonDown, missile.CMD_DOWN);
        CommandButtons.Add(ButtonCW, missile.CMD_CW);
        CommandButtons.Add(ButtonCCW, missile.CMD_CCW);
        CommandButtons.Add(ButtonFire, missile.CMD_FIRE);

        // Get last server name from the registry (if available)
        ServerName.Text = (String)Registry.GetValue(RegistryKey, ServerName.Name, null);
        ServerName.IsFocus = true;
        ServerName.Position = -1;

        if (File.Exists("C:/ProgramData/MuntsTechnologies/tablet.txt"))
        {
            // Maximize the main window
            this.Maximize();

            // Make everything larger
            FontDescription TabletFont = FontDescription.FromString("18");
            uint TabletSpacing = 30;

            label1.ModifyFont(TabletFont);
            ServerName.ModifyFont(TabletFont);

            table1.RowSpacing = TabletSpacing;
            table1.ColumnSpacing = TabletSpacing;
            alignment2.LeftPadding = TabletSpacing;
            alignment2.RightPadding = TabletSpacing;
            alignment2.BottomPadding = TabletSpacing;

            foreach (var b in CommandButtons.Keys)
            {
                b.Child.ModifyFont(TabletFont);
                b.WidthRequest = 2 * b.WidthRequest;
                b.HeightRequest = 2 * b.HeightRequest;
            }
        }
    }

    protected void OnDeleteEvent(object sender, DeleteEventArgs a)
    {
        Application.Quit();
        a.RetVal = true;
    }

    protected void OnServerNameEntryActivated(object sender, EventArgs e)
    {
        IPAddress hostaddr;

        // Resolve the server IP address
        try
        {
            hostaddr = Dns.GetHostAddresses(ServerName.Text)[0];
        }
        catch
        {
            MessageBox.Show("ERROR: Cannot resolve " + ServerName.Text);
            clnt = null;
            return;
        }

        // Open connection to the server
        try
        {
            clnt = new missileClient(hostaddr, OncRpcProtocols.ONCRPC_UDP);
        }
        catch
        {
            MessageBox.Show("ERROR: Connection to " + ServerName.Text + " failed");
            clnt = null;
            return;
        }

        // Send NOP command to the server, to test the connection
        try
        {
            int status = clnt.missile_command_1(missile.CMD_NOP);

            if (status != 0)
            {
                clnt = null;
                MessageBox.Show("ERROR: RPC call returned error " + status.ToString());
                return;
            }
        }
        catch
        {
            clnt = null;
            MessageBox.Show("ERROR: RPC call to " + ServerName.Text + " failed");
            return;
        }

        // Disable further changes to the server name field
        ServerName.IsEditable = false;

        // Enable buttons now that the connection to the server is working
        foreach (var b in CommandButtons.Keys)
        {
            b.Sensitive = true;
        }

        // Save the server name in the registry
        Registry.SetValue(RegistryKey, ServerName.Name, ServerName.Text);
    }

    // Issue a command upon button press
    protected void OnButtonPress(object sender, EventArgs e)
    {
        try
        {
            clnt.missile_command_1(CommandButtons[(Button)sender]);
        }
        catch
        {
            MessageBox.Show("ERROR: RPC call to " + ServerName.Text + " failed");
        }
    }

    // Issue a STOP command upon button release
    protected void OnButtonRelease(object sender, EventArgs e)
    {
        try
        {
            clnt.missile_command_1(missile.CMD_STOP);
        }
        catch
        {
            MessageBox.Show("ERROR: RPC call to " + ServerName.Text + " failed");
        }
    }
}
