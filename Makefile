
PYTHON_PATH=C:/Users/10237/AppData/Local/Programs/Python/Python310
PYTHON_VERSION=10
all: clean build
build:
	if not exist "out" mkdir out
	if not exist "out/build" mkdir out/build
	cd out/build&bison  -o a.tab.cc   ../src/test.y
	cd out/build&g++ ../src/process.cpp -o process.exe
	cd out/build& process.exe 
	cd out/build&flex  --outfile=a.yy.cc  ../src/test.l 
	cd out/build&g++ -I../src -I../thirdparty -I$(PYTHON_PATH)/include/ -DPYTHON=$(PYTHON_VERSION) -DNDEBUG  -O2    -I $(PYTHON_PATH)/Lib/site-packages/~umpy/core/include -o draw.exe $(PYTHON_PATH)/python3$(PYTHON_VERSION).dll a.tab.cc a.yy.cc ../src/test.cpp

clean:
	if exist "out/build" rd /s /q out/build

debug:
	if not exist "out" mkdir out
	if not exist "out/build" mkdir out/build
	cd out/build&bison -Wcounterexamples  -o a.tab.cc   ../src/test.y
	cd out/build&g++ ../src/process.cpp -o process.exe
	cd out/build& process.exe 
	cd out/build&flex  --outfile=a.yy.cc  ../src/test.l 
	cd out/build&g++ -I../src -I../thirdparty -I$(PYTHON_PATH)/include/ -DPYTHON=$(PYTHON_VERSION) -DDEBUG -g -I $(PYTHON_PATH)/Lib/site-packages/~umpy/core/include -o draw.exe $(PYTHON_PATH)/python3$(PYTHON_VERSION).dll a.tab.cc a.yy.cc ../src/test.cpp
