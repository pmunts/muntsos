
// This file has been generated by the GUI designer. Do not modify.

public partial class MainWindow
{
	private global::Gtk.VBox vbox1;

	private global::Gtk.Alignment alignment1;

	private global::Gtk.HBox hbox1;

	private global::Gtk.Label label1;

	private global::Gtk.Entry ServerName;

	private global::Gtk.Alignment alignment2;

	private global::Gtk.Table table1;

	private global::Gtk.Button ButtonCCW;

	private global::Gtk.Button ButtonCW;

	private global::Gtk.Button ButtonDown;

	private global::Gtk.Button ButtonFire;

	private global::Gtk.Button ButtonUp;

	protected virtual void Build ()
	{
		global::Stetic.Gui.Initialize (this);
		// Widget MainWindow
		this.TooltipMarkup = "GTK# Client for the Dream Cheeky Thunder USB Missile Launcher ONC/RPC Server";
		this.Name = "MainWindow";
		this.Title = global::Mono.Unix.Catalog.GetString ("GTK# Missile Client");
		this.Icon = global::Gdk.Pixbuf.LoadFromResource ("MissileClientGTK.MissileClient.ico");
		this.WindowPosition = ((global::Gtk.WindowPosition)(4));
		// Container child MainWindow.Gtk.Container+ContainerChild
		this.vbox1 = new global::Gtk.VBox ();
		this.vbox1.Name = "vbox1";
		this.vbox1.Spacing = 6;
		// Container child vbox1.Gtk.Box+BoxChild
		this.alignment1 = new global::Gtk.Alignment (0.5F, 0.5F, 1F, 1F);
		this.alignment1.Name = "alignment1";
		this.alignment1.LeftPadding = ((uint)(10));
		this.alignment1.TopPadding = ((uint)(10));
		this.alignment1.RightPadding = ((uint)(10));
		this.alignment1.BottomPadding = ((uint)(30));
		// Container child alignment1.Gtk.Container+ContainerChild
		this.hbox1 = new global::Gtk.HBox ();
		this.hbox1.Name = "hbox1";
		this.hbox1.Spacing = 6;
		// Container child hbox1.Gtk.Box+BoxChild
		this.label1 = new global::Gtk.Label ();
		this.label1.Name = "label1";
		this.label1.LabelProp = global::Mono.Unix.Catalog.GetString ("Server Name:");
		this.hbox1.Add (this.label1);
		global::Gtk.Box.BoxChild w1 = ((global::Gtk.Box.BoxChild)(this.hbox1 [this.label1]));
		w1.Position = 0;
		w1.Expand = false;
		w1.Fill = false;
		// Container child hbox1.Gtk.Box+BoxChild
		this.ServerName = new global::Gtk.Entry ();
		this.ServerName.TooltipMarkup = "Server IP address or domain name";
		this.ServerName.CanFocus = true;
		this.ServerName.Name = "ServerName";
		this.ServerName.IsEditable = true;
		this.ServerName.InvisibleChar = '●';
		this.hbox1.Add (this.ServerName);
		global::Gtk.Box.BoxChild w2 = ((global::Gtk.Box.BoxChild)(this.hbox1 [this.ServerName]));
		w2.Position = 1;
		this.alignment1.Add (this.hbox1);
		this.vbox1.Add (this.alignment1);
		global::Gtk.Box.BoxChild w4 = ((global::Gtk.Box.BoxChild)(this.vbox1 [this.alignment1]));
		w4.Position = 0;
		w4.Expand = false;
		w4.Fill = false;
		// Container child vbox1.Gtk.Box+BoxChild
		this.alignment2 = new global::Gtk.Alignment (1F, 1F, 0.5F, 1F);
		this.alignment2.Name = "alignment2";
		// Container child alignment2.Gtk.Container+ContainerChild
		this.table1 = new global::Gtk.Table (((uint)(3)), ((uint)(3)), false);
		this.table1.Name = "table1";
		this.table1.RowSpacing = ((uint)(6));
		this.table1.ColumnSpacing = ((uint)(6));
		// Container child table1.Gtk.Table+TableChild
		this.ButtonCCW = new global::Gtk.Button ();
		this.ButtonCCW.TooltipMarkup = "Turn launcher counter-clockwise";
		this.ButtonCCW.WidthRequest = 75;
		this.ButtonCCW.HeightRequest = 50;
		this.ButtonCCW.Sensitive = false;
		this.ButtonCCW.CanFocus = true;
		this.ButtonCCW.Name = "ButtonCCW";
		this.ButtonCCW.UseUnderline = true;
		this.ButtonCCW.Label = global::Mono.Unix.Catalog.GetString ("CCW");
		this.table1.Add (this.ButtonCCW);
		global::Gtk.Table.TableChild w5 = ((global::Gtk.Table.TableChild)(this.table1 [this.ButtonCCW]));
		w5.TopAttach = ((uint)(1));
		w5.BottomAttach = ((uint)(2));
		w5.XOptions = ((global::Gtk.AttachOptions)(4));
		w5.YOptions = ((global::Gtk.AttachOptions)(4));
		// Container child table1.Gtk.Table+TableChild
		this.ButtonCW = new global::Gtk.Button ();
		this.ButtonCW.TooltipMarkup = "Turn launcher clockwise";
		this.ButtonCW.WidthRequest = 75;
		this.ButtonCW.HeightRequest = 50;
		this.ButtonCW.Sensitive = false;
		this.ButtonCW.CanFocus = true;
		this.ButtonCW.Name = "ButtonCW";
		this.ButtonCW.UseUnderline = true;
		this.ButtonCW.Label = global::Mono.Unix.Catalog.GetString ("CW");
		this.table1.Add (this.ButtonCW);
		global::Gtk.Table.TableChild w6 = ((global::Gtk.Table.TableChild)(this.table1 [this.ButtonCW]));
		w6.TopAttach = ((uint)(1));
		w6.BottomAttach = ((uint)(2));
		w6.LeftAttach = ((uint)(2));
		w6.RightAttach = ((uint)(3));
		w6.XOptions = ((global::Gtk.AttachOptions)(4));
		w6.YOptions = ((global::Gtk.AttachOptions)(4));
		// Container child table1.Gtk.Table+TableChild
		this.ButtonDown = new global::Gtk.Button ();
		this.ButtonDown.TooltipMarkup = "Depress launcher";
		this.ButtonDown.WidthRequest = 75;
		this.ButtonDown.HeightRequest = 50;
		this.ButtonDown.Sensitive = false;
		this.ButtonDown.CanFocus = true;
		this.ButtonDown.Name = "ButtonDown";
		this.ButtonDown.UseUnderline = true;
		this.ButtonDown.Label = global::Mono.Unix.Catalog.GetString ("DOWN");
		this.table1.Add (this.ButtonDown);
		global::Gtk.Table.TableChild w7 = ((global::Gtk.Table.TableChild)(this.table1 [this.ButtonDown]));
		w7.TopAttach = ((uint)(2));
		w7.BottomAttach = ((uint)(3));
		w7.LeftAttach = ((uint)(1));
		w7.RightAttach = ((uint)(2));
		w7.XOptions = ((global::Gtk.AttachOptions)(4));
		w7.YOptions = ((global::Gtk.AttachOptions)(4));
		// Container child table1.Gtk.Table+TableChild
		this.ButtonFire = new global::Gtk.Button ();
		this.ButtonFire.TooltipMarkup = "Fire a missile";
		this.ButtonFire.WidthRequest = 75;
		this.ButtonFire.HeightRequest = 50;
		this.ButtonFire.Sensitive = false;
		this.ButtonFire.CanFocus = true;
		this.ButtonFire.Name = "ButtonFire";
		this.ButtonFire.UseUnderline = true;
		this.ButtonFire.Label = global::Mono.Unix.Catalog.GetString ("FIRE");
		this.table1.Add (this.ButtonFire);
		global::Gtk.Table.TableChild w8 = ((global::Gtk.Table.TableChild)(this.table1 [this.ButtonFire]));
		w8.TopAttach = ((uint)(1));
		w8.BottomAttach = ((uint)(2));
		w8.LeftAttach = ((uint)(1));
		w8.RightAttach = ((uint)(2));
		w8.XOptions = ((global::Gtk.AttachOptions)(4));
		w8.YOptions = ((global::Gtk.AttachOptions)(4));
		// Container child table1.Gtk.Table+TableChild
		this.ButtonUp = new global::Gtk.Button ();
		this.ButtonUp.TooltipMarkup = "Elevate launcher";
		this.ButtonUp.WidthRequest = 75;
		this.ButtonUp.HeightRequest = 50;
		this.ButtonUp.Sensitive = false;
		this.ButtonUp.CanFocus = true;
		this.ButtonUp.Name = "ButtonUp";
		this.ButtonUp.UseUnderline = true;
		this.ButtonUp.Label = global::Mono.Unix.Catalog.GetString ("UP");
		this.table1.Add (this.ButtonUp);
		global::Gtk.Table.TableChild w9 = ((global::Gtk.Table.TableChild)(this.table1 [this.ButtonUp]));
		w9.LeftAttach = ((uint)(1));
		w9.RightAttach = ((uint)(2));
		w9.XOptions = ((global::Gtk.AttachOptions)(4));
		w9.YOptions = ((global::Gtk.AttachOptions)(4));
		this.alignment2.Add (this.table1);
		this.vbox1.Add (this.alignment2);
		global::Gtk.Box.BoxChild w11 = ((global::Gtk.Box.BoxChild)(this.vbox1 [this.alignment2]));
		w11.Position = 1;
		w11.Expand = false;
		w11.Fill = false;
		this.Add (this.vbox1);
		if ((this.Child != null)) {
			this.Child.ShowAll ();
		}
		this.DefaultWidth = 400;
		this.DefaultHeight = 300;
		this.Show ();
		this.DeleteEvent += new global::Gtk.DeleteEventHandler (this.OnDeleteEvent);
		this.ServerName.Activated += new global::System.EventHandler (this.OnServerNameEntryActivated);
		this.ButtonUp.Pressed += new global::System.EventHandler (this.OnButtonPress);
		this.ButtonUp.Released += new global::System.EventHandler (this.OnButtonRelease);
		this.ButtonFire.Pressed += new global::System.EventHandler (this.OnButtonPress);
		this.ButtonDown.Pressed += new global::System.EventHandler (this.OnButtonPress);
		this.ButtonDown.Released += new global::System.EventHandler (this.OnButtonRelease);
		this.ButtonCW.Pressed += new global::System.EventHandler (this.OnButtonPress);
		this.ButtonCW.Released += new global::System.EventHandler (this.OnButtonRelease);
		this.ButtonCCW.Pressed += new global::System.EventHandler (this.OnButtonPress);
		this.ButtonCCW.Released += new global::System.EventHandler (this.OnButtonRelease);
	}
}
