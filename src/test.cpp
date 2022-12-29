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
extern int yylineno;
bool errflagx = false;
bool errflag = false;
bool filemode = false;
extern int yyparse(void);
double originx, originy, rotatenum, scalex = 1, scaley = 1;
extern FILE *yyin;
int countp = 1;
void loop(int num, double i, string d, string e, map<int, pair<double, double>> &m, int &flag)
{

    double rawx = eval_fromPython(subreplace(subreplace(to_lowercase(d), "t", to_string(i)), "ln", "log"));
    double rawy = eval_fromPython(subreplace(subreplace(to_lowercase(e), "t", to_string(i)), "ln", "log"));
    double x = (rawx * cos(rotatenum) + rawy * sin(rotatenum)) + originx;
    double y = (rawy * cos(rotatenum) - rawx * sin(rotatenum)) + originy;
    m.insert(pair<int, pair<double, double>>(num, pair<double, double>(x, y)));
}
void setscale(string a, string b)
{
    scalex = stod(a);
    scaley = stod(b);
    plt::set_aspect(scaley / scalex);
    if (filemode == false)
        plt::pause(0.5);
}
void setscale()
{
    plt::set_aspect(0);
    if (filemode == false)
        plt::pause(0.5);
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
    if (filemode == false)
        plt::pause(0.5);
}
void sleep(double a)
{
    plt::pause(a);
    cout << "Sleep OK" << endl;
}
void clear()
{
    plt::clf();
    plt::pause(0.5);
    plt::ioff();
    plt::pause(0.5);
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
    if (filemode == false)
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
        if (i + dc > db && i < db)
        {
            loop(num, db, d, e, m, flag);
            if (errflagx)
            {
                errflagx = false;
                return;
            }
        }
        num++;
    }

    // thread t(drawthread, m);
    // t.detach();
    drawthread(m);
    if (!filemode)
        cout << "Drawing OK" << endl;
}

void yyerror(std::string s)
{
    s = subreplace(s, "ERRORN", "character");
    if (filemode)
    {
        cout << "Error:" << s << " at line " << yylineno << endl;
        exit(0);
    }
    if (errflag == false)
        std::cout << "Error:" << s << std::endl;
    errflag = true;
    yyparse();
}
int main(int argc, char *argv[])
{
    Py_SetPythonHome(Str2Wstr(python).c_str());
    Py_Initialize();
    dess = PyModule_GetDict(PyImport_AddModule("__main__"));
    PyRun_SimpleString("from math import *");
    plt::set_aspect(scaley / scalex);
    if (argc == 2 || argc == 3)
    {
        filemode = true;
        auto files = fopen(argv[1], "r");
        if (files == NULL)
        {
            cout << "Error:the file is not exist" << endl;
            return 0;
        }
        yyin = files;
        yyparse();
        try
        {
            if (argc == 3)
            {
                plt::save(argv[2]);
            }
            else
            {
                string tempfile;
                if (string(argv[1]).find(".") != string::npos)
                    tempfile = string(argv[1]).substr(0, string(argv[1]).find("."));
                else
                    tempfile = string(argv[1]);
                plt::save(tempfile + string(".png"));
            }
        }
        catch (std::runtime_error e)
        {
            cout << "Error:unkown error when saving file" << endl;
            return 0;
        }
        cout << "Success" << endl;
        return 0;
    }
    if (argc > 3)
    {
        cout << "Error:too many arguments" << endl;
        return 0;
    }
    plt::ion();
    cout << "Loaded,welcome to use the program" << endl;
    cout << "Tip: you can click save button on figure view to save the picture when Sleeping" << endl;
    yyparse();
    cout << "Bye" << endl;
    Sleep(1000);
}