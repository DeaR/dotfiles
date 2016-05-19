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
call "%VCVARSALL%" %PROCESSOR_ARCHITECTURE%

chcp 65001 > nul
msbuild server\OmniSharp.sln /p:Configuration="Release" /p:Platform="Any CPU" %*
