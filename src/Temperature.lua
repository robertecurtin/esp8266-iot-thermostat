local config = require 'src/config'
local adc = require 'src/wrapped_adc'
local log = require 'src/log'

return function(filter_callback)
  local resistor = config.resistor
  local thermistor = config.thermistor

  local raw_temperature = function()
    local counts = adc.read()
    counts = counts > 1 and counts or 1
    local r =
      resistor.resistance / (1023 / (counts - 1))

    local t_kelvin = 1 / (
      (1 / thermistor.nominal_temperature) +
      (1 / thermistor.beta_coefficient) *
      (log(r / thermistor.nominal_resistance)))
    local t_farenheit = (t_kelvin - 273.15) * 9 / 5
    print(t_farenheit)
    return t_farenheit
  end

  local filtered_temperature = raw_temperature()

  return {
    raw_temperature = raw_temperature,
    filtered_temperature = function()
      return filtered_temperature
    end,
    poll = function()
      filtered_temperature = filter_callback(raw_temperature(), filtered_temperature)
    end
  }
end
