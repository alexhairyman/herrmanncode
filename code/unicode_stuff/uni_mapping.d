#!rdmd
import std.stdio, std.file, std.path; // for basic file utilities
import std.algorithm; // for array stuff
import std.array;
import std.string;
import std.format;
import std.getopt; // parsing command line arguments
import std.zlib; // for decompressing the codepage file
import std.net.curl; // for downloading additional code pages
import std.json; // for parsing the config file
pragma(lib, "curl");

//debug {
//  debug = parser_foreach;
//}

//debug = parser_foreach;
debug = 1;
class Parser
{

version(DEBUG_PUBLIC)
{
public :
}


  bool parsed_;
  string instring_;
//  alias ubyte[] reptype;
//  ubyte[][ubyte[]] replaces_; /// this contains all the chars that should be replaced with their unicode 
  ushort[ubyte] replaces_;
  string[string] debug_replace;
//  int[int] replaces_;

public:

  this(string input_map)
  {
    this.instring_ = input_map.idup;
  }

  string Convert(in ubyte[] instring)
  {
    string ustring_out;
    for(int i = 0; i < instring.length; i++)
    {
      ustring_out ~= this.replaces_[instring[i]];
    }
    
    return ustring_out;
  }
  
  void Parse()
  {

    debug(parse_wholefile) writefln("parsing:\n%s\nnow", this.instring_);
    string[] lines;
    string tstr;
    foreach(char s; instring_)
    {
//      debug(parser_foreach) writeln(s);
      if(s == '\n') {
	      lines ~= tstr;
	      debug(parser_foreach) writefln("[%s] added to tstr", tstr);
	      tstr = [];
      } else {
	      tstr ~= s;
      }
    }
    
    foreach(string s; lines)
    {
      auto ln = split(s, '#');
      foreach(size_t i,  string col; ln)
      {
//        debug(parser_foreach) writefln("[%s] col %d", col, i);
//        debug(parser_foreach) writeln(ln[0]);
        
        string[] blah = split(ln[0], '\t');
        debug(parser_foreach)
        {
          
          if(blah.length == 3){writeln("\n",blah.length); writeln(blah[0..$-1]);}
        }
        if( blah.length == 3) this.debug_replace[blah[0]] = blah[1];
      }
    }
    
    foreach(from, to; this.debug_replace)
    {
      ubyte f;
      ushort t;
      formattedRead(from, "0x%x", &f);
      formattedRead(to, "0x%x%x", &t);
      this.replaces_[f] = t;
    }
    
    debug(parser_replaces)
    {
      foreach(ubyte[] from, ubyte[] to; this.debug_replace)
      {
        writefln("\n%-6s->%8s", from, to);
        int f,t;
        formattedRead(from, "0x%x", &f);
        formattedRead(to, "0x%x%x", &t);
        writefln("%-6d->%8d", f,t);
      }
    }
    this.parsed_ = true;
  }
}

version = DEBUG_PUBLIC;
unittest
{
  writeln("parsing codepage 437");
  Parser cp437_parser = new Parser(cast(string) std.file.read("mappings/CP437.txt"));
  cp437_parser.Parse();
  ubyte[] t1 = cast(ubyte[]) "\xEF\xEE\xED";
  writefln("%(%x%) -> %(%x%)", t1, cast(ubyte[]) cp437_parser.Convert(t1));
}

void main(string[] args)
{
  writeln("Tool to convert a unicode transformation table (right now just code pages) to a d source file");

  string json_config_file = "uni.json";
  bool do_download = false;
  string group_name = null;
  bool dont_remove = false;

  getopt(args,
         "config|c", &json_config_file,
         "download|d", &do_download,
         "group|g", &group_name,
         "dont-remove", &dont_remove
    );

  if(!exists(json_config_file)) {
    writeln("ERR: config file %s not there, exiting", absolutePath(json_config_file));
    return;
  }
  else {
    writefln("config file %s found", absolutePath(json_config_file));
  }

  JSONValue json_config = parseJSON(cast(ubyte[]) read(json_config_file));
  size_t[string] groups;
  foreach(size_t i, JSONValue tjv; json_config["mappings"])
  {
    groups[tjv["name"].str] = i;
    debug(json) writefln("%s", tjv["name"].str);
  }

  debug(json) writefln("%d groups", groups.length);

//  foreach(JSON

  debug(json) writeln(args);
  if(do_download){
    writeln("downloading group mappings");
  }
  if( group_name == null && args.length >= 2) group_name = args[1];
  else writeln("ERR: no group specified");

  debug(json) writefln("group %s", group_name);
  if(canFind(groups.keys, group_name)) writefln("%s found! now performing actions", group_name);
  else { writefln("%s not found", group_name);return; }

  if(do_download)
  {
    mkdirRecurse("mappings");
    string complete_base_url = json_config["baseurl"].str ~ json_config["mappings"][ groups[group_name] ]["base"].str;
    foreach(JSONValue s; json_config["mappings"][ groups[group_name] ]["files"].array)
    {
      try 
      {
        debug(json) writefln("complete url: %s", complete_base_url ~ s.str);
//        std.file.write("mappings/" ~ s.str ~ ".z", compress(get(complete_base_url ~ s.str), 9) );
        writefln("downloading %s", complete_base_url ~ s.str);
        std.file.write("mappings/" ~ s.str, get(complete_base_url ~ s.str) );
      }
      catch(CurlException e)
      {
        writefln("couldn't download %s", s.str);
        writeln(e.msg);
      }
    }
  }

  if(!dont_remove && exists("mappings"))
    rmdirRecurse("mappings");

  debug(m_parser)
  {
    writeln("parsing codepage 437");
    Parser cp437_parser = new Parser(cast(string) std.file.read("mappings/CP437.txt"));
    cp437_parser.Parse();
  }

}

//debug=m_parser;

