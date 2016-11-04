-- Ignore EOF for NYAGOS
--
-- Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
-- Last Change:  04-Nov-2016.
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

share._ignoreeof_now = 0

share.org_ignoreeof_filter = nyagos.filter
nyagos.filter = function(args)
  share._ignoreeof_now = 0

  if share.org_ignoreeof_filter then
    return share.org_ignoreeof_filter(args)
  end
end

nyagos.bindkey('C_D', function(this)
  local max = share.ignoreeof or tonumber(nyagos.getenv('IGNOREEOF')) or -1
  if this.text:len() > 0 then
    this:call('DELETE_OR_ABORT')
  elseif max < 0 or share._ignoreeof_now < max then
    share._ignoreeof_now = share._ignoreeof_now + 1
    nyagos.write('Use "exit" to leave the shell.')
    return false
  else
    os.exit()
  end
end)
