-- -*- mode: lua -*-

-- @name        ltail.lua
-- @description less tail -f
-- @namespace   http://kuonn.mydns.jp/
-- @author      DeaR
-- @timestamp   <2013-05-28 11:28:23 DeaR>

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

if nyaos.eval('which less') then
  function nyaos.command.ltail(...)
    local o = os.getenv('LESSOPEN')
    local c = os.getenv('LESSCLOSE')
    nyaos.putenv('LESSOPEN')
    nyaos.putenv('LESSCLOSE')
    nyaos.exec('less +F ' .. (table.concat({...} or {}, ' ')))
    nyaos.putenv('LESSOPEN', o)
    nyaos.putenv('LESSCLOSE', c)
  end
end
