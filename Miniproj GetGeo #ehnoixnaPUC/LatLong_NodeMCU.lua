sw1 = 1
led_r = 3
led_g = 6
gpio.mode(led_g, gpio.OUTPUT)
gpio.mode(led_r, gpio.OUTPUT)
gpio.mode(sw1,gpio.INT,gpio.PULLUP)

local m = mqtt.Client("1511651", 120)

function publica(c, localizacaoMsg)
  pub = c:publish("latlong", localizacaoMsg ,0,0, 
            function(client, reason) print("localizacao enviada!") end)
  if pub == 1 then
    print("Localizacao publicada")
  else
    print("Erro na publicacao")
  end
end


function Love_callback(c)
    local function mensagemLove(userdata, topic, message)
            if(message == "Pedido de localizacao") then
                gpio.write(led_r, gpio.HIGH)
                wifi.sta.getap(listap)
            end
    end
    c:on("message",mensagemLove)
end


function conectado (c)
    c:publish("Sucesso", "NodeMCU Conectou.", 0,  0, 
                  function(client, reason) print("Conexão estabelecida") end)
    c:subscribe("PedidoLove", 0, Love_callback)
end 

function Parse_Data(data)
      local i, j = string.find(data, '"lat": ')
      local v1 = string.find(data, ',')
      local lat = string.sub(data, j+1, v1-1)
      i, j = string.find(data, '"lng": ')
      local v2 = string.find(data, ',', v1+1)
      local long = string.sub(data, j+1, v2-3)
      localizacaoMsg = lat.. ' '..long
      return localizacaoMsg
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
    
    print(wifi_ap)
    
    local tentativas = 5
    local function callbackPost(code,data)
            if (code < 0) or (code == 411) then
                print("HTTP request failed :", code)
                tentativas = tentativas - 1
                print("Numeros de tentativas restantes: " .. tentativas)
                if(tentativas > 0) then
                   http.post('https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyAyaHaY12hoag35S-Tdy4WD5XxT5WsprPY',
                    'Content-Type: application/json\r\n',wifi_ap,callbackPost)
                end
            else
                print(code, data)
                localizacaoMsg = Parse_Data(data)
                publica(m, localizacaoMsg)
            end
    end

    http.post('https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyAyaHaY12hoag35S-Tdy4WD5XxT5WsprPY',
      'Content-Type: application/json\r\n',wifi_ap,callbackPost)
      gpio.write(led_g, gpio.LOW)
      gpio.write(led_r, gpio.LOW)
end

function Button_pressed()
    local delay = 500000
    local last = 0
    return
    function (level, timestamp)
        local now = tmr.now()
        if now - last < delay then return end
            last = now
            gpio.write(led_g, gpio.HIGH)
            wifi.sta.getap(listap)
    end
end
gpio.trig(sw1, "down", Button_pressed())

m:connect("test.mosquitto.org", 1883, 0, 
             conectado,
             function(client, reason) print("failed reason: "..reason) end)

