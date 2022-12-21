#ifndef _UNIVERSAL_HPP_
#define _UNIVERSAL_HPP_
#include <string>
#include <iostream>
#include <vector>
using namespace std;
char buffer[100000];
bool checkversion(string path)
{
    FILE *pf = NULL;
    pf = _popen((path + " -V").c_str(), "r");
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
    _pclose(pf);
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
    FILE *pf = NULL;
    pf = _popen((path + " -m pip list").c_str(), "r");
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
    _pclose(pf);
    system("cls");
    system("color 7");
    if (ret.find("matplotlib") == -1)
    {
        return false;
    }
    else
    {
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
    pf = _popen("where python", "r");
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
        cout << string("No python3.") + to_string(PYTHON) + " found !";
        cin.get();
        exit(1);
    }
    while (a.find('\n') != -1)
    {
        pythonpaths.push_back(a.substr(0, a.find('\n')));
        a = a.substr(a.find('\n') + 1);
    }
    for (auto a : pythonpaths)
    {
        if (checkversion(a))
        {
            if (checkmatplotlib(a))
            {
                return a;
            }
        }
    }
    system("cls");
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
auto temp = getpython();
const string python = subreplace(temp.substr(0, temp.length() - 10), "\\", "/");
#endif