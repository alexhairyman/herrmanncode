// hopefully consoled from robik (http://github.com/robik/consoled) will work!

//public import core.sys.posix.sys.ioctl;
module consoled_test1;
import std.stdio;
import std.typetuple;
import std.typecons;

void terminald_main()
{
  import tio = terminal;

  tio.Terminal term = tio.Terminal(tio.ConsoleOutputType.cellular);
  //tio.RealTimeConsoleInput rtci = tio.RealTimeConsoleInput(&term, tio.ConsoleInputFlags.raw);
  //term.color(tio.Color.white, tio.Color.red);
  term.writeln();
  term.write ("HELLO WORLD");
  
  stdout.flush();
  
  term.moveTo(term.cursorX + 30, term.cursorY - 4, tio.ForceOption.alwaysSend);
  term.showCursor();
  
  term.write ("FORWARD?");
  term.writeln();
  
  term.reset();
  //writeln("AGAIN AGAIN AGAIN");
  
}

void doreset()
{
  import consoled;
  resetColors();
  stdout.flush();
  writeln();
}

void consoled_main()
{
  import consoled;
  foreground = Color.blue;
  background = Color.green;
  write("hello world"); doreset();

  foreground = Color.white;
  background = Color.black;
  write("again.... you get it"); doreset();

  foreground = Color.red; background = Color.initial;
  writeln("now for something more fun"); doreset();

  fillArea(ConsolePoint(0,0), ConsolePoint(40,20), '*');

  setCursorPos(20, 10);
  writec("$");

//  RealTimeConsoleInput rtci = RealTimeConsoleInput(
  char[1] inbuf;
  while(stdin.rawRead(inbuf) != "q")
  {
    writeln(inbuf);
  }


  scope(exit) { doreset(); }
  setCursorPos(0,40);

}

void main()
{
  terminald_main();
  //consoled_main();
  writeln("hello world");
}