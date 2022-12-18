#ifndef EXPOPERATE_H
#define EXPOPERATE_H
#include <string>
#include <cstdio>
#include <windows.h>
using namespace std;
class expoperate
{
private:
    string expression;
    string commandmain = string("from math import *;print(eval('" + expression + "')");
    string head = "set PYTHONHOME=C:/Users/10237/AppData/Local/Programs/Python/Python310/";
    string subhead = "&&C:/Users/10237/AppData/Local/Programs/Python/Python310/python -c";
    string cmdLine;

public:
    expoperate(string s)
    {
        expression = s;
        commandmain = string("from math import *;print(eval('" + expression + "')");
        cmdLine = head + subhead + '"' + commandmain + '"' + ")";
    }
    void update(string s)
    {
        expression = s;
        commandmain = string("from math import *;print(eval('" + expression + "')");
        cmdLine = head + subhead + '"' + commandmain + '"' + ")";
    }
    double getresult()
    {
        FILE *pf = NULL;
        pf = _popen(cmdLine.c_str(), "r");
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
        return stod(ret);
    }
};
#endif