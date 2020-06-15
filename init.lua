print('init start')

-- shamelessly stolen from https://stackoverflow.com/questions/52579137/i-need-the-lua-math-library-in-nodemcu
local function log(x)
  assert(x > 0)
  local a, b, c, d, e, f = x < 1 and x or 1/x, 0, 0, 1, 1
  repeat
     repeat
        c, d, e, f = c + d, b * d / e, e + 1, c
     until c == f
     b, c, d, e, f = b + 1 - a * c, 0, 1, 1, b
  until b <= f
  return a == x and -f or f
end

local connect_wifi = require 'src/connect_wifi'

local changed_adc = adc.force_init_mode(adc.INIT_ADC)

-- Move these to a config later
local resistor_value = 100 * 1000
-- thermistor
local beta_coefficient = 3950
local nominal_resistance = 100 * 1000
local nominal_temperature = 298.15 -- in Kelvin, check me later

if changed_adc then
  node.restart()
  return
end

connect_wifi()

local raw_temperature = function()
  local counts = adc.read(0)
  counts = counts > 1 and counts or 1
  local r =
    resistor_value / (1023 / (counts - 1))

  local t_kelvin = 1 / (
    (1 / nominal_temperature) +
    (1 / beta_coefficient) *
    (log(r / nominal_resistance)))
  local t_farenheit = (t_kelvin - 273.15) * 9 / 5
  print(t_farenheit)
  return t_farenheit
end

local filtered_temperature = raw_temperature()

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
    if(args.value == 'raw')then
      client:send(raw_temperature());
    else
      client:send(filtered_temperature);
    end

  end)
end)

print('Init complete')
