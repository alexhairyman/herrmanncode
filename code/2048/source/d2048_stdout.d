import d2048;
import sio = std.stdio;
import srand = std.random;
import sstr = std.string;
import sgo = std.getopt;
import sconv = std.conv;
import strt = std.traits;

__gshared bool action_done = false;
string GetInput()
{
  string temp = sio.stdin.readln('\n');
  return temp;
}

enum UIs
{
  NO_VAL = 0,
  NCURSES,
  ALLEGRO,
  GTK
}

void UiSelection(string dummyopt, string instr)
{
  action_done = true;
  bool found = false;
  UIs tuis = UIs.NO_VAL;
  foreach(x; strt.EnumMembers!UIs)
  {
    if(instr == sconv.to!string(x))
    {
      tuis = x;
      sio.writefln("%s == %s !", instr, x);
    }
  }
  BeginGame(tuis);
}

void BeginGame(UIs ui_in)
{
  action_done = true;
  sio.writeln("running ", ui_in);
  
}


void BeginStdOutGame()
{
  string inputstring;
  do
  {
    inputstring = GetInput();
  } while (inputstring != "quit");
  
}

void PrintHelp()
{
  string help = 
r"
Command Line Arguments:
-h --help : print this help
-b --begin : begin a stdout game
-u --ui : select the ui

UIs available:
NCURSES : an Ncurses UI [NOT_DONE]
ALLEGRO : an Allegro (openGL graphics library) [NOT_DONE]
GTK : a GTK+ UI [NOT_DONE]

Commands accepted in stdout version:
up = move tiles up
down = move tiles down
left = move tiles left
right  = move tiles right
quit = quit the game";

  action_done = true;
  sio.writeln(help);
}
void main(string[] argv)
{
  
  TileBoard tb1 = TileBoard(4);
  bool begingame = false;
  sgo.getopt(argv,
            "h|help", &PrintHelp,
            "b|begin", &begingame,
            "u|ui", &UiSelection);
  
  if(!action_done)
  {
    if(begingame)
    {
      action_done = true;
      BeginStdOutGame();
    }
  }

  
  else
  {
    sio.writeln("use -h to get help");
  }
}




