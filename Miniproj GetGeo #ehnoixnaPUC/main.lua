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
end
wifi.sta.getap(listap)
print(wifi_ap)

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
