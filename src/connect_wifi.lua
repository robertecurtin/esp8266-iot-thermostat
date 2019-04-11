local wifi_configuration = require 'wifi_configuration'

return function()
  wifi.setmode(wifi.STATION)
  print(wifi.sta.config({
    ssid = wifi_configuration.name,
    pwd = wifi_configuration.password,
    connected_cb = function(t) print('Connected with ' .. t.SSID) end
  }))
end
