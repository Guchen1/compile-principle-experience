%option noyywrap
%option batch
%option case-insensitive
%{
    #include "../src/expoperate.hpp"
    #include<iostream>
    #include"type.h"
    extern std::string yylval;
    int chars=0;
    int words=0;
    int lines=0;

%}
%%
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
origin    { return ORIGIN;}
scale     {return SCALE;}
rot       {return ROT;}
for       { return FOR; }
is       {return IS;}
from      {return FROM;}
to        {return TO;}
step      {return STEP;}
draw      {return DRAW;}
T       {yylval=yytext;return T;}
[0-9]+    {yylval=yytext;return NUMBER;}
\n        {chars++;lines++;return EOL;}
[ ]     {return SPACE;}
<<EOF>>   {return YEOF;}
%%

