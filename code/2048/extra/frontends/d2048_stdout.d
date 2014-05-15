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
  string temp = sio.stdin.readln()[0..$-1]; // get rid of the last \n
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
  sio.writeln("PSYCH, Not!!!");
  
}

//string[] commands = ["quit", "up", "right", "down", "left"]; /// Don't need this

void PrintTileBoard(TileBoard inputtb)
{
  sio.writefln("%(%s,%)", inputtb.tiles);
}


void BeginStdOutGame()
{
  TileBoard tb = TileBoard(4);
  
  sio.writeln("beginning game");

  string inputstring;
  bool run = true;
  
  bool game_started = false;
  do
  {
    inputstring = GetInput();
    debug(Game) sio.writeln("got: [", inputstring, "]");
    switch(inputstring)
    {
      case "quit" : run = false; break;
      case "start" : game_started = true; break;
      case "up" :
      case "down" :
      case "right" :
      case "left" :
        if(game_started)
        {
          switch (inputstring)
          {
            case "up": tb.Move(Direction.UP); break;
            case "down" : tb.Move(Direction.DOWN); break;
            case "left" : tb.Move(Direction.LEFT); break;
            case "right" : tb.Move(Direction.RIGHT); break;
            default: break;
          }
          PrintTileBoard(tb);
        } else
        {
          sio.writeln("No can do, you have to start the game");
        }
        break;
        default: sio.writeln("unrecognized command: [", inputstring, "]"); break;
    }
    
    
   
  } while (run);
  
}

void PrintHelp()
{
  string help = 
r"
Command Line Arguments:
-h --help : print this help
-b --begin : begin a stdout game nearly done
-u --ui : select the ui

UIs available:
NCURSES : an Ncurses UI [NOT DONE]
ALLEGRO : an Allegro (openGL graphics library) [NOT DONE]
GTK : a GTK+ UI [NOT DONE]

Commands accepted in stdout version:
up = move tiles up
down = move tiles down
left = move tiles left
right  = move tiles right
quit = quit the game
start = start a new game";

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
    else
    {
      sio.writeln("use -h to get help");
    }
  }
}




