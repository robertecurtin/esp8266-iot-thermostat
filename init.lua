print('init start')

local connect_wifi = require 'src/connect_wifi'

local changed_adc = adc.force_init_mode(adc.INIT_ADC)

if changed_adc then
  node.restart()
  return
end

connect_wifi()

local raw_temperature = function()
  local counts = adc.read(0)
  print(counts)
  return counts
end

local filtered_temperature

local sample_timer = tmr.create()
sample_timer:register(1000, tmr.ALARM_AUTO,
  function ()
    filtered_temperature = filtered_temperature * .9 + raw_temperature() * .1
  end)
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

    local str = '<p><a href=\'?lightState=On\'><button>Turn light ON</button></a><br><a href=\'?lightState=Off\'><button>Turn light OFF</button></a></p>';

    client:on('sent', function() client:close() end)
    if(args.raw == '')then
      client:send(raw_temperature);
    else
      client:send(filtered_temperature);
    end

  end)
end)

print('Init complete')
