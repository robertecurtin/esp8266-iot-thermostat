local wifi_configuration = require 'src/wifi_configuration'

return function()
  wifi.setmode(wifi.STATION)
  print(wifi.sta.config({
    ssid = wifi_configuration.name,
    pwd = wifi_configuration.password,
    connected_cb = function(t)
      print('Connected to', t.SSID)
    end
  }))
end
