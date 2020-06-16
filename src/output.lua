local pin = {
  heat = 0,
  cool = 1,
  fan_low = 2,
  fan_high = 3
}

for _, p in pairs(pin) do
  gpio.mode(p, gpio.OUTPUT)
end

local write = function(pin, v)
  gpio.write(pin, v and gpio.HIGH or gpio.LOW)
end

local fan_low = function(v)
  write(pin.fan_low, v)
end

return {
  heat = function(v)
    if(v) then
      write(pin.heat, true)
      fan_low(true)
      write(pin.cool, false)
    else
      write(pin.heat, false)
    end
  end,
  cool = function(v)
    if(v) then
      fan_low(true)
      write(pin.cool, true)
      write(pin.heat, false)
    else
      write(pin.cool, false)
    end
  end,
  fan_low = fan_low,
  fan_high = function(v)
    write(pin.fan_high, v)
  end
}
