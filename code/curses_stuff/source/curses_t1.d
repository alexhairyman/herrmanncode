// curses test 1
import curse = deimos.ncurses.curses;
import cpanel = deimos.ncurses.panel;
import cform = deimos.ncurses.form;
import cmenu = deimos.ncurses.menu;

import std.stdio;
import std.string;

debug = characters;


void test1()
{
  //WINDOW* stdscr = initscr();
  
//  curse.initscr();
//  scope(exit) curse.endwin();
//  scope(failure) curse.endwin();
  
  
  curse.WINDOW* mwin = curse.newwin(5, 40, 4, 4); scope(exit) curse.delwin(mwin);
  curse.wborder(mwin, 0,0,0,0, 0,0,0,0);

  curse.mvwprintw(curse.stdscr, 0, 0, toStringz("Hello World!"));
  curse.mvwprintw(mwin, 1, 1, toStringz("Hello World!"));
//  curse.addch(ACS_DIAMOND);

  curse.refresh();
  curse.wrefresh(mwin);

  curse.getch();
  return;

  debug(chardebug)
  {
    writefln("%s is %#x", curse.ACS_ULCORNER.stringof, curse.ACS_ULCORNER);
    writefln("%s is %#x %s", "0x25A0", 0x25A0, '\u25a0');
    writefln("%s is %#x %s", "0x25A0", 0x25A0, '\u25a0');
  }
}

void test2()
{
  
  curse.noecho();
  curse.clear();
  int sizex = curse.getmaxx(curse.stdscr) - 2;
  int sizey = curse.getmaxy(curse.stdscr) - 2;
  curse.WINDOW* mwin = curse.newwin(sizey , sizex / 2, 1,1); scope(exit) curse.delwin(mwin);
  curse.wborder(mwin, 0,0,0,0,0,0,0,0);
  cpanel.PANEL* mpanel = cpanel.new_panel(mwin); scope(exit) cpanel.del_panel(mpanel);
  cpanel.show_panel(mpanel);
  
  cpanel.update_panels();
  curse.refresh();
  curse.wrefresh(mwin);
  curse.getch();
  curse.doupdate();
 
  cpanel.move_panel(mpanel, 10, 10);
  //cpanel.show_panel(mpanel);

  cpanel.update_panels();
  curse.doupdate();
  
  curse.getch();
  return;
}

void test3()
{
  curse.clear();
  
  int sizex = curse.getmaxx(curse.stdscr) - 2;
  int sizey = curse.getmaxy(curse.stdscr) - 2;
  
  curse.WINDOW* win1 = curse.newwin(sizey, sizex/2, 1,1); scope(exit) curse.delwin(win1);
  curse.WINDOW* win2 = curse.newwin(sizey, sizex/2, 1, sizex/2); scope(exit) curse.delwin(win1);
  
  curse.box(win1, 0,0);
  curse.box(win2, 0,0);
  
  curse.refresh();
  curse.wrefresh(win1);
  curse.wrefresh(win2);
  
  curse.getch();
  curse.getch();
}

void test4()
{
  curse.clear();
  
  curse.start_color();
  curse.cbreak();
  curse.noecho();
  int sizex = curse.getmaxx(curse.stdscr) - 2;
  int sizey = curse.getmaxy(curse.stdscr) - 2;
  
  curse.init_pair(1, curse.COLOR_WHITE, curse.COLOR_BLUE);
  curse.init_pair(2, curse.COLOR_WHITE, curse.COLOR_RED);
  
  curse.mvwprintw(curse.stdscr, 0, sizex/2 - 4, "form test");
  
  curse.WINDOW* topwin = curse.newwin(1,sizex - 2, 0, 0);  scope(exit) curse.delwin(topwin);
  curse.mvwprintw(topwin, 0, 10, "FORM TEST");
  
  curse.WINDOW* win1 = curse.newwin(sizey, sizex/2, 2, 1); scope(exit) curse.delwin(win1);
  curse.WINDOW* win2 = curse.newwin(sizey, sizex/2, 2, sizex/2); scope(exit) curse.delwin(win2);
  
  cform.FIELD* namefield = cform.new_field(1, 15, 7, 7, 0, 0); scope(exit) cform.free_field(namefield);
  cform.FIELD* agefield = cform.new_field(1, 3, 8, 8, 0, 0); scope(exit) cform.free_field(agefield);
  
//  cform.set_field_fore(namefield, curse.COLOR_PAIR(1));
  cform.set_field_back(namefield, curse.COLOR_PAIR(2));
  
  cform.FIELD** fields = cast(cform.FIELD**) [agefield, namefield];
  cform.FORM* nameage = cform.new_form(fields);
  
  cform.post_form(nameage); scope(exit) cform.unpost_form(nameage);
  cform.set_field_buffer(namefield, 0, "helloworld");
//  curse.attron(curse.COLOR_PAIR(2));
  curse.box(win1, 0,0);
  curse.box(win2, 0,0);
//  curse.attroff(curse.COLOR_PAIR(2));
  cform.set_field_buffer(namefield, 0, "helloworld");
  
  curse.refresh();
  curse.wrefresh(win1);
  curse.wrefresh(win2);
  curse.wrefresh(topwin);
  
//  cform.set_field_buffer(namefield, 0, "helloworld");
  int c;
  while((c = curse.getch()) != 'q')
  {
    if(c == 'a') {
      cform.set_field_buffer(namefield, 0, "helloworld");
      curse.refresh();
    }
  }
  
  curse.getch();
//  curse.getch();
}

void main()
{
  curse.initscr();
  
//  test1();
//  test2();
//  test3();
  test4();
  
  scope(exit) curse.endwin();
  scope(failure) curse.endwin();
  curse.endwin();
}
