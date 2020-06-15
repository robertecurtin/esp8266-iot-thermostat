local changed_adc = adc.force_init_mode(adc.INIT_ADC)

if changed_adc then
  node.restart()
  return
end

return {
  read = function()
    return adc.read(0)
  end
}
