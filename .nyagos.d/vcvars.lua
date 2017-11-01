-- Visual Studio prompt for NYAGOS
--
-- Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
-- Last Change:  24-May-2017.
-- License:      MIT License {{{
--     Copyright (c) 2013 DeaR <nayuri@kuonn.mydns.jp>
--
--     Permission is hereby granted, free of charge, to any person obtaining a
--     copy of this software and associated documentation files (the
--     "Software"), to deal in the Software without restriction, including
--     without limitation the rights to use, copy, modify, merge, publish,
--     distribute, sublicense, and/or sell copies of the Software, and to
--     permit persons to whom the Software is furnished to do so, subject to
--     the following conditions:
--
--     The above copyright notice and this permission notice shall be included
--     in all copies or substantial portions of the Software.
--
--     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
--     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
--     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
--     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
--     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
--     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
--     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-- }}}

share.__vcvarsall = function(arch)
  local vs141 = nyagos.getenv('VS141COMNTOOLS')
  local vs140 = nyagos.getenv('VS140COMNTOOLS')
  local vs120 = nyagos.getenv('VS120COMNTOOLS')
  local vs110 = nyagos.getenv('VS110COMNTOOLS')
  local vs100 = nyagos.getenv('VS100COMNTOOLS')
  local vs090 = nyagos.getenv('VS90COMNTOOLS')
  local vs080 = nyagos.getenv('VS80COMNTOOLS')
  if vs141 and nyagos.stat(vs141 .. '..\\..\\VC\\vcvarsall.bat') then
    nyagos.exec('source "' .. vs141 .. '..\\..\\VC\\vcvarsall.bat" ' .. arch)
  elseif vs140 and nyagos.stat(vs140 .. '..\\..\\VC\\vcvarsall.bat') then
    nyagos.exec('source "' .. vs140 .. '..\\..\\VC\\vcvarsall.bat" ' .. arch)
  elseif vs120 and nyagos.stat(vs120 .. '..\\..\\VC\\vcvarsall.bat') then
    nyagos.exec('source "' .. vs120 .. '..\\..\\VC\\vcvarsall.bat" ' .. arch)
  elseif vs110 and nyagos.stat(vs110 .. '..\\..\\VC\\vcvarsall.bat') then
    nyagos.exec('source "' .. vs110 .. '..\\..\\VC\\vcvarsall.bat" ' .. arch)
  elseif vs100 and nyagos.stat(vs100 .. '..\\..\\VC\\vcvarsall.bat') then
    nyagos.exec('source "' .. vs100 .. '..\\..\\VC\\vcvarsall.bat" ' .. arch)
  elseif vs090 and nyagos.stat(vs090 .. '..\\..\\VC\\vcvarsall.bat') then
    nyagos.exec('source "' .. vs090 .. '..\\..\\VC\\vcvarsall.bat" ' .. arch)
  elseif vs080 and nyagos.stat(vs080 .. '..\\..\\VC\\vcvarsall.bat') then
    nyagos.exec('source "' .. vs080 .. '..\\..\\VC\\vcvarsall.bat" ' .. arch)
  else
    nyagos.write('MSVC not found.\n')
    return
  end
  

  local pf32 =
    nyagos.getenv('PROGRAMFILES(X86)') or
    nyagos.getenv('PROGRAMFILES')
  local d71a = pf32 .. '\\Microsoft SDKs\\Windows\\v7.1A\\Include'
  local d71  = pf32 .. '\\Microsoft SDKs\\Windows\\v7.1\\Include'
  local d70a = pf32 .. '\\Microsoft SDKs\\Windows\\v7.0A\\Include'
  local d70  = pf32 .. '\\Microsoft SDKs\\Windows\\v7.0\\Include'
  local sdk  =
    nyagos.stat(d71a) and d71a or
    nyagos.stat(d71)  and d71  or
    nyagos.stat(d70a) and d70a or
    nyagos.stat(d70)  and d70
  if nyagos.stat(sdk) then
    nyagos.setenv('SDK_INCLUDE_DIR', sdk)
  end
end

nyagos.alias.vcvars32 = function(args)
  share.__vcvarsall('x86')
end

if nyagos.getenv('PROGRAMFILES(X86)') then
  nyagos.alias.vcvars64 = function(args)
    local arch =
      nyagos.getenv('PROCESSOR_ARCHITEW6432') or
      nyagos.getenv('PROCESSOR_ARCHITECTURE')
    share.__vcvarsall(arch)
  end
end
