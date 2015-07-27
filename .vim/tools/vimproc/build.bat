@echo off

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
  exit /b 1
)
call "%VCVARSALL%" %PROCESSOR_ARCHITECTURE%

if "%CPU%"=="AMD64" (
  set vimproc_arch=64
) else if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
  set vimproc_arch=64
) else (
  set vimproc_arch=32
)
set vimproc_dllname=vimproc_win%vimproc_arch%.dll

nmake /f make_msvc.mak %*
if ERRORLEVEL 1 (
  rem Build failed.

  rem Try to delete old DLLs.
  if exist autoload\%vimproc_dllname%.old del autoload\%vimproc_dllname%.old
  if exist autoload\%vimproc_dllname%     del autoload\%vimproc_dllname%
  rem If the DLL couldn't delete (may be it is in use), rename it.
  if exist autoload\%vimproc_dllname%     ren autoload\%vimproc_dllname% %vimproc_dllname%.old

  nmake /f make_msvc.mak %*
)
