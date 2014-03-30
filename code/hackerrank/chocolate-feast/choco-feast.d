// fulfills hackerrank chocolate feast problem

module chocofeast;
string[] sample_input = ["10 2 5", "12 4 4", "6 2 2"];

import std.stdio;
import std.algorithm;

void main()
{
  foreach(string x; sample_input)
  {
    debug writefln("parsing string: %s", x);
    auto snums = splitter(x, ' ');
    debug writefln("type is %s", typeid(snums));
    int[3] params;

    foreach (size_t i, string x2; snums)
    {
      params[i] = to!int(x2);
      debug writefln("%d:", to!int(x2));
    }

    debug writefln("params = %s", params);
  }
}
