module d2048;
import smath = std.math;
import sio = std.stdio;
import sconv = std.conv;

enum Direction : ubyte
{
  UP,
  DOWN,
  LEFT,
  RIGHT
}

enum HASVALBIT = 0x80_00_00_00u;


struct Tile
{
public:
  int value = 0;
  
  this (int inval) {this.value = inval;}
  @property int intyhere(){return this.value;}
  alias intyhere this;
  
  string toString() {return sconv.to!string(this.value);}
  int opCall() {return value;}
  void opCall(int val) {this.value = val;}
  
  void opOpAssign(string op)(Tile rhs)
  {
    static if(op == "+") { this.value += rhs.value;}
    else if(op == "-") { this.value -= rhs.value;}
  }
  
  void opOpAssign(string op)(int rhs)
  {
    static if(op == "+") {this.value += rhs;}
    else if(op == "-") {this.value -= rhs;}
  }
  
  Tile opBinary(string op)(int rhs)
  {
    static if (op == "+") {return Tile(this.value + rhs);}
    else if(op == "-") {return Tile (this.value - rhs);}
  }
  
  Tile opBinary(string op)(Tile rhs)
  {
    static if (op == "+") {return Tile(this.value + rhs.value);}
    else if(op == "-") {return Tile (this.value - rhs.value);}
  }
  
  void opAssign(int inval) {this.value = inval;}
  
  // return 2^value or 0
  ulong GetFaceValue()
  {
    if(this.value > 0)
      return smath.pow(2UL,this.value);
    else
      return 0;
  }
  
  bool IsPrintable() {return (this.GetFaceValue() > 0) ? true : false;}

}

unittest
{
  Tile t1;
  for(ushort i = 0; i < 8; i++)
  {
    t1.value = i;
    sio.writeln();
    sio.writefln("2^%d == %d", t1.value, t1.GetFaceValue());
    sio.writefln("printable? %s", t1.IsPrintable());
  }
  Tile t2;
  t2 = 8;
  sio.writeln("t2: ", t2);
  t2 = t2 + 2;
  sio.writeln("t2 + 2: ", t2);
  t2 += 4;
  sio.writeln("t2 += 4: ", t2);
  t2 -= 3;
  sio.writeln("t2 -= 3: ", t2);
  
}

version(unittest)
{
  void main(){}
}

//int GetFaceVal(int i)
//{
//  return smath.pow(2,i);
//}
//auto GetFaceVal = (int i) => smath.pow(2,i);

auto GetFaceVal = (int i) => (i > 0) ? smath.pow(2,i) : 0;
auto GetXY = (int[][] intsin, int x, int y) => intsin[intsin.length - 1 - y][x];

unittest
{
  sio.writeln("\ntesting GetFaceVal lambda");
  sio.writeln("type: ", typeid(GetFaceVal));
  for(int i = 0; i < 10; i++)
    sio.writefln("%d -> %d", i, GetFaceVal(i));
  sio.writefln("4.GetFaceVal() : %d", 4.GetFaceVal());
}

unittest
{
  int[][] ints = [[0,1,2],
                  [3,4,5],
                  [6,7,8]];
  sio.writefln("%(%s\n%)", ints);
  sio.writeln(ints.length);
  for(int y = 0; y < 3; y++)
  {
    for(int x = 0; x < 3; x++)
    {
      sio.writefln("int(%d,%d) -> %d", x, y, GetXY(ints, x,y) );
    }
  }
  
}

struct TileBoard
{

  Tile[][] tiles;
//  Tile[][] tiles = [[0,0,0],[0,0,0],[0,0,0],[0,0,0]];
//  int[4][4] tiles;

//  static Tile _FromBottomLeft(Tile[4][4] tilesin, int x, int y)
//  {
//    return tilesin[tilesin.length - y - 1][x];
//  }
//  
//  static Tile _FromTopLeft(Tile[4][4] tilesin, int x, int y)
//  {
//    return tilesin[y][x];
//  }
  
