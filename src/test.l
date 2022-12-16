%option noyywrap
%option batch
%{
    #include<iostream>
    #include"type.h"
    int chars=0;
    int words=0;
    int lines=0;
%}
%%
[a-zA-Z]+ {words++ ; chars+=strlen(yytext) ;}
\n        {chars++;lines++;return EOL;}
.         {chars++;}
%%

