local mqtt = require("mqtt_library")

function mqttcb(topic, message)
   print("Received from topic: " .. topic .. " - message:" .. message)
   space = string.find(message, " ")
   lat = string.sub(message, 1, space1-1)
   long = string.sub(message, space1+1, string.len(message))
   print(lat)
   print(long)
end

function love.load()
  controle = false
  m = mqtt.client.create("test.mosquitto.org", 1883, mqttcb)
  m:connect("1511651")
  m:subscribe({"latlong"})
end

function love.update (dt)
   m:handler()
end

function love.draw ()
    if controle then
      love.graphics.rectangle("fill", 20, 50, 60, 120 ) 
    end
  
end