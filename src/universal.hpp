#ifndef _UNIVERSAL_HPP_
#define _UNIVERSAL_HPP_
#include <string>
#include <iostream>
#include <vector>
#include <cstdlib>
#include <cstring>
#include "Python.h"
using namespace std;
char buffer[100000];
extern const string python;
extern bool errflagx;
PyObject *dess;
wstring Str2Wstr(string str);
bool checkversion(string path)
{
    FILE *pf = NULL;
#ifdef _WIN32
    pf = _popen((path + " -V").c_str(), "r");
#else
    pf = popen((path + " -V").c_str(), "r");
#endif
    if (NULL == pf)
    {
        printf("open pipe failed");
        return 0;
    }
    memset(buffer, 0, sizeof(buffer));
    std::string ret;
    while (fgets(buffer, sizeof(buffer), pf))
    {
        ret += buffer;
    }
#ifdef _WIN32
    _pclose(pf);
#else
    pclose(pf);
#endif
    if (ret.find(string("3.") + to_string(PYTHON)) != -1)
    {
        return true;
    }
    else
    {
        return false;
    }
}
bool checkmatplotlib(string path)
{
#ifdef _WIN32
    // Py_SetPythonHome(Str2Wstr(python.substr(0, python.length() - 12)).c_str());
#endif
    Py_Initialize();
    PyRun_SimpleString("import warnings");
    PyRun_SimpleString("warnings.filterwarnings('ignore')");
    PyRun_SimpleString("import imp");
    PyRun_SimpleString("imp.find_module('matplotlib')");
    if (PyErr_Occurred())
    {
        PyErr_Clear();
        Py_Finalize();
        return false;
    }
    else
    {
        Py_Finalize();
        return true;
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
string getpython()
{
    vector<string> pythonpaths;
    FILE *pf = NULL;
#ifdef _WIN32
    pf = _popen("where python", "r");
#else
    pf = popen("which python", "r");
#endif
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
#ifdef _WIN32
    _pclose(pf);
#else
    pclose(pf);
#endif
    string a = ret;
    if (a == "")
    {
#ifdef _WIN32
        system("cls");
#else
        system("clear");
#endif
        cout << string("No python3.") + to_string(PYTHON) + " found !";
        cin.get();
        exit(1);
    }
    while (a.find('\n') != -1)
    {
        string xc = a.substr(0, a.find('\n'));
        xc.insert(0, "\"");
        xc.insert(xc.length(), "\"");
        pythonpaths.push_back(xc);
        a = a.substr(a.find('\n') + 1);
    }
    for (auto a : pythonpaths)
    {
        if (checkversion(a))
        {
            return a;
        }
    }
    cout << string("No python3.") + to_string(PYTHON) + " found !";
    cin.get();
    exit(1);
}
wstring Str2Wstr(string str)
{
    if (str.length() == 0)
        return L"";

    std::wstring wstr;
    wstr.assign(str.begin(), str.end());
    return wstr;
}
double eval_fromPython(string x)
{
    try
    {

        PyObject *result = PyRun_String(x.c_str(), Py_eval_input, dess, dess);
        if (result == NULL)
        {
            PyErr_Clear();
            throw exception();
        }
        double res = PyFloat_AsDouble(result);
        return res;
    }
    catch (exception e)
    {
        cout << "Error:may exceed the numeric limit" << endl;
        errflagx = true;
        return 0;
    }
    // 调用，获取返回值
}
string to_lowercase(string str)
{
    for (int i = 0; i < str.length(); i++)
    {
        if (str[i] >= 'A' && str[i] <= 'Z')
        {
            str[i] += 32;
        }
    }
    return str;
}
auto temp = getpython();

const string python = subreplace(temp.substr(0, temp.find_last_of('/')), "\\", "/");
#endif