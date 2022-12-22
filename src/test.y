%define parse.error verbose
%define parse.lac full
%define api.value.type {std::string}
%{
    #include <string>
    #include <iostream>
    #include <cmath>
    using std::string;
    extern bool filemode;
    extern void clear(void);
    extern void sleep(double time);
    extern int yylex (void);
    extern bool errflag;
    extern void setscale(string a, string b);
    extern void setscale(void);
    extern double originx, originy, rotatenum, scalex, scaley ;
    extern void draw(string start, string end, string step, string x, string y);
    void yyerror(std::string s);
%}
%token EOL
%token NUMBER
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
%token SIN
%token COS
%token TAN
%token EXIT
%token EXPF
%token LN
%token AUTO

%%
end:                    {errflag=false;}
    | statement end  {errflag=false;}
    | Espace end {}
    ;
statement:
      ORIGIN Nspace IS Nspace LPAREN space  EXP space  COMMA space  EXP space  RPAREN space SEMICOLON   { originx=stod($7);originy=stod($11);if(!filemode)std::cout<<"OK, origin is now ("<<originx<<","<<originy<<")"<<std::endl;}
    | SCALE Nspace IS Nspace LPAREN space  EXP space  COMMA space  EXP space  RPAREN space SEMICOLON  { setscale($7,$11); if(!filemode) std::cout<<"OK, scale is now ("<<scalex<<","<<scaley<<")"<<std::endl;}
    | SCALE Nspace IS Nspace   AUTO space SEMICOLON  { setscale(); if(!filemode) std::cout<<"OK, scale is now auto-decided"<<std::endl;}
    | ROT Nspace IS Nspace EXP space SEMICOLON  { rotatenum=stod($5); if(!filemode)std::cout<<"OK, rotate is now "<<rotatenum<<std::endl;}
    | FOR Nspace T Nspace FROM Nspace EXP Nspace TO Nspace EXP Nspace STEP Nspace EXP Nspace DRAW space LPAREN space  TEXP space  COMMA space  TEXP space  RPAREN space  SEMICOLON {draw($7,$11,$15,$21,$25);}
    | SLEEP Nspace EXP space SEMICOLON {sleep(stod($3));}
    | CLEAR space SEMICOLON {clear();}
    | EXIT space SEMICOLON {return 0;}
    | SEMICOLON {}
    ;
EXP: FACTOR
    | EXP PLUS FACTOR  {$$=std::to_string(stod($1)+stod($3));}
    | EXP MINUS FACTOR   {$$=std::to_string(stod($1)-stod($3));}
    ;
FACTOR: POW
    | FACTOR  MULTIPLY POW  {$$=std::to_string(stod($1)*stod($3));}
    | FACTOR DIVIDE POW    {$$=std::to_string(stod($1)/stod($3));}
    ;
POW: FUNC
    | POW POWER FUNC  {$$=std::to_string(pow(stod($1),stod($3)));}
    ;
FUNC: digit
    | SIN LPAREN EXP RPAREN  {$$=std::to_string(sin(stod($3)));}
    | COS LPAREN EXP RPAREN  {$$=std::to_string(cos(stod($3)));}
    | TAN LPAREN EXP RPAREN  {$$=std::to_string(tan(stod($3)));}
    | LN LPAREN EXP RPAREN  {$$=std::to_string(log(stod($3)));}
    | EXPF LPAREN EXP RPAREN  {$$=std::to_string(exp(stod($3)));}
    ;
digit: number
    |  MINUS number  {$$='-'+$2;}
    |  LPAREN  EXP  RPAREN  {$$=$2;}
    ;
TEXP: TFACTOR
    | TEXP PLUS TFACTOR  { $$=$1+"+"+$3;}
    | TEXP MINUS TFACTOR   { $$=$1+"-"+$3; }
    ;
TFACTOR: TPOW
    | TFACTOR MULTIPLY TPOW      {$$=$1+"*"+$3; }
    | TFACTOR DIVIDE TPOW        { $$=$1+"/"+$3; }
    ;
TPOW: TFUNC
    | TPOW POWER TFUNC  {$$=$1+"**"+$3;}
    ;
TFUNC: Tdigit
    | SIN LPAREN TEXP RPAREN  {$$="sin("+$3+")";}
    | COS LPAREN TEXP RPAREN  {$$="cos("+$3+")";}
    | TAN LPAREN TEXP RPAREN  {$$="tan("+$3+")";}
    | LN LPAREN TEXP RPAREN  {$$="log("+$3+")";}
    | EXPF LPAREN TEXP RPAREN  {$$="exp("+$3+")";}
    ;
Tdigit: T|number
    |  MINUS  number  {$$='-'+$2;}
    |  MINUS  T  {$$='-'+$2;}
    |  LPAREN  TEXP  RPAREN  {$$=$2;}
    ;
number: NUMBER
    | PI {$$=string("3.141592653");}
    | E {$$=string("2.718281828");}
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
