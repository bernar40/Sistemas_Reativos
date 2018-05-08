wificonf = {
  -- verificar ssid e senha
  ssid = "reativos",
  pwd = "reativos",
  save = false
}

wifi.sta.config(wificonf)
print("modo: ".. wifi.setmode(wifi.STATION))
print(wifi.sta.getip())
