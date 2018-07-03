--[[wificonf = {
  -- verificar ssid e senha
  ssid = "Familia_Ruga",
  pwd = "2419182715",
  got_ip_cb = function (iptable) print ("ip: ".. iptable.IP) end,
  save = false
}


wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)]]--

wificonf = {
  -- verificar ssid e senha
  ssid = "Bernardo's iPhone",
  pwd = "12345678",
  got_ip_cb = function (iptable) print ("ip: ".. iptable.IP) end,
  save = false
}


wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)

