import gtk.Main, gtk.MainWindow, gtk.Label, gtk.MessageDialog, gtk.Dialog, gtkc.gtktypes, gtk.Grid,
       gtk.Button, gdk.Event, gtk.Widget;
import sio = std.stdio, cthread = core.thread, sconc = std.concurrency, spar = std.parallelism,
       sconv = std.conv;


class HelloWindow : MainWindow
{
  private bool SetUpGame(Event e, Widget w)
  {
    sio.writeln(w.getName());
    sio.stdout.flush();
    Grid pgrid = cast(Grid) w.getParent();
    pgrid.removeAll();
    pgrid.attach(new Label("2048!"), 0,0,4,1);
    for(int x = 0; x < 4; x++)
    {
      for(int y = 1; y < 5; y++)
        pgrid.attach(new Label("(" ~ sconv.to!string(x) ~ "," ~ sconv.to!string(y - 1) ~ ")"), x, y, 1, 1);
    }
    
    pgrid.getParent.showAll();
    return true;
  }
  this()
  {
    super("GtkD");
    setBorderWidth(7);
    
    Label hilabel = new Label("Welcome to d2048!");
    Button continue_label = new Button("Continue", false);

    Grid mgrid = new Grid();
    mgrid.attach(hilabel, 1, 0, 1, 1);
    mgrid.attach(continue_label, 0, 1, 3, 1);
    continue_label.addOnButtonRelease(&SetUpGame);
    
    this.add(mgrid);
    this.showAll();

  }
}
void main(string[] args)
{
  Main.init(args);
  new HelloWindow;
  Main.run();
}
