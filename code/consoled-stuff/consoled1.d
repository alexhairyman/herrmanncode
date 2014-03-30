// hopefully consoled from robik (http://github.com/robik/consoled) will work!

//public import core.sys.posix.sys.ioctl;
import consoled;
import terminal;
import std.stdio;

void doreset(){ resetColors(); stdout.flush(); writeln();}
void main()
{

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


  scope(exit) {doreset();}
  setCursorPos(0,40);

}
