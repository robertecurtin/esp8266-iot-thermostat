local output = require 'src/output'
local setpoint = 70
local on = true

return function(temperature)
  if temperature > setpoint then
    output.heat(on)
  elseif temperature < setpoint then
    output.cool(on)
  end
end
