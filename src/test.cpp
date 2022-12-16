#include <iostream>
#include <cstdio>
#include <string>
using namespace std;
extern int words, chars, lines,a;
extern int yylex (void),yyparse (void);
extern FILE* yyin;
int main()
{
    yyin=fopen("1.txt","r");
    yyparse();
    cout << a;
}
