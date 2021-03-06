/*
   this is used to test the speed of reading writing using different formats
   msgpack (not really a database), and tokyo cabinet are first
   recursively gets md5sums for all of the files in the head directory passed, and then 
   writes and reads with each database

   also performs a simple test using multiple threads instead of just running serially
*/

import std.digest.md;
import std.file, std.path, std.stdio, std.parallelism;
import core.thread, core.time, core.sync.mutex;
import msgpack;

debug(1)
{
//  debug = l; // lock
//  debug = m; // md5
//  debug = p; // path
//  debug = td; // tdigest
}

alias md5t = ubyte[16];
__gshared Mutex hashlock;
__gshared Mutex iolock;
__gshared md5t[string] hashes;
static 
{
//  Mutex hashlock;
  string[] file_paths;

  md5t[string] shashes;
//  md5t[string] hashes;

  int hashgathered;
  const int threadmax = 3;
}


void tdigest(string path)
{
  try
  {
    MD5Digest thismd = new MD5Digest();
    md5t thash;
    
    thismd.reset();
    debug(td) writefln("reading %s", baseName(path));
    thismd.put(cast(ubyte[]) read(path));
    
    thash = thismd.finish();
    debug(td) writefln("boohoo");
    
    debug(m) synchronized(iolock) writefln("hash of %s is %s", baseName(path), toHexString(thash));
    synchronized(hashlock) { hashes[path] = thash;}
  }
  catch (FileException fe) { writefln("can't read %s !", baseName(path)); }
  catch (SyncException se) { writeln("Sync Exception"); }
  return;
}

void main(string[] args)
{
  hashlock = new Mutex;
  iolock = new Mutex;
  Mutex diglock = new Mutex();
  writeln("beginning");
  
  synchronized(hashlock)
  {
    hashgathered = 0;
  }

  alias file_paths ifp;
  writeln("arguments:");
  writeln(args);
  if (args.length == 1)
  {
    writeln("Need path argument");
    return;
  }
  string path = args[1];
  writefln("checking if %s is path", path);
  if(exists(path) && isDir(path))
  {
    uint number = 0;
    writeln("path is good, iterating over all the files now");
    foreach(DirEntry d; dirEntries(path, SpanMode.depth, false))
    {
      if(d.isFile() && getSize(d.name) < (32 * 1024 * 1024))
      {
	      number++;
	      ifp ~= d.name;
      }
    }
    
    writefln("%d files iterated over, and %d entries in file_paths", number, ifp.length);
    writefln("doing md5 sums serially first");

    MD5 serialmd;
    TickDuration start = TickDuration.currSystemTick();
    foreach(string s; ifp)
    {
      try
      {
	      md5t thash;
//      	debug(p) synchronized(iolock) writefln("parsing %s", baseName(s));
      	serialmd.start();
      	serialmd.put(cast(ubyte[]) read(s));
      	thash = serialmd.finish();
      	debug(m) synchronized(iolock) writefln("hash of %s : %s", baseName(s), toHexString(thash));
      	synchronized(hashlock) shashes[s] = thash;
      }
      catch (FileException fe)
      {
	      writef("can't read %s !\n", baseName(s));
      }
    }
    TickDuration end = TickDuration.currSystemTick() - start;
    writefln("hashes all gathered, %d hashes in array, took %d milliseconds", shashes.length, end.msecs);

    writefln("doing md5 sums in parallel with %d threads", threadmax);

    TaskPool tp = new TaskPool(2);
    start = TickDuration.currSystemTick();
    
    ulong numtogo = ifp.length;

    foreach(string s ; parallel(ifp, 2))
    {
      debug(p) synchronized(iolock) writefln("path: %s", s);
      tdigest(s);
//      auto t = task(&tdigest, s);
//      tp.put(t);
    }
    tp.finish();
    end = TickDuration.currSystemTick() - start;
    writeln("\ntask parallel should be done");
    writefln("parallel hashes all gathered, %d hashes in array, took %d milliseconds", hashes.length, end.msecs);

    //writefln("comparing hash db, serial has %d keys, parallel has %s keys", shashes.keys.length, hashes.keys.length);
    foreach(string s ; shashes.keys)
    {
      if(shashes[s] != hashes[s])
        writefln("%s has two different hashes in serial and parallel", baseName(s));
      else
      {
        debug(p) writefln("serial: %s parallel: %s of %s", toHexString(hashes[s]), toHexString(hashes[s]), baseName(s));
      }
    }
  }
  else {writeln("Argument isn't a directory, aborting"); return;}
}
