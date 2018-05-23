local mqtt = require("mqtt_library")

function mqttcb(topic, message)
   print("Received from topic: " .. topic .. " - message:" .. message)
   controle = not controle
end

function love.keypressed(key)
  if key == 'a' then
    mqtt_client:publish("apertou-tecla", "a")
  end
end

function love.load()
  controle = false
  mqtt_client = mqtt.client.create("test.mosquitto.org", 1883, mqttcb)
  mqtt_client:connect("cliente love 1")
  mqtt_client:subscribe({"apertou-tecla"})
end

function love.draw()
   if controle then
     love.graphics.rectangle("line", 10, 10, 200, 150)
   end
end

function love.update(dt)
  mqtt_client:handler()
end

--[[
local tentativas = 5
local function postCallback(code, data)
    if code < 0 then 
        tentativas = tentativas - 1
        if tentativas > 0 then
            http.post('https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyAcBMESee5T5HXZvd3oVoix4qMfJBgd0fM',
                      'Content-Type: application/json\r\n',
                       wifi_ap, postCallback)
        end
   else
      print(code, data)
      local i, j = string.find(data, '"lat": ')
      local v1 = string.find(data, ',')
      print(v1, i, j)
      local lat = string.sub(data, j+1, v1-1)
      i, j = string.find(data, '"lng": ')
      local v2 = string.find(data, ',', v1+1)
      local long = string.sub(data, j+1, v2-3)
      message = lat..' '..long
      print(message)
      publica(m, message)
   end
end

function callback()
    wifi.sta.getap(listap)
    print(wifi_ap)
    http.post('https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyAcBMESee5T5HXZvd3oVoix4qMfJBgd0fM',
      'Content-Type: application/json\r\n',
      wifi_ap, postCallback)
end
]]--
  
