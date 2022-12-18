%define api.value.type {std::string}
%{
    #include <string>
    #include <iostream>
    #include "../src/expoperate.hpp"
    using std::string;
    extern int yylex (void);
    extern double originx, originy, rotate, scalex, scaley ;
    extern void draw(string start, string end, string step, string x, string y);
    void yyerror(std::string s);
    int a;
    std::string s;
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
%type   EXP FACTOR
%%
end:  YEOF       {return -1;}
    | EOL      {return 0;}
    | space      {return 0;}
    | statement COMMENT EOL  { return 1;}
    | statement EOL   {return 1;}
    | COMMENT EOL  {return 0;}
    | statement COMMENT YEOF  {return 2;}
    | statement YEOF   {return 2;}
    | COMMENT YEOF  {return -1;}
    ;
statement:
     ORIGIN space IS space LPAREN space  EXP space  COMMA space  EXP space  RPAREN space SEMICOLON space  { originx=stod($7);originy=stod($11);}
    |SCALE space IS space LPAREN space  EXP space  COMMA space  EXP space  RPAREN space SEMICOLON space { scalex=stod($7);scaley=stod($11);}
    |ROT space IS space EXP space SEMICOLON space { rotate=stod($5);}
    |FOR space T space FROM space EXP space TO space EXP space STEP space EXP space DRAW space LPAREN space  TEXP space  COMMA space  TEXP space  RPAREN space SEMICOLON  space {draw($7,$11,$15,$21,$25);}
    ;
EXP: FACTOR
    | EXP PLUS FACTOR  {$$=std::to_string(stod($1)+stod($3));}
    | EXP MINUS FACTOR   {$$=std::to_string(stod($1)-stod($3));}
    ;
FACTOR: NUMBER 
    | FACTOR  MULTIPLY NUMBER  {$$=std::to_string(stod($1)*stod($3));}
    | FACTOR DIVIDE NUMBER    {$$=std::to_string(stod($1)/stod($3));}
    ;
TEXP: TFACTOR
    | TEXP PLUS TFACTOR  {if($1.find("T")!=-1||$3.find("T")!=-1) $$=$1+"+"+$3; else $$=std::to_string(stod($1)+stod($3));}
    | TEXP MINUS TFACTOR   {if($1.find("T")!=-1||$3.find("T")!=-1) $$=$1+"-"+$3; else $$=std::to_string(stod($1)-stod($3));}
    ;
TFACTOR: NUMBER|T
    | TFACTOR MULTIPLY NUMBER  {if($1.find("T")!=-1) $$=$1+"*"+$3; else  $$=std::to_string(stod($1)*stod($3));}
    | TFACTOR DIVIDE NUMBER    {if($1.find("T")!=-1) $$=$1+"/"+$3; else  $$=std::to_string(stod($1)/stod($3));}
    | TFACTOR MULTIPLY T       {if($1.find("T")!=-1||$3.find("T")!=-1) $$=$1+"*"+$3; else $$=std::to_string(stod($1)*stod($3));}
    | TFACTOR DIVIDE T         {if($1.find("T")!=-1||$3.find("T")!=-1) $$=$1+"/"+$3; else $$=std::to_string(stod($1)/stod($3));}
    ;
space: 
    | SPACE space
    ;
%%
void yyerror(std::string s){
    std::cerr<<s<<std::endl;
}