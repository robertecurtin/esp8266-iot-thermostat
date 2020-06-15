-- Move these to a config later
return {
  resistor = { resistance = 100 * 1000 },
  thermistor = {
    beta_coefficient = 3950,
    nominal_resistance = 100 * 1000,
    nominal_temperature = 298.15 -- in Kelvin, check me later
  }
}
