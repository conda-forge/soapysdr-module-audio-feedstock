setlocal EnableDelayedExpansion
@echo on

:: Make a build folder and change to it
mkdir build
if errorlevel 1 exit 1
cd build
if errorlevel 1 exit 1

:: We need pthread headers for hamlib, but the ones that it built against
:: (m2w64-winpthreads-git) can't be used in conjunction with MSVC. However,
:: the newer mingw-w64 pthread headers contained in the winpthreads package
:: *are* compatible, it's just that those haven't been rolled out with a new
:: complete gcc build system on Windows yet. Moreover, it conflicts with the
:: existing dependencies. But as a hack, we can install winpthreads in the build
:: environment and point the compiler there to find pthread.h and company.
set "CFLAGS=-external:I%BUILD_PREFIX%\Library\include"
set "CXXFLAGS=-external:I%BUILD_PREFIX%\Library\include"

:: configure
cmake -G "Ninja" ^
    -DCMAKE_BUILD_TYPE:STRING=Release ^
    -DCMAKE_INSTALL_LIBDIR:STRING=lib ^
    -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_PREFIX_PATH:PATH="%LIBRARY_PREFIX%" ^
    -DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=ON ^
    -DUSE_HAMLIB=ON ^
    ..
if errorlevel 1 exit 1

:: build
cmake --build . --config Release -- -j%CPU_COUNT%
if errorlevel 1 exit 1

:: install
cmake --build . --config Release --target install
if errorlevel 1 exit 1
