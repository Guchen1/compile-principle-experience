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
    extern void sleepx(double time);
    extern int yylex (void);
    extern bool errflag;
    extern void setscale(string a, string b);
    extern void setscale(void);
    extern double originx, originy, rotatenum, scalex, scaley ;
    extern void draw(string start, string end, string step, string x, string y);
    extern void yyerror(std::string s);
%}
%token EOL NUMBER PLUS MINUS MULTIPLY DIVIDE POWER LPAREN RPAREN YEOF STRING ORIGIN SCALE ROT IS TO STEP DRAW FOR FROM COMMENT COMMA T SPACE SEMICOLON PI E ERRORN CLEAR SLEEP SIN COS TAN EXIT EXPF LN AUTO

%%
end:                    {errflag=false;}
    | statement end  {errflag=false;}
    | Espace end {}
    ;
statement:
      ORIGIN Nspace IS Nspace LPAREN space  EXP space  COMMA space  EXP space  RPAREN space SEMICOLON   { originx=stod($7);originy=stod($11);if(!filemode)std::cout<<"OK, origin is now ("<<originx<<","<<originy<<")"<<std::endl;}
    | SCALE Nspace IS Nspace LPAREN space  EXP space  COMMA space  EXP space  RPAREN space SEMICOLON  { if(std::stod($7)>0&&std::stod($11)>0) setscale($7,$11); else if(!filemode) std::cout<<"Error: Scale can not be below zero"; if(!filemode) std::cout<<"OK, scale is now ("<<scalex<<","<<scaley<<")"<<std::endl;}
    | SCALE Nspace IS Nspace   AUTO space SEMICOLON  { setscale(); if(!filemode) std::cout<<"OK, scale is now auto-decided"<<std::endl;}
    | ROT Nspace IS Nspace EXP space SEMICOLON  { rotatenum=stod($5); if(!filemode)std::cout<<"OK, rotate is now "<<rotatenum<<std::endl;}
    | FOR Nspace T Nspace FROM Nspace EXP Nspace TO Nspace EXP Nspace STEP Nspace EXP Nspace DRAW space LPAREN space  TEXP space  COMMA space  TEXP space  RPAREN space  SEMICOLON {draw($7,$11,$15,$21,$25);}
    | SLEEP Nspace EXP space SEMICOLON {sleepx(stod($3));}
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
