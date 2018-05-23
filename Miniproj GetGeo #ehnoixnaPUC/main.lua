local mqtt = require("mqtt_library")
love.window.setTitle("NodeMCU LatLong - Bernardo & Alexandre")

function mqttcb (topic, message)
  print("Received from topic: " .. topic .. " - message:" .. message)
  space = string.find(message, " ")
  lat = string.sub(message, 1, space1-1)
  long = string.sub(message, space1+1, string.len(message))
  recieved = 1
end



function love.load()
  lat = 0
  long = 0
  
  w = 300
  h = 300
  love.window.setMode(w,h)
  
  m = mqtt.client.create("test.mosquitto.org", 1883, mqttcb)
  m:connect("BernardoSnow")
  m:subscribe({"latlong"})
end

function love.keypressed(key)
  if key == 'space' then
    lat = 0
    long = 0
    m:publish("PedidoLove", "Pedido de localizacao")
  end
end

function love.update (dt)
   m:handler()
end

function love.draw ()
  love.graphics.setColor(0, 0, 255)
  love.graphics.rectangle('line', 40, 30, 220, 60)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("NodeMCU Localizacao!", 55, 50, 0, 1.4, 1.4)
  love.graphics.print("Latitude: ", 10, 140, 0, 1.4, 1.4)
  love.graphics.print("Longitude: ", 10, 160, 0, 1.4, 1.4)
  
  if recieved == 1 then
    love.graphics.print(lat, 95, 140, 0, 1.4, 1.4)
    love.graphics.print(long, 110, 160, 0, 1.4, 1.4)
  else
    love.graphics.print("xxxxxxx", 95, 140, 0, 1.4, 1.4)
    love.graphics.print("xxxxxxx", 110, 160, 0, 1.4, 1.4)
  end
end