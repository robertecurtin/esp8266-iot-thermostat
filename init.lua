local Temperature = require 'src/Temperature'
local WebWrapper = require 'src/WebWrapper'

local temperature = Temperature(
  function (raw_temperature, filtered_temperature)
    return filtered_temperature * .9 + raw_temperature * .1
  end)

local sample_timer = tmr.create()
sample_timer:register(1000, tmr.ALARM_AUTO, temperature.poll)
sample_timer:start()

WebWrapper(
  function(args)
    if(args.value == 'raw')then
      return temperature.raw_temperature();
    else
      return temperature.filtered_temperature();
    end
  end)
