setlocal EnableDelayedExpansion
@echo on

set "CFLAGS=%CFLAGS% -DWIN32_LEAN_AND_MEAN"
set "CXXFLAGS=%CXXFLAGS% -DWIN32_LEAN_AND_MEAN"

:: Make a build folder and change to it
mkdir build
if errorlevel 1 exit 1
cd build
if errorlevel 1 exit 1

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
