
%{
    #include <string>
    #include <iostream>
    extern int yylex (void);
    void yyerror(std::string s);
    int a;
%}
%token EOL
%%
calclist:
 | calclist EOL {a++;}
%%
void yyerror(std::string s){
    std::cerr<<s<<std::endl;
}