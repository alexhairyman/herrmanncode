import yml = dyaml.all;
import sio = std.stdio;

string[string] dat;
void main()
{
  // first lets load the file
  sio.writeln("loading yaml file...");
  yml.Node root = yml.Loader("dgcode.package.yaml").load();
  //sio.writeln("dumping yaml, ugly");
  //sio.writeln(root);

  string[] root_infos = ["name","targetType","targetName","targetPath"];
  
  foreach(string s; root_infos)
  {
    //sio.writefln("filling %s...", s);
    dat[s] = root[s].as!string;
    sio.writefln("now in memory %s = [%s]", s, dat[s]);
  }
  
  foreach(yml.Node spkg; root["subPackages"])
  {
    string name = spkg["name"].as!string;
    string[string] dependencies;
    string[] vers;

    foreach(ref yml.Node key, ref yml.Node val; spkg["dependencies"])
    {
      dependencies[key.as!string] = val.as!string;
    }

    foreach(ref yml.Node ver; spkg["versions"])
    {
      vers ~= ver.as!string;
    }
    
    sio.writefln("---\n"
		 "subpackage = %s\n"
		 "versions=%s\n"
		 "deps=%s", name, vers, dependencies);
    sio.writefln("###\n"
		 "spkg[name] = %s\n"
		 "spkg[versions] = %s" , spkg["name"], spkg["versions"]);
  }
  
}
