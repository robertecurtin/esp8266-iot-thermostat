local Thermostat = require 'src/Thermostat'
local WebWrapper = require 'src/WebWrapper'

-- local sample_timer = tmr.create()
-- sample_timer:register(1000, tmr.ALARM_AUTO, temperature.poll)
-- sample_timer:start()

WebWrapper(
  function(args)
    if(args.set) then
      Thermostat(tonumber(args.set))
      return args.set
    else
      return 'Set a temperature ?set=blah'
    end
  end)
