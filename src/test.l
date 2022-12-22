%option noyywrap
%option yylineno
%option batch
%option case-insensitive
%{
    #include<iostream>
    #include"type.h"
    extern std::string yylval;
    extern bool errflag;
    extern void yyerror(std::string s);
    extern bool filemode;

%}
digit [0-9]
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
sleep     {if(!filemode)return SLEEP;else return ERRORN;}
clear   {if(!filemode)return CLEAR;else return ERRORN;}
exit     {if(!filemode)return EXIT;else return ERRORN;}
sin      {return SIN;}
cos      {return COS;}
tan      {return TAN;}
exp      {return EXPF;}
ln       {return LN;}
pi       {return PI;}
e        {return E;}
auto    {return AUTO;}
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
{digit}+("."{digit}*)?    {yylval=yytext;return NUMBER;}
\n        {errflag=false;return EOL;}
" "     {return SPACE;}
<<EOF>>   {return YYEOF;}
[^ \n(),*-+/0-9;]*         {return ERRORN;}
%%

