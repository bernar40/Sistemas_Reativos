sw1 = 1
sw2 = 2
led_r = 3
led_g = 6
ledstate = 0
gpio.mode(led_g, gpio.OUTPUT)
gpio.mode(led_r, gpio.OUTPUT)
gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.mode(sw2,gpio.INT,gpio.PULLUP)

local m = mqtt.Client("1511651", 120)


function publica(c, Msg, subject)
  pub = c:publish(subject, Msg ,0,0, 
            function(client, reason) print( Msg .. " enviada!") end)
    gpio.write(led_r, gpio.LOW)
    gpio.write(led_g, gpio.LOW)

end

function conectado (c)
    c:publish("Sucesso", "NodeMCU Conectou.", 0,  0, 
                  function(client, reason) print("Conexão estabelecida") end)
end

function Button_pressed1()
    local delay = 500000
    local last = 0
    return
    function (level, timestamp)
        local now = tmr.now()
        if now - last < delay then return end
            last = now
            gpio.write(led_g, gpio.HIGH)
            publica(m, "pula", "jump")
    end
end
gpio.trig(sw1, "down", Button_pressed1())

function Button_pressed2()
    
    local delay = 500000
    local last = 0
    return
    function (level, timestamp)
        local now = tmr.now()
        if now - last < delay then return end
            last = now
            publica(m, "mudaCor", "changeColour")
            ledstate = !ledstate
            led(ledstate)
    end
end
gpio.trig(sw2, "down", Button_pressed2())

m:connect("test.mosquitto.org", 1883, 0, 
             conectado,
             function(client, reason) print("failed reason: "..reason) end)
 
function led(ledstate)
  if ledstate == 0 then
    gpio.write(led_r, gpio.LOW)
    gpio.write(led_g, gpio.HIGH)
  elseif ledstate == 1 then
    gpio.write(led_r, gpio.HIGH)
    gpio.write(led_g, gpio.LOW)
  end
end