// A simple hash database

import std.digest.digest;
import std.digest.md;
import std.traits;
debug import std.stdio;
//import msgpack;

//Digest md_ = new MD5Digest();

version(unittest)
{
  import std.stdio;
  void main() {}
}

interface Hash
{
  ubyte[] hash(ubyte[] indat);
}

class MD5H : Hash
{
  ubyte[] hash(ubyte[] indat)
  {
    return md5Of(indat);
  }
}

interface HBackend
{
  /// Put a value
  void Put(KT, VT)(KT key, VT val);
  
  /// Get a value
  VT Get(VT, KT)(KT key);
  
  // Sync the HDB to whatever backend it needs
  // $(RED Can return if not applicable)
  void Sync();
}

debug {debug = hbm;}
class H_BAD_Mem : HBackend
{
protected:
  Digest dig_;
  uint diglen_;
//  ubyte[][] keys_;
  
  ubyte[] [ubyte[]] keymatch_;
  //ubyte[][] vals_;
  
public:

  this(Digest d = null)
  {
    if    (d is null) this.dig_ = new MD5Digest;
    else              this.dig_ = d;
    this.diglen_ = cast(uint) this.dig_.length;
  }
  
  VT Getas(VT)(string key)
  {
    ubyte[] tkey = this.dig_.digest(cast(ubyte[]) key);
    return cast(VT) this.keymatch_[tkey];
  }
  void Put(KT, VT)(KT key, VT val)
  {
//    this.keys_ ~= this.dig_.digest(key);
    debug(hbm) writefln("type is %s: ", typeid(KT));
    if(key.length <= 4) assert(0);
    immutable ubyte[] hkey = cast(immutable ubyte[]) this.dig_.digest( cast(ubyte[]) key );
    this.keymatch_[hkey] = cast(ubyte[]) val;
  }
  
  void Sync()
  {
    return;
  }
}

debug {debug = toubyte;}
ubyte[] ToUbyte(UT) (UT inval)
{
  union bitconv
  {
    UT tip;
    ubyte[UT.sizeof] bytes;
//    ubyte[UT.sizeof] bytes;
  }
  
  debug(toubyte) writefln("\n\ntype is %s", typeid(UT));
  ubyte[] tempu;
  
  if(__traits(isScalar, UT))
  {
    debug(toubyte) writefln("it's a scalar this big: %d", UT.sizeof);
    tempu.length = UT.sizeof;
  }
  
  for(int i = 0; i < tempu.length; i++)
  {
    bitconv TBC;
    TBC.tip = inval;
    tempu[i] = TBC.bytes[i];
//    tempu[i] = cast(ubyte) ( (0xFF) & TBC.bytes >>> (8 * i) );
    debug(toubyte) writefln("hex : 0x%.2x", tempu[ i ] & 0xFF);
  }
  debug(toubyte) writefln("final = %(0x%.2x %)", tempu.reverse);
//  return null;
  return tempu.reverse;
}
ubyte tub (T)(T input)
{
  return cast(ubyte) input;
}

alias t = tub;

unittest
{
  import std.stdio;
  uint t = 0x90ABCDEF;
  writefln("t val = %#x", t);
  writefln("to ubyte returned %s", ToUbyte!uint(t));
  writefln("0.91 to ubyte = %s", ToUbyte!double(0.91f));
  writefln("0.92 to ubyte = %s", ToUbyte!double(0.92f));
  writefln("0xFu is %s", typeid( tub(0xFu) ));
  uint tubyte = cast(uint) 0xFF;
  for(uint x = 0; x < 4; x++)
    writefln("%.8#x to ubyte = %(0x%.2x %)", tubyte<< x*4, ToUbyte!uint( tubyte << x*4));
}

class DaHDB
{
protected:
  HBackend hb_; 
  this(HBackend hback)
  {
    this.hb_ = hback;
  }
}

unittest
{
//  DaHDB hdb1 = new DaHDB(H_BAD_Mem);
  import std.stdio;
  writeln("\nstarting test");
  H_BAD_Mem hdb1 = new H_BAD_Mem(new MD5Digest);
  hdb1.Put("message" , "please son");
  hdb1.Put("another message", "get you a hash function");
//  hdb1.Put([0xAA, 0xAA, 0xAA, 0xAA,0xAA, 0xAA, 0xAA, 0xAA,0xAA, 0xAA, 0xAA, 0xAA,0xAA, 0xAA, 0xAA, 0xAA], "32 int val");
  
  writeln("vals inserted");
  
  writeln(hdb1.Getas!(string) ("message") );
  //writeln(hdb1.Getas!(string) ([0xAA, 0xAA, 0xAA, 0xAA,0xAA, 0xAA, 0xAA, 0xAA,0xAA, 0xAA, 0xAA, 0xAA,0xAA, 0xAA, 0xAA, 0xAA]) );
}












