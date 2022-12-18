%option noyywrap
%option batch
%option case-insensitive
%{
    #include<iostream>
    #include"type.h"
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
"**"         {return POWER;}
","             {return COMMA;}
"//"+.*    {return COMMENT;}//ignore comments

origin    {std::cout<<yytext; return ORIGIN;}
scale     {return SCALE;}
rot       {return ROT;}
for       { return FOR; }
is       {std::cout<<yytext;return IS;}
from      {return FROM;}
to        {return TO;}
step      {return STEP;}
draw      {return DRAW;}
T       {return T;}
[0-9]+    {return NUMBER;}
\n        {chars++;lines++;return EOL;}
<<EOF>>   {return YEOF;}
%%

