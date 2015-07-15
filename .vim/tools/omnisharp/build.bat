@echo off

if "%VCVARSALL%"=="" (
  if not "%VS120COMNTOOLS%"=="" (
    set "VCVARSALL=%VS120COMNTOOLS%..\..\VC\vcvarsall.bat"
  ) else if not "%VS110COMNTOOLS%"=="" (
    set "VCVARSALL=%VS110COMNTOOLS%..\..\VC\vcvarsall.bat"
  ) else if not "%VS100COMNTOOLS%"=="" (
    set "VCVARSALL=%VS100COMNTOOLS%..\..\VC\vcvarsall.bat"
  ) else if not "%VS90COMNTOOLS%"=="" (
    set "VCVARSALL=%VS90COMNTOOLS%..\..\VC\vcvarsall.bat"
  ) else if not "%VS80COMNTOOLS%"=="" (
    set "VCVARSALL=%VS80COMNTOOLS%..\..\VC\vcvarsall.bat"
  ) else (
    echo MSVC not found.
    goto :EOF
  )
)

call "%VCVARSALL%" %PROCESSOR_ARCHITECTURE%

msbuild server\OmniSharp.sln /p:Platform="Any CPU" %*
