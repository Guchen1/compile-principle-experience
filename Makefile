
test:
	if not exist "build" mkdir build
	cd build&bison  -o a.tab.cc   ../src/test.y 
	cd build&flex  --outfile=a.yy.cc  ../src/test.l 
	cd build&g++ ../src/process.cpp -o process.exe
	cd build& process.exe
	cd build&g++ -o test.exe a.tab.cc a.yy.cc ../src/test.cpp

