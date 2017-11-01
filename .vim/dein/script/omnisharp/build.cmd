@echo off
setlocal

if not defined VCVARSALL (
  if exist "%VS141COMNTOOLS%..\..\VC\vcvarsall.bat" (
    set "VCVARSALL=%VS141COMNTOOLS%..\..\VC\vcvarsall.bat"
  ) else if exist "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" (
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
    endlocal
    exit /b 1
  )
)
call "%VCVARSALL%" %PROCESSOR_ARCHITECTURE%

msbuild server\OmniSharp.sln /p:Platform="Any CPU" %*

endlocal
