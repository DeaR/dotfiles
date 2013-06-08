-- -*- mode: lua -*-

-- @name        nyaos_bash.lua
-- @description Bash like prompt for NYAOS 3.x
-- @namespace   http://anengineer.tumblr.com/post/13196592706/nyaos-bash-lua
-- @author      DeaR
-- @timestamp   <2013-05-18 18:01:27 DeaR>

-- Copyright (c) 2013 DeaR <nayuri@kuonn.mydns.jp>
-- Copyright (c) 2011 anengineer
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

function nyaos_bash(_pwd)
  local user = os.getenv('USERNAME')
  local machine = os.getenv('USERDOMAIN')
  local home = os.getenv('HOME') or os.getenv('USERPROFILE')
  local pwd = string.gsub(_pwd, home, '~')
  return true, '$e[32;40;1m' .. user .. '@' .. machine .. ' $e[33;40;1m' .. pwd .. '$e[0m\n$$ '
end
