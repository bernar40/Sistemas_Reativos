ledstate = false
timeinterval = 1000
buttoninterval = 500
button1time = 0
button2time = 0

led1 = 3
led2 = 6
sw1 = 1
sw2 = 2

gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)

gpio.write(led1, gpio.LOW);
gpio.write(led2, gpio.LOW);

gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.mode(sw2,gpio.INT,gpio.PULLUP)

function turnoff()
  gpio.write(led1, gpio.LOW)
  tmr.stop(mytimer)
end

function rapidon ()
  local delay = 500000
  local last = 0
  return
  function (level, timestamp)
    local now = tmr.now()
    if now - last < delay then return end
    button1time = now
    
    if now - button2time < buttoninterval then
      turnoff()
      return
    end
    
    timeinterval = timeinterval - 200
    tmr.interval(mytimer, timeinterval)
  end
end

function devagaron ()
  local delay = 500000
  local last = 0
  return
  function (level, timestamp)
    local now = tmr.now()
    if now - last < delay then return end
    button2time = now
    
    if now - button1time < buttoninterval then
      turnoff()
      return
    end
    
    timeinterval = timeinterval + 200
    tmr.interval(mytimer, timeinterval)
  end
end

function lafuriosa()
  if ledstate then
    gpio.write(led1, gpio.HIGH)
  else
    gpio.write(led1, gpio.LOW)
  end
  ledstate = not ledstate
end

--[[
function (level, timestamp)
  local now = tmr.now()
  if now - last < delay then return end
  last = now
  ledstate =  not ledstate
  if ledstate then 
    gpio.write(led, gpio.HIGH);
  else
    gpio.write(led, gpio.LOW);
  end
end
]]--

--gpio.trig(sw1, "down", newpincb(led1))
--gpio.trig(sw2, "down", newpincb(led2))

--tmr.alarm(led1, 1000, tmr.ALARM_AUTO, lafuriosa())

mytimer = tmr.create()

tmr.register(mytimer, timeinterval, tmr.ALARM_AUTO, lafuriosa)
tmr.start(mytimer)

gpio.trig(sw1, "down", rapidon())
gpio.trig(sw2, "down", devagaron())
