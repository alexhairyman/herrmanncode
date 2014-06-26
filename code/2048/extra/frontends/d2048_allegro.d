//import al = allegro5.allegro;
import allegro5.allegro;
import allegro5.allegro_primitives;
import allegro5.allegro_image;
import allegro5.allegro_font;
import allegro5.allegro_ttf;

import sio = std.stdio;
import sform = std.format;
import sstr = std.string;
import sconv = std.conv;
alias to = sconv.to;

import cthr = core.thread;

string GetCanonicalFromUint (uint input)
{
  ubyte major = input >> 24;
  ubyte minor = (input >> 16) & 255;
  ubyte revision = (input >> 8) & 255;
  ubyte release = input & 255; 
  return sstr.format("%s.%s.%s.%s", major, minor, revision, release);
}

import d2048;
__gshared
{
//  ALLEGRO_COLOR[string] global_colors;
  ALLEGRO_DISPLAY* maindisplay;
  ALLEGRO_EVENT_QUEUE* mainqueue;
//  ALLEGRO_EVENT* mevent;
}


alias event_queue = mainqueue;
/// implements 2048 in allegro
//class Allegro2048 : D2048Game


class Allegro2048 : D2048Game
{
private:
  ALLEGRO_DISPLAY* mdisp_; /// the main display where we do all of our stuff!

//public:
  /// will return true if window was opened, or false if not
  bool OpenWindow()
  {
    debug sio.writeln("opening window");
    bool opened = false;
    maindisplay = al_create_display(800,600); // yes it's hardcoded
    if(maindisplay == null)
      opened = false;
    else
      opened = true;
      
    return opened;
  }
  
  void DoSetUp()
  {
    debug sio.writeln("setup");
//    al_register_event_source(mainqueue, al_get_keyboard_event_source());
    mainqueue = al_create_event_queue();
    al_register_event_source(event_queue, al_get_keyboard_event_source());
    al_register_event_source(event_queue, al_get_display_event_source(maindisplay));
    debug sio.writeln("fully set up!");
  }
  
  void RunGame()
  {
    bool window_opened = this.OpenWindow(); //also does event set up and stuff
    debug sio.writeln(window_opened);
    this.DoSetUp();
    debug sio.writeln("trying to clear colors");
    al_clear_to_color(ALLEGRO_COLOR(.2,.2,.2));
    
    debug sio.writeln("ah yes");
    float[] lilbox = 
    [
    200,20,
    500,500
    ];
    debug sio.writeln(cast(int)lilbox.length / 2);
    al_draw_ribbon(lilbox.ptr, 1, ALLEGRO_COLOR(1, .1, .1, 1), 3f, cast(int)lilbox.length / 2);
    al_flip_display();
    
    bool exit = false;
    while(exit != true)
    {
      ALLEGRO_EVENT mevent;
      al_wait_for_event(mainqueue, &mevent);
      switch(mevent.type)
      {
        case ALLEGRO_EVENT_KEY_CHAR:
          if(mevent.keyboard.keycode == ALLEGRO_KEY_Q) exit = true;
          else debug sio.writeln("got a key ", to!char(mevent.keyboard.unichar));
          break;
          
        default:
//          debug sio.writeln ("got an event");
      }
    }
    
    
  }
  
  public void BeginGame()
  {
    debug sio.writeln("began a new game");
    cthr.Thread gamethread = new cthr.Thread(delegate void () {this.RunGame();});
    debug sio.writeln("WE HAVE STARTED");
    gamethread.start();
    gamethread.join();
//    this.RunGame();
  }
//override:

  void ProcessEventStack(EventStack e)
  {

  }
  void PlayGame()
  {
    sio.writeln("not yet working");
  }

  string GameName()
  {
    return "allegro";
  }

  string GameDescription()
  {
    return "Allegro implementation of the frontend";
  }
}

int AllegroSetUp()
{
  sio.writeln("hello WOrld!");

  al_init();
  al_init_font_addon();
  al_init_ttf_addon(); // get you a font!
  al_init_image_addon();
  sio.writeln(GetCanonicalFromUint(al_get_allegro_version()));
  assert(al_install_keyboard); // scope(exit) al_uninstall_keyboard();
  
  sio.writeln(al_is_keyboard_installed);
  Allegro2048 agame = new Allegro2048();
  agame.BeginGame();

  return 0;
}
class AllegroLoop
{
 
}

void main()
{

/*
  global_colors =
    ["RED" : al_map_rgb(255,0,0),
     "GREEN" : al_map_rgb(0,0,255),
     "BLUE" : al_map_rgb(0,255,0)
      ];
*/
  al_run_allegro(delegate int () {AllegroSetUp(); return 0;} );
//  Allegro2048 agame = new Allegro2048();
//  agame.BeginGame();
  

}
