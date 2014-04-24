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

alias ptrdiff_t i_t;

//static Tile FromInt(int inval) {Tile t1 = invalt1.value = inval; return t1

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
  this(i_t sidesize)
  {
    tiles.length = sidesize;
    foreach(Tile[] t; tiles)
    {t.length = sidesize;}
  }
  
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
  @property i_t max_x(){return this.tiles[0].length - 1;}
  
  /// Get the biggest Y val
  /// $(RED DON'T TRUST QUITE YET)
  @property i_t max_y(){return this.tiles.length - 1;}
  
  ref Tile GetTileXY (int x, int y)
  {
//    return tiles[tiles.length - y - 1][x];
    debug(GetTileXY) sio.writefln("accessing (%d,%d) max_y : %d => %s", x, y, max_y, tiles[max_y - y][x]);
    return tiles[max_y - y][x];
  }
  
  static Tile[] ShiftLine(Tile[] linein, in Direction d)
  {
    Tile[] line = linein.dup;
    if(d == Direction.UP || d == Direction.RIGHT)
    {
      for(i_t i = line.length - 2; i >= 0; i--)
      {
        if(line[i+1] == 0 && line[i] > 0)
        {
          line[i+1] = line[i];
          line[i] = 0;
          line = ShiftLine(line, d);
          
        }
      }
    } else if (d == Direction.DOWN || d == Direction.LEFT)
    {
      for(i_t i = 1 ; i <=  line.length - 1; i++)
      {
        if(line[i-1] == 0 && line[i] > 0)
        {
          line[i-1] = line[i];
          line[i] = 0;
          line = ShiftLine(line, d);
        }
      }
    }
    debug(ShiftLine) sio.writefln("SHIFT d: %s [%(%s,%)] => [%(%s,%)]", d, linein, line);
    return line;
  }
  
  static Tile[] MoveLine(Tile[] linein, in Direction d)
  {
  
    Tile[] line = linein.dup;
//    debug(MoveLine) 
    line = ShiftLine(line, d);
  
    if(d == Direction.UP || d == Direction.RIGHT)
    {
      if(d == Direction.UP) line.reverse;
      for(i_t i = line.length - 2; i >= 0; i--)
      {
        if(line[i+1] == line[i] && line[i] > 0)
        {
//          debug(MoveLine) sio.writeln("they're the same! combining!");
          line[i+1] = line[i] + 1;
          line[i] = 0;
          line = ShiftLine(line, d);
        }
      }
    } else if (d == Direction.DOWN || d == Direction.LEFT)
    {
      for(i_t i = 1 ; i <=  line.length - 1; i++)
      {
        if(line[i-1] == line[i] && line[i] > 0)
        {
//          debug(MoveLine) sio.writeln("they're the same! combining!");
          line[i-1] = line[i] + 1;
          line[i] = 0;
          line = ShiftLine(line, d);
        }
      }
    }
    debug(MoveLine) sio.writefln("MOVE  d: %s [%(%s,%)] => [%(%s,%)]", d, linein, line);
    return line;
  }
  
  unittest
  {
    sio.writeln("Having fun with line shifting");
    auto lines = [[1,0,0,0],
                  [1,1,0,0],
                  [0,1,1,0],
                  [0,0,1,1],
                  [0,1,0,1],
                  [0,0,0,1],
                  [0,1,1,2],
                  [2,2,1,1],
                  [2,3,3,2]];
                  
    sio.writeln("moving right/up");
    foreach(int[] x; lines)
    {
//      sio.writeln("shifting: ", x);
      sio.writefln("[%(%s,%)] --> [%(%s,%)]", x, MoveLine(FromInts(x), Direction.UP));
    }
    sio.writeln("moving left/down");
    foreach(int[] x; lines)
    {
      //      sio.writeln("shifting: ", x);
      sio.writefln("[%(%s,%)] --> [%(%s,%)]", x, MoveLine(FromInts(x), Direction.DOWN));
    }
  }
  
  /// this ought to be interesting
  void SetCol(int x, Tile[] col)
  {
    foreach(i_t index, Tile[] i; this.tiles)
    {
      this.tiles[index][x] = col[col.length - 1 - index];
    }
  }
  
  /// little bit trickier than GetRow
  Tile[] GetCol(int x)
  {
    Tile [] temp;
    foreach(i_t index, Tile[] i; this.tiles)
    {
      temp ~= i[x];
    }
    debug(GetCol) sio.writefln("column = %(%s,%)", temp);
    return temp.dup;
  }
  
  //easy again
  void SetRow(int y, Tile[] row)
  {
    this.tiles[y] = row;
  }
  
  /// Easy!
  Tile[] GetRow(int y)
  {
    Tile[] temp = this.tiles[y].dup;
    return temp;
  }

  void Shift(Direction d)
  {
    if(d == Direction.UP || d == Direction.DOWN)
    {
      Tile[][] temp;
      for(int i = 0; i <= max_x; i++)
      {
        temp ~= ShiftLine(this.GetCol(i), d);
      }
    }
    if(d == Direction.UP || d == Direction.DOWN)
    {
      Tile[][] temp;
      for(int i = 0; i <= max_y; i++)
      {
        temp ~= ShiftLine(this.GetRow(i), d);
      }
    }
  }
  
  
  /// move in the specified direction
  void Move(Direction d)
  {
//    Tile[][] temp;
    if(d == Direction.UP || d == Direction.DOWN)
    {
      for(int i = 0; i <= max_x; i++)
      {
        debug(Move) sio.writefln("moving %(%s,%)", this.GetCol(i));
        this.SetCol(i, MoveLine(this.GetCol(i), d));
        debug(Move) sio.writefln("moved %(%s,%)", this.GetCol(i));
      }
    }
    else if(d == Direction.RIGHT || d == Direction.LEFT)
    {
      for(int i = 0; i <= max_y; i++)
      {
        debug(Move) sio.writefln("moving %(%s,%)", this.GetRow(i));
        this.SetRow(i, MoveLine(this.GetRow(i), d));
        debug(Move) sio.writefln("moved %(%s,%)", this.GetRow(i));
      }
    }
    
//    this.tiles = temp.dup;
  } 

}


