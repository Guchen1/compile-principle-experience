%define parse.error verbose
%define parse.lac full
%define api.value.type {std::string}
%{
    #include <string>
    #include <iostream>
    #include <cmath>
    #include "../src/expoperate.hpp"
    using std::string;
    extern void clear(void);
    extern void sleep(double time);
    extern int yylex (void);
    extern bool errflag;
    extern double originx, originy, rotate, scalex, scaley ;
    extern void draw(string start, string end, string step, string x, string y);
    void yyerror(std::string s);
%}
%token EOL
%token  NUMBER
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE
%token POWER
%token LPAREN
%token RPAREN
%token YEOF
%token STRING
%token ORIGIN
%token SCALE
%token ROT
%token IS
%token TO
%token STEP
%token DRAW
%token FOR
%token FROM
%token COMMENT
%token COMMA
%token T
%token SPACE
%token SEMICOLON
%token PI
%token E
%token ERRORN
%token CLEAR
%token SLEEP
%type   EXP FACTOR

%%
end:                    {errflag=false;}
    | statement end  {errflag=false;}
    | Espace end {}
    ;
statement:
      ORIGIN Nspace IS Nspace LPAREN space  EXP space  COMMA space  EXP space  RPAREN space SEMICOLON   { originx=stod($7);originy=stod($11);std::cout<<"OK,the origin is now ("<<originx<<","<<originy<<")"<<std::endl;}
    | SCALE Nspace IS Nspace LPAREN space  EXP space  COMMA space  EXP space  RPAREN space SEMICOLON  { scalex=stod($7);scaley=stod($11); std::cout<<"OK,the scale is now ("<<scalex<<","<<scaley<<")"<<std::endl;}
    | ROT Nspace IS Nspace EXP space SEMICOLON  { rotate=stod($5); std::cout<<"OK,the rotate is now "<<rotate<<std::endl;}
    | FOR Nspace T Nspace FROM Nspace EXP Nspace TO Nspace EXP Nspace STEP Nspace EXP Nspace DRAW space LPAREN space  TEXP space  COMMA space  TEXP space  RPAREN space  SEMICOLON {draw($7,$11,$15,$21,$25);}
    | SLEEP Nspace EXP space SEMICOLON {sleep(stod($3));}
    | CLEAR space SEMICOLON {clear();}
    ;
EXP: FACTOR
    | EXP PLUS FACTOR  {$$=std::to_string(stod($1)+stod($3));}
    | EXP MINUS FACTOR   {$$=std::to_string(stod($1)-stod($3));}
    ;
FACTOR: pow
    | FACTOR  MULTIPLY pow  {$$=std::to_string(stod($1)*stod($3));}
    | FACTOR DIVIDE pow    {$$=std::to_string(stod($1)/stod($3));}
    ;
pow: digit
    | pow POWER digit  {$$=std::to_string(pow(stod($1),stod($3)));}
    ;
digit: NUMBER
    |  MINUS NUMBER  {$$='-'+$2;}
    |  LPAREN  EXP  RPAREN  {$$=$2;}
    ;
TEXP: TFACTOR
    | TEXP PLUS TFACTOR  {if($1.find("T")!=-1||$3.find("T")!=-1) $$=$1+"+"+$3; else $$=std::to_string(stod($1)+stod($3));}
    | TEXP MINUS TFACTOR   {if($1.find("T")!=-1||$3.find("T")!=-1) $$=$1+"-"+$3; else $$=std::to_string(stod($1)-stod($3));}
    ;
TFACTOR: Tpow
    | TFACTOR MULTIPLY Tpow      {if($1.find("T")!=-1||$3.find("T")!=-1) $$=$1+"*"+$3; else $$=std::to_string(stod($1)*stod($3));}
    | TFACTOR DIVIDE Tpow        {if($1.find("T")!=-1||$3.find("T")!=-1) $$=$1+"/"+$3; else $$=std::to_string(stod($1)/stod($3));}
    ;
Tpow: Tdigit
    | Tpow POWER Tdigit  {if($1.find("T")!=-1||$3.find("T")!=-1)$$=$1+"**"+$3;else $$=std::to_string(pow(stod($1),stod($3)));}
    ;
Tdigit: T|NUMBER
    |  MINUS  NUMBER  {$$='-'+$2;}
    |  MINUS  T  {$$='-'+$2;}
    |  LPAREN  TEXP  RPAREN  {$$=$2;}
    ;
space: 
    | SPACE space
    | COMMENT  space
    | EOL space {}
    ;
Nspace: SPACE space
    | COMMENT space
    | EOL space {}
    ;
Espace: SPACE 
    | COMMENT 
    | EOL  {}
    ;

%%
