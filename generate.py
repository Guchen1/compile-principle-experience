import os
import sys
# 调用flex和bison生成文件
if __name__ == "__main__":
    while True:
        files = os.listdir()
        if "process.exe" in files:
            pathbuild = os.getcwd()
            os.chdir("..")
        elif "src" in files:
            pathroot = os.getcwd()
            break
        else:
            os.chdir("..")
    relpath = os.path.relpath(pathbuild, pathroot).replace("\\", "/")
    os.system("bison -o "+relpath +
              "/bison.tab.cc src/test.y")
    os.chdir(pathbuild)
    os.system("process.exe ")
    os.chdir(pathroot)
    os.system("flex  --outfile="+relpath +
              "/flex.yy.cc src/test.l")
