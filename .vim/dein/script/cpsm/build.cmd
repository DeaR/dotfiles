@echo off

if not defined VCVARSALL (
  if exist "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" (
    set "VCVARSALL=%VS140COMNTOOLS%..\..\VC\vcvarsall.bat"
  ) else if exist "%VS120COMNTOOLS%..\..\VC\vcvarsall.bat" (
    set "VCVARSALL=%VS120COMNTOOLS%..\..\VC\vcvarsall.bat"
  ) else if exist "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" (
    set "VCVARSALL=%VS110COMNTOOLS%..\..\VC\vcvarsall.bat"
  ) else if exist "%VS100COMNTOOLS%..\..\VC\vcvarsall.bat" (
    set "VCVARSALL=%VS100COMNTOOLS%..\..\VC\vcvarsall.bat"
  ) else if exist "%VS90COMNTOOLS%..\..\VC\vcvarsall.bat" (
    set "VCVARSALL=%VS90COMNTOOLS%..\..\VC\vcvarsall.bat"
  ) else if exist "%VS80COMNTOOLS%..\..\VC\vcvarsall.bat" (
    set "VCVARSALL=%VS80COMNTOOLS%..\..\VC\vcvarsall.bat"
  ) else (
    echo MSVC not found.
    exit /b 1
  )
)
if not "%PROCESSOR_ARCHITECTURE%" == "x86" (
  set "CMAKE_GENERATOR_PLATFORM=x64"
)
call "%VCVARSALL%" %PROCESSOR_ARCHITECTURE%

chcp 65001 >nul
if not exist "build" mkdir build
pushd build
cmake -DPY3:BOOL=OFF -DBoost_USE_STATIC_LIBS=ON -DBoost_USE_MULTITHREADED=ON -DPYTHON_LIBRARIES="C:\Python27\Libs\python27.lib" -DCMAKE_GENERATOR_PLATFORM=%CMAKE_GENERATOR_PLATFORM% ..
msbuild INSTALL.vcxproj /p:Configuration=Release && msbuild RUN_TESTS.vcxproj /p:Configuration=Release
popd

if exist "autoload\cpsm_py.dll" move /y autoload\cpsm_py.dll autoload\cpsm_py.pyd