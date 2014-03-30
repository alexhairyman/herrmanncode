#!rdmd
import std.stdio, std.file, std.path; // for basic file utilities
import std.algorithm; // for array stuff
import std.getopt; // parsing command line arguments
import std.zlib; // for decompressing the codepage file
import std.net.curl; // for downloading additional code pages
import std.json; // for parsing the config file
pragma(lib, "curl");
//pragma(lib, "z");

class Parser
{
private:

  string instring_;
//  alias ubyte[] reptype;
  ubyte[][ubyte[]] replaces_; /// this contains all the chars that should be replaced with their unicode counterparts

public:

  this(string input)
  {
    this.instring_ = input;
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
  }


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

debug=m_parser;

