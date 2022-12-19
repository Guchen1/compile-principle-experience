
test:
	if not exist "build" mkdir build
	cd build&bison -Wcounterexamples  -o a.tab.cc   ../src/test.yxx
	cd build&g++ ../src/process.cpp -o process.exe
	cd build& process.exe 
	cd build&flex  --outfile=a.yy.cc  ../src/test.l 
	cd build&g++  -g -o test.exe a.tab.cc a.yy.cc ../src/test.cpp


