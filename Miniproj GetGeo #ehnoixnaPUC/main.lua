mqtt = require("mqtt_library")

wificonf = {
  -- verificar ssid e senha
  ssid = "reativos",
  pwd = "reativos",
  save = false
}

function publica(c)
  c:publish("alos","alo do nodemcu!",0,0, 
            function(client) print("mandou!") end)
end

function conectado (client)
  publica(client)
  client:subscribe("alos", 0, novaInscricao)
end

function love.load()
  controle = false
  --mqtt_client = mqtt.client.create("test.mosquitto.org", 1883, mqttcb)
  --mqtt_client:connect("1511651")
  --mqtt_client:subscribe({"apertou-tecla"})
  ret1 = retangulo(50, 200, 200, 150)
  
  wifi.sta.config(wificonf)
  print("modo: ".. wifi.setmode(wifi.STATION))
  print(wifi.sta.getip())
  
  sw1 = 1
  gpio.mode(sw1,gpio.INT,gpio.PULLUP)
  m = mqtt.Client("test.mosquitto.org", 120)
  m:connect("1511651", 1883, mqttcb, 
             conectado,
             function(client, reason) print("failed reason: "..reason) end)
  
end

-- Print AP list that is easier to read
function listap(t) -- (SSID : Authmode, RSSI, BSSID, Channel)
    local table_macs = {}
    local table_ss = {}
    local table_channels = {}
--    print("\n"..string.format("%32s","SSID").."\tBSSID\t\t\t\t  RSSI\t\tAUTHMODE\tCHANNEL")
    wifi_ap = [[{ "wifiAccessPoints":[]]
    for ssid,v in pairs(t) do
        local authmode, rssi, bssid, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]+)")
--        print(string.format("%32s",ssid).."\t"..bssid.."\t  "..rssi.."\t\t"..authmode.."\t\t\t"..channel)
        table.insert(table_macs, bssid)
        table.insert(table_ss, rssi)
        table.insert(table_channels, channel)
    end
    for i = 1,#table_macs do
        mac_adress = [[{ "macAddress": "]] .. table_macs[i] .. [[", ]]
        ss = [["signalStrength": ]] .. table_ss[i] .. [[, ]]
        channel = [["channel": ]] .. table_channels[i] .. [[}]]
        mac_adress = mac_adress .. ss
        mac_adress = mac_adress .. channel
        if i < #table_macs then
           mac_adress = mac_adress .. [[,]]
        end
        wifi_ap = wifi_ap .. mac_adress
        i = i + 1
    end
    end_ap =[[] }]]
    wifi_ap = wifi_ap .. end_ap
    --print(wifi_ap)
end

gpio.trig(sw1, "down", wifi.sta.getap(listap))
--print(wifi_ap)

http.post('https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyAyaHaY12hoag35S-Tdy4WD5XxT5WsprPY',
  'Content-Type: application/json\r\n',
  wifi_ap,
  function(code, data)
    if (code < 0) then
      print("HTTP request failed :", code)
    else
      print(code, data)
    end
  end)

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

function novaInscricao (c)
  local msgsrec = 0
  function novamsg (c, t, m)
    print ("mensagem ".. msgsrec .. ", topico: ".. t .. ", dados: " .. m)
    msgsrec = msgsrec + 1
  end
  c:on("message", novamsg)
end
