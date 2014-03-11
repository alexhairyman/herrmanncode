// curses test 1
import deimos.ncurses.curses;
import deimos.ncurses.panel;
import std.stdio;
import std.string;

void test1()
{
  //WINDOW* stdscr = initscr();
  initscr();
  scope(exit) endwin();
  scope(failure) endwin();
  
  WINDOW* mwin = newwin(5, 40, 4, 4);
//  box(mwin, cast(char) ACS_PLUS, '*');
  wborder(mwin, ACS_DIAMOND, ACS_DIAMOND, ACS_DIAMOND, ACS_DIAMOND, 0,0,0,0);

  mvwprintw(stdscr, 0, 0, toStringz("Hello World!"));
  mvwprintw(mwin, 1, 1, toStringz("Hello World!"));
  addch(ACS_DIAMOND);

  refresh();
  wrefresh(mwin);

  getch();
  endwin();

}

void main()
{
  test1();
}
