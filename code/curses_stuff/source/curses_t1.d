// curses test 1
import deimos.ncurses.curses;
import deimos.ncurses.panel;
import std.stdio;
import std.string;

debug = characters;


void test1()
{
  //WINDOW* stdscr = initscr();
  initscr();
  scope(exit) endwin();
  scope(failure) endwin();
  
  WINDOW* mwin = newwin(5, 40, 4, 4);
  wborder(mwin, 0x6a, 'b', 'c', 'd', 0,0,0,0);

  mvwprintw(stdscr, 0, 0, toStringz("Hello World!"));
  mvwprintw(mwin, 1, 1, toStringz("Hello World!"));
  addch(ACS_DIAMOND);

  refresh();
  wrefresh(mwin);

  getch();
  endwin();

  debug(characters)
  {
    writefln("%s is %#x", ACS_ULCORNER.stringof, ACS_ULCORNER);
    writefln("%s is %#x %s", "0x25A0", 0x25A0, '\u25a0');
    writefln("%s is %#x %s", "0x25A0", 0x25A0, '\u25a0');
  }
}

void main()
{
  test1();
}
