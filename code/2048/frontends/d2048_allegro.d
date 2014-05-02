//import al = allegro5.allegro;
import allegro5.allegro;
import allegro5.allegro_primitives;
import allegro5.allegro_image;
import allegro5.allegro_font;

import sio = std.stdio;


__gshared
{
  ALLEGRO_COLOR[string] global_colors;
  ALLEGRO_DISPLAY* maindisplay;
}

int AllegroSetUp()
{
  sio.writeln("hello WOrld!");
  
  al_init()
  al_init_font_addon();
  assert(al_install_keyboard); // scope(exit) al_uninstall_keyboard();

  return 0;
}

void main()
{

  global_colors =
    ["RED" : al_map_rgb(255,0,0),
     "GREEN" : al_map_rgb(0,0,255),
     "BLUE" : al_map_rgb(0,255,0)
      ];
  al_run_allegro(delegate int () {AllegroMain(); return 0;} );
  
}
