
PYTHON_PATH=C:/Users/10237/AppData/Local/Programs/Python/Python310
PYTHON_VERSION=10
test:
	if not exist "build" mkdir build
	cd build&bison -Wcounterexamples  -o a.tab.cc   ../src/test.y
	cd build&g++ ../src/process.cpp -o process.exe
	cd build& process.exe 
	cd build&flex  --outfile=a.yy.cc  ../src/test.l 
	cd build&g++ -I../src -I../thirdparty -I$(PYTHON_PATH)/include/ -DPYTHON=$(PYTHON_VERSION)    -I $(PYTHON_PATH)/Lib/site-packages/~umpy/core/include  -g -o test.exe $(PYTHON_PATH)/python3$(PYTHON_VERSION).dll a.tab.cc a.yy.cc ../src/test.cpp
