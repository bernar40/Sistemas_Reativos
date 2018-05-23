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
  

--[[mqtt = require("mqtt_library")

function mqttcb(topic, message)
   print("Received from topic: " .. topic .. " - message:" .. message)
   space1 = string.find(message, "%s")
   space2 = string.find(message, "%s", space1+1)
   local_key = string.sub(message, 1, space1-1)
   local_x = string.sub(message, space1+1, space2-1)
   local_y = string.sub(message, space2+1)
   controle = not controle
end

function publica(c)
  c:publish("alos","alo do nodemcu!",0,0, 
            function(client) print("mandou!") end)
end

function novaInscricao (c)
  local msgsrec = 0
  function novamsg (c, t, m)
    print ("mensagem ".. msgsrec .. ", topico: ".. t .. ", dados: " .. m)
    msgsrec = msgsrec + 1
  end
  c:on("message", novamsg)
end

function conectado (client)
  print("Cliente conectado!")
end

function love.load()
  controle = false
  ret1 = retangulo(50, 200, 200, 150)
  m = mqtt.Client("1511651", 120)
  m:connect("test.mosquitto.org", 1883, mqttcb, 
             conectado,
             function(client, reason) print("failed reason: "..reason) end)
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
  
end]]--
