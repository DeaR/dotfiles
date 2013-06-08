-- -*- mode: lua -*-

-- @name        lastcmd_title.lua
-- @description Title is set last command.
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

local inited = nil
local lastcmd = {}
local ignore = {}

function set_lastcmd_title(title)
  if not inited then
    inited = true
    nyaos.option.title = title
    return
  end
  for i = 1, #lastcmd do
    if not ignore[lastcmd[i]] then
      nyaos.option.title = lastcmd[i] .. (title and (' - ' .. title) or '')
      return
    end
  end
end

function set_lastcmd_ignore(cmd)
  ignore[cmd] = 1
end
function del_lastcmd_ignore(cmd)
  ignore[cmd] = nil
end

function nyaos.filter2.prompt(c)
  if not inited then
    return
  end
  for k, v in pairs(lastcmd) do
    lastcmd[k] = nil
  end
  local t = ''
  for w in c:gmatch('[^ ]+') do
    t = t .. w
    if t:match('^[^\034]+$') or t:match('^\034[^\034]+\034$') then
      table.insert(lastcmd, t)
      t = ''
    end
  end
  if t ~= '' then
    table.insert(lastcmd, t)
  end
end
