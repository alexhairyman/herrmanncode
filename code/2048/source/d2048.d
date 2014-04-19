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
  
  @property int intyhere(){return this.value;}
  alias intyhere this;
  
  string toString() {return sconv.to!string(this.value);}
  int opCall() {return value;}
  void opCall(int val) {this.value = val;}
  
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
  t2 += 2;
  sio.writeln("t2 + 2: ", t2);
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

  Tile[4][4] tiles;
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

  
  ref Tile GetTileXY (int x, int y)
  {
    return tiles[tiles.length - y - 1][x];
  }
  
  void Move(Direction d)
  {
    if(d == Direction.UP)
    {
      for(int column = 0; column <= 3; column++)
      {
        for(int row = 2; row >=0; column--)
        {
          if (GetTileXY(column, row) == GetTileXY(column, row + 1))
          {
            debug sio.writefln("%d %d", GetTileXY(column, row), GetTileXY(column, row + 1));
          }
        }
      }
    }
  }
  
  bool CanMove(byte x, byte y, Direction d)
  {
    if( d == Direction.UP )
    {
      for(int column = 0; column < 4; column++)
      {
        for(int row = 0; row < 4; row++)
        {
        
        }
      }
    }
    return false;
  }
  
  
//  void Initialize ()
//  {
//    for(int y = 0; y < 4; y++)
//    {
//      debug sio.writeln();
//      for(int x = 0; x < 4; x++)
//      {
//        this.tiles[x][y].value = 0;
//        debug sio.writef("(%d,%d) ", x ,y);
//      }
//    }
//  }
}
