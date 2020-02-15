local wifi_configuration = require 'src/wifi_configuration'

return function()
  wifi.setmode(wifi.STATION)
  wifi.sta.config({
    ssid = wifi_configuration.ssid,
    pwd = wifi_configuration.password,
    connected_cb = function(t) print('Connected to', t.SSID) end,
    got_ip_cb = function(t) print('IP: ', t.IP) end
  })
end
