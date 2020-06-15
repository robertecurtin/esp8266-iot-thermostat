local connect_wifi = require 'src/connect_wifi'
local Temperature = require 'src/Temperature'

connect_wifi()

local temperature = Temperature(
  function (raw_temperature, filtered_temperature)
    return filtered_temperature * .9 + raw_temperature * .1
  end)

local sample_timer = tmr.create()
sample_timer:register(1000, tmr.ALARM_AUTO, temperature.poll)
sample_timer:start()

srv=net.createServer(net.TCP)

srv:listen(80,function(conn)
  conn:on('receive', function(client,request)
    local _, _, _, _, vars = string.find(request, '([A-Z]+) (.+)?(.+) HTTP');

    local args = {}
    if (vars ~= nil)then
      for k, v in string.gmatch(vars, '(%w+)=(%w+)&*') do
        args[k] = v
      end
    end

    client:on('sent', function() client:close() end)
    if(args.value == 'raw')then
      client:send(temperature.raw_temperature());
    else
      client:send(temperature.filtered_temperature());
    end
  end)
end)
