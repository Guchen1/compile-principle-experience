#define _CRT_STDIO_ISO_WIDE_SPECIFIERS
#define MGL_STATIC_DEFINE
#include <iostream>
#include "expoperate.hpp"
#include <cstdio>
#include <string>
#include <windows.h>
// #include <mgl2/mgl.h>
using namespace std;
bool errflag = false;
extern int words, chars, lines, a;
extern int yyparse(void);
double originx, originy, rotate, scalex = 1, scaley = 1;
extern string s;
extern FILE *yyin;
string subreplace(string resource_str, string sub_str, string new_str);
string getpython()
{
    FILE *pf = NULL;
    pf = _popen("which python", "r");
    if (NULL == pf)
    {
        printf("open pipe failed");
        return 0;
    }
    char buffer[1024] = {'\0'};
    std::string ret;
    while (fgets(buffer, sizeof(buffer), pf))
    {
        ret += buffer;
    }
    _pclose(pf);
    string a = ret;
    if (a == "")
    {
        system("cls");
        cout << "No python found!";
        cin.get();
        exit(1);
    }
    a = a.substr(0, a.find('\n'));
    return a;
}
const string python = subreplace(getpython().substr(0, getpython().length() - 10), "\\", "/");
void draw(string a, string b, string c, string d, string e)
{

    for (double i = stod(a); i <= stod(b); i += stod(c))
    {
        double x = expoperate(subreplace(d, "T", std::to_string(i))).getresult() + originx;
        double y = expoperate(subreplace(e, "T", std::to_string(i))).getresult() + originy;
        std::cout << x << " " << y << std::endl;
    }
}
string subreplace(string resource_str, string sub_str, string new_str)
{
    string dst_str = resource_str;
    int pos = 0;
    while ((pos = dst_str.find(sub_str)) != std::string::npos) // 替换所有指定子串
    {
        dst_str.replace(pos, sub_str.length(), new_str);
    }
    return dst_str;
}
void yyerror(std::string s)
{
    string xx;
    if (errflag == false)
        std::cout << s << std::endl;
    errflag = true;
    yyparse();
}
int main()
{
    yyparse();
    cin.get();
}
