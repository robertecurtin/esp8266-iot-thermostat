local connect_wifi = require 'src/connect_wifi'

connect_wifi()

relay_gpio = 0

gpio.mode(relay_gpio, gpio.OUTPUT)

srv=net.createServer(net.TCP)

srv:listen(80,function(conn)
  conn:on("receive", function(client,request)
    local _, _, _, _, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");

    local args = {}
    if (vars ~= nil)then
      for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
        args[k] = v
      end
    end

    local str = "<p><a href=\"?lightState=On\"><button>Turn light ON</button></a><br><a href=\"?lightState=Off\"><button>Turn light OFF</button></a></p>";

    if(args.lightState == "On")then
      gpio.write(relay_gpio, gpio.HIGH);
    elseif(args.lightState == "Off")then
      gpio.write(relay_gpio, gpio.LOW);
    end

    client:on("sent", function() client:close() end)
    client:send(str);
  end)
end)
