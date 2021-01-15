// Emulate .Net MessageBox class.  From http://mono.1490590.n4.nabble.com/Message-Box-td1544773.html

using Gtk;

public class MessageBox
{
    public static void Show(string Msg)
    {
        MessageDialog md = new MessageDialog(null, DialogFlags.Modal, MessageType.Info, ButtonsType.Ok, Msg);
        md.Run();
        md.Destroy();
    }
}
