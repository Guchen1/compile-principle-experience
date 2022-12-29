#include <iostream>
#include <fstream>
#include <vector>
#include <string>
using namespace std;
int main()
{
    fstream in("bison.tab.cc", ios::in);
    fstream out("type.h", ios::out);
    vector<string> lines;
    string temp;
    std::vector<std::string>::iterator startp, endp;
    bool find = false;
    while (!in.eof())
    {
        getline(in, temp);
        lines.push_back(temp);
    }
    for (auto i = lines.begin(); i < lines.end(); i++)
    {
        if (!find && *i == "  enum yytokentype")
        {
            find = true;

            startp = i;
        }
        else if (find)
        {
            if (i->find("};") != -1)
            {
                endp = i;
                break;
            }
        }
    }
    for (auto i = startp; i <= endp; i++)
    {
        i->erase(0, 2);
        out << *i << endl;
    }
}