  /// Get the biggest X val
  /// $(RED DON'T TRUST QUITE YET)
  @property int max_x(){return this.tiles[0].length - 1;}
  
  /// Get the biggest Y val
  /// $(RED DON'T TRUST QUITE YET)
  @property int max_y(){return this.tiles.length - 1;}
  
  ref Tile GetTileXY (int x, int y)
  {
//    return tiles[tiles.length - y - 1][x];
    debug(GetTileXY) sio.writefln("accessing (%d,%d) max_y : %d => %s", x, y, max_y, tiles[max_y - y][x]);
    return tiles[max_y - y][x];
  }
  
  /// move in the specified direction
  void Move(Direction d)
  {
  
    sio.writefln("starting:\n^####^\n%(%s\n%)\n^####^", this.tiles);
    debug sio.writefln("max_x: [%s]\nmax_y: [%s]", max_x, max_y);
    if(d == Direction.UP)
    {
      for(int x = 0; x <= max_x; x++)
      {
        for(int y = max_y - 1; y >= 0; y--)
        {
          debug sio.writefln("going to try comparing (%s,%s) & (%s,%s)", x, y, x, y+1);
          if (GetTileXY(x, y) == GetTileXY(x, y + 1) && GetTileXY(x,y) != 0)
          { 
            debug sio.writefln("%s == %s", GetTileXY(x, y), GetTileXY(x, y + 1));
            this.GetTileXY(x, y + 1) = GetTileXY(x,y) + 1;
            sio.writefln("^####^\n%(%s\n%)\n^####^", this.tiles);
            if(y != 0) 
            {
//              debug sio.writefln("%(%s\n%)", [GetTileXY(x, y+1), GetTileXY(x, y), GetTileXY(x, y-1)]);
              debug sio.writeln("y != 0, so shifting up");
              this.GetTileXY(x, y) = GetTileXY(x, y - 1);
              GetTileXY(x, y - 1) = 0;
            }
            else 
            {
//              debug sio.writefln("%(%s\n%)", [GetTileXY(x, y+1), GetTileXY(x, y)]);
              debug sio.writeln("y == 0, so setting to 0");
              this.GetTileXY(x, y) = 0;
            }
            sio.writefln("^####^\n%(%s\n%)\n^####^", this.tiles);
          }
          else if (GetTileXY(x, y+1) == 0)
          {
            debug sio.writeln("shifting up, block above is up");
            this.GetTileXY(x, y+1) = this.GetTileXY(x, y);
            debug sio.writefln("%s != %s", GetTileXY(x, y), GetTileXY(x, y + 1));
          }
        }
      }
    }
  }
  
  @disable bool CanMove(byte x, byte y, Direction d)
  {
    if( d == Direction.UP )
    {
      for(int _y = 0; _y < 4; _y++)
      {
        for(int _x = 0; _x < 4; _x++)
        {
        
        }
      }
    }
    return false;
  }
  
  

}


/// converts from a 2d array of ints into a 2d array of tiles, useful for setting up a test board quickly
Tile[][] FromInts(int[][] arrayin)
{
  Tile[][] yup;
  yup.length = arrayin.length;
  foreach(int index, int[] i; arrayin)
  {
    yup[index].length = i.length;
    foreach(int index2, int i2; i)
    {
      yup[index][index2] = Tile(i2);
    }
  }
  return yup;
}
unittest
{
  TileBoard tb1;
  tb1.tiles = [[0,1,2,0],
               [2,1,1,0],
               [2,1,1,0],
               [0,0,0,0]].FromInts();
  sio.writefln("%(%s\n%)", tb1.tiles);
//  sio.writeln(tb1.GetTileXY(1,1));
//  sio.writeln(tb1.GetTileXY(1,2));
//  sio.writeln(tb1.GetTileXY(0,0));
//  sio.writeln(tb1.GetTileXY(2,2));
  tb1.Move(Direction.UP);
  sio.writefln("%(%s\n%)", tb1.tiles);
}
