  local mqtt = require("mqtt_library")

function mqttcb(topic, message)
   print("Received from topic: " .. topic .. " - message:" .. message)
   space1 = string.find(message, "%s")
   space2 = string.find(message, "%s", space1+1)
   local_key = string.sub(message, 1, space1-1)
   local_x = string.sub(message, space1+1, space2-1)
   local_y = string.sub(message, space2+1)
   controle = not controle
end

function naimagem (mx, my, x, y) 
  return (mx>x) and (mx<x+w) and (my>y) and (my<y+h)
end

function retangulo (x,y,w,h)
  local originalx, originaly, rx, ry, rw, rh = x, y, x, y, w, h
  
  return {
    draw =
      function ()
        love.graphics.rectangle("line", rx, ry, rw, rh)
      end,
    keypressed =
      function (key)
        local mx, my = love.mouse.getPosition()
        key_x_y=key..' '..rx..' '..ry
        mqtt_client:publish("apertou-tecla", key_x_y)
      end    
  }
end

function love.load()
  controle = false
  mqtt_client = mqtt.client.create("test.mosquitto.org", 1883, mqttcb)
  mqtt_client:connect("1511651")
  mqtt_client:subscribe({"apertou-tecla"})
  ret1 = retangulo(50, 200, 200, 150)

end

function love.keypressed(key)
  ret1.keypressed(key)
end

function love.update (dt)
   mqtt_client:handler()
end

function love.draw ()
    if controle then
      ret1.draw()
    end
  
end

