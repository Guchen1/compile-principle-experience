%option noyywrap
%option batch
%option case-insensitive
%{
    #include "../src/expoperate.hpp"
    #include<iostream>
    #include"type.h"
    extern std::string yylval;
    extern bool errflag;
    extern void yyerror(std::string s);
    extern bool filemode;
    int chars=0;
    int words=0;
    int lines=0;

%}
%%
origin    { return ORIGIN;}
scale     {return SCALE;}
rot       {return ROT;}
for       { return FOR; }
is       {return IS;}
from      {return FROM;}
to        {return TO;}
step      {return STEP;}
draw      {return DRAW;}
sleep     {if(!filemode)return SLEEP;}
clear   {if(!filemode)return CLEAR;}
\+         {return PLUS;}
\-         {return MINUS;}
\*         {return MULTIPLY;}
\/         {return DIVIDE;}
\(         {return LPAREN;}
\)         {return RPAREN;}
";"      {return SEMICOLON;}
"**"         {return POWER;}
","             {return COMMA;}
("//"|"--")+.*    {return COMMENT;}//ignore comments
T       {yylval=yytext;return T;}
[0-9]+    {yylval=yytext;return NUMBER;}
\n        {errflag=false;return EOL;}
" "     {return SPACE;}
<<EOF>>   {return YYEOF;}
[^ \n(),*-+/0-9;]*         {return ERRORN;}
%%

