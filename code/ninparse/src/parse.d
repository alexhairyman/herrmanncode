import pegged.grammar;
import std.stdio;


mixin(grammar(`
Ninja:

  NinjaState <- ( (VarRef / VarAssign ) "\n"? )*

  VarRef <- VarStart ( ('{'? VarIdentifier '}'?) / VarStart / ':' / ' ' )

  VarAssign <- VarIdentifier spacing* '=' spacing* Value


  Value <- StringLiteral / FloatLiteral / IntegerLiteral / CharLiteral
  
  IntegerLiteral
  StringLiteral < doublequote String doublequote


  String <- ~(Char)*

  VarStart <- '$'

  VarIdentifier <- identifier

  CharLiteral <~ quote Char quote

  IntegerLiteral <~ Sign? Integer IntegerSuffix?

  Integer <~ digit+

  IntegerSuffix <- "Lu" / "LU" / "uL" / "UL"
                 / "L" / "u" / "U"

  FloatLiteral <~ Sign? Integer ( "." Integer )? (("e" / "E") Sign? Integer)?

  Sign <- "-" / "+"

  Char <- EscapeSequence
        / !doublequote .

  EscapeSequence <- backslash ( 't' / 'n' / 'v' )
  
`));

// I am so lazy
alias wl = writeln;

/// NinjaParseDebugTree
void NPDT(in string msg, in string[] ins)
{
  wl("\n\n" ~ msg);
  foreach(string x; ins)
  {
    wl("\nTree for: [" ~ x ~ "] is");
    wl(Ninja(x));
  }
}
unittest
{

  enum VarRefStrings = ["$HELLO", "${HELLO}", "$ { HELLO    }", "$    HELLO", "$:" , "$$", "$$AYO" , "$ sup", "$   " ];
  enum VarAssignStrings = [`Hello="HIThERE"`, `hi = "sdad"`, `hi =  "sads`, `hi = " asd  asd dsdas  sda   "  " dsda"`,
  `he4 = 65`, `he5 = 4..33`, `h2e = 5.44`, `  char = '3'`, `ch3_3 = 'a'`, `blar = 't'`];


  NPDT("Variable reference test", VarRefStrings);
  NPDT("Assignment test", VarAssignStrings);


//  foreach(string x; VarRefStrings)
//  {
//    wl("\n\nTree for: [" ~ x ~ "] is");
//    wl(Ninja(x));
//  }

}

void main(string[] args)
{
  writeln("This file contains the grammars for the following languages:
Ninja");
}