Tile[] FromInts(int[] arrayin)
{
  Tile[] yup;
  yup.length = arrayin.length;
  foreach(i_t index, int i; arrayin)
  {
    yup[index] = Tile(i);
  }
  return yup;
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
  int[][][] tileboards = [
               [
                [0,0,0,0],
                [1,2,3,4],
                [1,1,1,4],
                [2,2,2,2]
               ],
               [
                [1,1,1,1],
                [2,2,1,1],
                [3,3,4,4],
                [1,2,1,2]
               ]
              ];
  tb1.tiles = [[0,1,2,2],
               [2,1,1,2],
               [2,1,1,3],
               [0,0,0,3]].FromInts();
               
  void WriteChange(string msg, TileBoard inboard = tb1)
  {
    sio.writefln("tiles %s :\n%(%s\n%)", msg, inboard.tiles);
  }
  WriteChange("Begin");
  tb1.Move(Direction.UP);
  WriteChange("UP");
  tb1.Move(Direction.LEFT);
  WriteChange("LEFT");
  tb1.Move(Direction.RIGHT);
  WriteChange("RIGHT");
  tb1.GetTileXY(0,2) = 1;
  WriteChange("1 added");
  tb1.Move(Direction.RIGHT);
  WriteChange("RIGHT");
  tb1.Move(Direction.RIGHT);
  tb1.Move(Direction.RIGHT);
  WriteChange("RIGHT twice");
  tb1.Move(Direction.DOWN);
  WriteChange("DOWN");
//  tb1.Shift(Direction.UP);
}
