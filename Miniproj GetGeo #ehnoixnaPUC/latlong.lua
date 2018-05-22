wificonf = {
  -- verificar ssid e senha
  ssid = "Bernardo's iPhone",
  pwd = "12345678",
  got_ip_cb = function (iptable) print ("ip: ".. iptable.IP) end,
  save = false
}

wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)

sw1 = 1
gpio.mode(sw1,gpio.INT,gpio.PULLUP)

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
    
end

local m = mqtt.Client("1511651", 120)

function publica(c, msg)
  print(msg)
  c:publish("latlong", msg ,0,0, 
            function(client) print("localizacao enviada!") end)
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
  publica(client)
  client:subscribe("latlong", 0, novaInscricao)
end 

m:connect("test.mosquitto.org", 1883, 0, 
             conectado,
             function(client, reason) print("failed reason: "..reason) end)

--[[
function callback()
    wifi.sta.getap(listap)
    print(wifi_ap)
    http.post('https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyAcBMESee5T5HXZvd3oVoix4qMfJBgd0fM',
  'Content-Type: application/json\r\n',
  wifi_ap,
  function(code, data)
    if (code < 0) then
      print("HTTP request failed :", code)
    else
      print(code, data)
      if data == nil then
        return
      end
      local i, j = string.find(data, '"lat": ')
      local v1 = string.find(data, ',')
      local lat = string.sub(data, j+1, v1-1)
      i, j = string.find(data, '"lng": ')
      local v2 = string.find(data, ',', v1+1)
      local long = string.sub(data, j+1, v2-3)
      message = lat.. ' '..long
      print(message)
      publica(c)
    end
  end)
end]]--
local tentativas = 5
local function postCallback(code, data)
    if code < 0 or data == nil then 
        tentativas = tentativas - 1
        if tentativas > 0 then
            http.post('https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyAcBMESee5T5HXZvd3oVoix4qMfJBgd0fM',
                      'Content-Type: application/json\r\n',
                       wifi_ap, postCallback(code, data))
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
--    while true do
      wifi.sta.getap(listap)
--      if wifi_ap ~= nil then
--        break
--      end 
--    end
    print("wifi: ")
    print(wifi_ap)
    print("vrau")
    http.post('https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyAcBMESee5T5HXZvd3oVoix4qMfJBgd0fM',
      'Content-Type: application/json\r\n',
      wifi_ap, postCallback)
end

gpio.trig(sw1, "down", callback)


--wifi.sta.getap(listap)
