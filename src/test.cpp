#include <iostream>
#include "expoperate.hpp"
#include <cstdio>
#include <string>
#include "universal.hpp"
#include <windows.h>
#include <thread>
#include <map>
#include <mutex>
#include "matplotlibcpp.h"
std::mutex some_mutex;
namespace plt = matplotlibcpp;
int process_count = 0;
using namespace std;
bool errflag = false;
bool filemode = false;
extern int words, chars, lines, a;
extern int yyparse(void);
double originx, originy, rotate, scalex = 1, scaley = 1;
extern string s;
extern FILE *yyin;

void loop(int num, double i, string d, string e, map<int, pair<double, double>> &m, int &flag)
{
    double x = (expoperate(subreplace(d, "T", std::to_string(i))).getresult()) * scalex + originx;
    double y = (expoperate(subreplace(e, "T", std::to_string(i))).getresult()) * scaley + originy;
    std::lock_guard<std::mutex> guard(some_mutex);
    m.insert(pair<int, pair<double, double>>(num, pair<double, double>(x, y)));
    process_count--;
}
void drawthread(map<int, pair<double, double>> m)
{
    vector<double> x, y;
    for (auto item : m)
    {
        x.push_back(item.second.first);
        y.push_back(item.second.second);
    }
    plt::plot(x, y);
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
    std::cout << "OK,clear the draw" << std::endl;
}
void draw(string a, string b, string c, string d, string e)
{
    map<int, pair<double, double>> m;
    int num = 0;
    int flag = 1;
    cout << "Waiting..." << endl;
    for (double i = stod(a); i <= stod(b); i += stod(c))
    {
        while (process_count > 50)
        {
            Sleep(1);
        }
        thread t(loop, num, i, d, e, std::ref(m), std::ref(flag));
        t.detach();
        process_count++;
        num++;
    }
    while (m.size() != num)
    {
        Sleep(10);
    }
    // thread t(drawthread, m);
    // t.detach();
    drawthread(m);
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
    plt::ion();
    cout << "Loaded,welcome to use the program" << endl;
    yyparse();
    cin.get();
}
