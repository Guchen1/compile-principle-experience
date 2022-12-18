
%{
    #include <string>
    #include <iostream>
    extern int yylex (void);
    void yyerror(std::string s);
    int a;
    std::string s;
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
%%
end: YEOF       {return -1;}
    | EOL end
    | statement EOL end 
    | COMMENT EOL end
    | statement COMMENT EOL end
statement:
     ORIGIN IS LPAREN EXP COMMA EXP RPAREN  {std::cout<<"success";return 0;}
    |SCALE IS LPAREN EXP COMMA EXP RPAREN  {std::cout<<"success";return 0;}
    |ROT IS EXP  {std::cout<<"success";return 0;}
    |FOR T FROM EXP TO EXP STEP EXP DRAW LPAREN EXP COMMA EXP RPAREN  {std::cout<<"success";return 0;}
    |FOR T FROM EXP TO EXP DRAW LPAREN EXP COMMA EXP RPAREN  {std::cout<<"success";return 0;}
    
EXP: FACTOR
    | EXP PLUS FACTOR 
    | EXP MINUS FACTOR 

FACTOR: NUMBER
    |  MULTIPLY FACTOR 
    |  DIVIDE FACTOR 
%%
void yyerror(std::string s){
    std::cerr<<s<<std::endl;
}