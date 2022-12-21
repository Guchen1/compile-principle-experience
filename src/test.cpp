#include <iostream>
#include <windows.h>
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <string>
#include "universal.hpp"
#include <thread>
#include <map>
#include <mutex>
#include "matplotlibcpp.h"
std::mutex some_mutex;
namespace plt = matplotlibcpp;
bool errflagx = false;
bool errflag = false;
bool filemode = false;
extern int words, chars, lines, a;
extern int yyparse(void);
double originx, originy, rotatenum, scalex = 1, scaley = 1;
extern string s;
extern FILE *yyin;
int countp = 1;
void loop(int num, double i, string d, string e, map<int, pair<double, double>> &m, int &flag)
{

    double rawx = eval_fromPython(subreplace(subreplace(to_lowercase(d), "t", to_string(i)), "ln", "log"));
    double rawy = eval_fromPython(subreplace(subreplace(to_lowercase(e), "t", to_string(i)), "ln", "log"));
    double x = (rawx * cos(rotatenum) + rawy * sin(rotatenum)) * scalex + originx;
    double y = (rawy * cos(rotatenum) - rawx * sin(rotatenum)) * scaley + originy;
    m.insert(pair<int, pair<double, double>>(num, pair<double, double>(x, y)));
}
void drawthread(map<int, pair<double, double>> m)
{
    vector<double> x, y;
    for (auto item : m)
    {
        x.push_back(item.second.first);
        y.push_back(item.second.second);
    }
    plt::plot(x, y, {{"label", "line" + to_string(countp++)}});
    plt::legend();
    plt::pause(0.1);
}
void sleep(double a)
{
    plt::pause(a);
    cout << "OK" << endl;
}
void clear()
{
    plt::clf();
    plt::pause(0.1);
    plt::ioff();
    plt::pause(0.1);
    plt::ion();
    countp = 1;
    std::cout << "OK,clear the draw" << std::endl;
}
void draw(string a, string b, string c, string d, string e)
{
    map<int, pair<double, double>> m;
    int flag = 1;
    int num = 0;
    // 检查是否为死循环
    double da = stod(a), db = stod(b), dc = stod(c);
    if (dc == 0)
    {
        cout << "Error:the step is 0" << endl;
        return;
    }
    if (da > db)
    {
        if (dc > 0)
        {
            cout << "Error:the step is wrong" << endl;
            return;
        }
    }
    else
    {
        if (dc < 0)
        {
            cout << "Error:the step is wrong" << endl;
            return;
        }
    }
    cout << "Waiting..." << endl;
    for (double i = da; i <= db; i += dc)
    {
        loop(num, i, d, e, m, flag);
        if (errflagx)
        {
            errflagx = false;
            cout << 1;
            return;
        }
        num++;
    }
    // thread t(drawthread, m);
    // t.detach();
    drawthread(m);
    cout << "OK" << endl;
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
    Py_SetPythonHome(Str2Wstr(python).c_str());
    Py_Initialize();
    dess = PyModule_GetDict(PyImport_AddModule("__main__"));
    PyRun_SimpleString("from math import *");
    plt::ion();
    cout << "Loaded,welcome to use the program" << endl;
    yyparse();
    cin.get();
}
