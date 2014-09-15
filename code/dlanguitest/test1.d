module test1;

import std.stdio;
import dlangui.all;
import dlangui.widgets;

//mixin DLANGUI_ENTRY_POINT;

extern(C) int UIAppMain(string[] args)
{
  bool toggleclick = false;

  VerticalLayout mtl = new VerticalLayout;
  Button hibutton = new Button;
  hibutton.onClickListener = delegate (Widget src)
  {
    switch(toggleclick)
    {
      case false: src.text = "toggle is false"; toggleclick = true; break;
      case true: src.text = "toggle is true"; toggleclick = false; break;
      default: writeln("why default run is?"); break;
    }

  };
  mtl.addChild(hibutton);

  Window mwindow = Platform.instance.createWindow("Hello World", null);
  mwindow.mainWidget = mtl;
}

