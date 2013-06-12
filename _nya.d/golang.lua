-- -*- mode: -ua -*-

-- @name        golang.lua
-- @description Go compiler for NYAOS 3.x
-- @namespace   http://kuonn.mydns.jp/
-- @author      DeaR
-- @timestamp   <2013-06-12 20:33:07 DeaR>

-- Copyright (c) 2013 DeaR <nayuri@kuonn.mydns.jp>
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
-- the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
-- DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

function golang(x64, gopath)
  if not gopath then
    print('usage: golang' .. (x64 and '64' or '32') .. ' GOPATH')
    return
  end

  nyaos.putenv('GOROOT', 'C:/Go/' .. (x64 and 'x64' or 'x86'))
  nyaos.putenv('GOPATH', gopath)
  nyaos.exec('set PATH+=' .. '%GOROOT%/bin')
end

function nyaos.command.golang32(gopath)
  return golang(false, gopath)
end

if arch and os.getenv('PROGRAMFILES(X86)') then
  function nyaos.command.golang64(gopath)
    return golang(true, gopath)
  end
end
