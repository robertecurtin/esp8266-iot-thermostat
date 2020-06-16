local connect_wifi = require 'src/connect_wifi'
connect_wifi()

srv=net.createServer(net.TCP)
local singleton = false

return function(callback)
  assert(singleton == false, 'Only one web wrapper allowed')
  singleton = true
  srv:listen(80, function(conn)
    conn:on('receive', function(client,request)
      local _, _, _, _, vars = string.find(request, '([A-Z]+) (.+)?(.+) HTTP');

      local args = {}
      if (vars ~= nil)then
        for k, v in string.gmatch(vars, '(%w+)=(%w+)&*') do
          args[k] = v
        end
      end

      client:on('sent', function() client:close() end)
      client:send(callback(args))
    end)
  end)
end
