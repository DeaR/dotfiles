-- NYAOS settings
--
-- Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
-- Last Change:  13-Aug-2013.
-- License:      GNU General Public License {{{
--     Copyright (c) 2013 DeaR <nayuri@kuonn.mydns.jp>
--     Copyright (c) 2001-2013 HAYAMA,Kaoru
--
--     This program is free software: you can redistribute it and/or modify it
--     under the terms of the GNU General Public License as published by the
--     Free Software Foundation; either version 3 of the License, or (at your
--     option) any later version.
--
--     This program is distributed in the hope that it will be useful, but
--     WITHOUT ANY WARRANTY; without even the implied warranty of
--     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
--     General Public License for more details.
--
--     You should have received a copy of the GNU General Public License along
--     with this program. If not, see <http://www.gnu.org/licenses/>
-- }}}

function nyaos.filter.auto_cd(argv)
  local dir=argv:gsub('\034', ''):gsub('[/\\]$', '')
  local stat=nyaos.stat(dir)
  if stat and stat.directory then
    return 'cd ' .. argv
  end
  return argv
end
