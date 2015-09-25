-- Visual Studio prompt for NYAOS 3.x
--
-- Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
-- Last Change:  14-Sep-2015.
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

if nyaos.command.cmdsource then
  function nyaos.command.sdk_include_dir()
    local programfiles = os.getenv(os.getenv('PROGRAMFILES(X86)') and 'PROGRAMFILES(X86)' or 'PROGRAMFILES')
    local dir71a  = programfiles .. '\\Microsoft SDKs\\Windows\\v7.1A\\Include'
    local dir71   = programfiles .. '\\Microsoft SDKs\\Windows\\v7.1\\Include'
    local dir70a  = programfiles .. '\\Microsoft SDKs\\Windows\\v7.0A\\Include'
    local dir70   = programfiles .. '\\Microsoft SDKs\\Windows\\v7.0\\Include'
    local stat71a = nyaos.stat(dir71a)
    local stat71  = nyaos.stat(dir71)
    local stat70a = nyaos.stat(dir70a)
    local stat70  = nyaos.stat(dir70)
    if stat71a and stat71a.directory then
      nyaos.putenv('SDK_INCLUDE_DIR', dir71a)
    elseif stat71 and stat71.directory then
      nyaos.putenv('SDK_INCLUDE_DIR', dir71)
    elseif stat70a and stat70a.directory then
      nyaos.putenv('SDK_INCLUDE_DIR', dir70a)
    elseif stat70 and stat70.directory then
      nyaos.putenv('SDK_INCLUDE_DIR', dir70)
    end
  end

  local vscomntools = os.getenv('VS120COMNTOOLS') or os.getenv('VS110COMNTOOLS') or os.getenv('VS100COMNTOOLS') or os.getenv('VS90COMNTOOLS') or os.getenv('VS80COMNTOOLS')
  if vscomntools and nyaos.access(vscomntools .. '../../VC/vcvarsall.bat', 0) then
    function nyaos.command.vcvars32()
      nyaos.putenv('CC', nil)
      nyaos.putenv('CXX', nil)
      nyaos.putenv('CCC', nil)
      nyaos.putenv('C_INCLUDE_PATH', nil)
      nyaos.putenv('CPLUS_INCLUDE_PATH', nil)
      nyaos.putenv('LIBRARY_PATH', nil)
      nyaos.command.cmdsource(vscomntools .. '../../VC/vcvarsall.bat', 'x86')

      nyaos.command.sdk_include_dir()
    end
    local arch = os.getenv('PROCESSOR_ARCHITEW6432') or os.getenv('PROCESSOR_ARCHITECTURE')
    if arch and os.getenv('PROGRAMFILES(X86)') then
      function nyaos.command.vcvars64()
        nyaos.putenv('CC', nil)
        nyaos.putenv('CXX', nil)
        nyaos.putenv('CCC', nil)
        nyaos.putenv('C_INCLUDE_PATH', nil)
        nyaos.putenv('CPLUS_INCLUDE_PATH', nil)
        nyaos.putenv('LIBRARY_PATH', nil)
        nyaos.command.cmdsource(vscomntools .. '../../VC/vcvarsall.bat', arch)

        nyaos.command.sdk_include_dir()
      end
    end
  end
end
