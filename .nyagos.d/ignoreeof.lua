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
