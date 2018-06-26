local mqtt = require("mqtt_library")

function mqttcb (topic, message)
  print("Received from topic: " .. topic .. " - message:" .. message)
  if message == "pula" then
    pula = true
  elseif message == "mudaCor" then
    mudaCor = true
  end
end

function checar_colisao (x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function player (x,y,w,h)
  local rx, ry, rw, rh = x, y, w, h
  local jy = y
  return {
    draw =
      function ()
        if playerColour == "red" then
          love.graphics.setColor(204, 0, 0)
        else
          love.graphics.setColor(0, 204, 102)
        end
        love.graphics.rectangle("fill", rx, ry, rw, rh)
      end,
    update =
      function (dt)
        if gamestate == "preplaying" then
          ry = ry + 150 * dt
          if ry >= 400 then
            ry = 400
            gamestate = "playing"
          end
        end

        if pula == true then
          ry = ry + (100 * dt * jump)
          if ry <= 350 then
            jump = 1
          elseif ry >= 401 then
            jump = -1
            pula = false
          end
        end
        if mudaCor == true then
          if playerColour == "red" then
            playerColour = "green"
          else
            playerColour = "red"
          end
          mudaCor = false
        end
      end
  }
end

function platform (x,y,w,h)
  local originalx, originaly, rx, ry, rw, rh = x, y, x, y, w, h
  return {
    draw =
      function ()
        love.graphics.setColor(255, 255, 0)
        love.graphics.rectangle("fill", rx, ry, rw, rh)
      end,
    update =
      function (dt)
        if gamestate == "preplaying" or gamestate == "playing" then
          rx = rx - 300*dt
        end
        if rx <= 0 then
          rx = 0
        end
      end
  }
end

function enemy (enemy_type, x, y)
  local rx, ry, ry2 = x, y, y
  local width = 0
  return {
    draw =
      function (rand)
        if enemy_type == 1 then
          for i = 1, 10, 1 do
            --[[if rand [i] == 0 then
              love.graphics.setColor(204, 0, 0)
            else
              love.graphics.setColor(0, 204, 102)
            end]]--
            if i < 6 then
              love.graphics.setColor(204, 0, 0)
              love.graphics.rectangle("fill", rx + ((i-1)*100) , ry-(i*22), 40, 20)
            end
            if i > 5 then
              love.graphics.setColor(0, 204, 102)
              love.graphics.rectangle("fill", rx + ((i-1)*100) , ry+(i*22) - (11*22), 40, 20)
            end
          end

          for i = 0,36,1 do
            love.graphics.setColor(100, 100, 100)
            love.graphics.polygon("fill", rx+i*25, ry+20, (rx+15)+i*25, ry, (rx+30)+i*25, ry+20)
            love.graphics.setColor(255, 255, 255)
            love.graphics.polygon("line", rx+i*25, ry+20, (rx+15)+i*25, ry, (rx+30)+i*25, ry+20)
          end
        end
        if enemy_type == 2 then
          for i = 0,3,1 do
            love.graphics.setColor(r, g, b)
            love.graphics.rectangle("fill", rx + (i * 120), ry, 60, 40)
          end
        end
        if enemy_type == 3 then
          for i = 0,2,1 do
            love.graphics.setColor(100, 100, 100)
            love.graphics.polygon("fill", rx + (i * 200), ry2, (rx+15)+(i*200), ry2-30, (rx+30)+(i*200), ry2)
            love.graphics.setColor(255, 255, 255)
            love.graphics.polygon("line", rx + (i * 200), ry2, (rx+15)+(i*200), ry2-30, (rx+30)+(i*200), ry2)
            if rand[i] == 0 then
              love.graphics.setColor(204, 0, 0)
            else
            love.graphics.setColor(0, 204, 102)
            end          
            love.graphics.rectangle("fill", rx + (i * 200), ry-100, 30, 100)
          end
        end
      end,
    update =
      function (dt)
        if enemy_type == 1 then
          rx = rx - 100 * dt
          if rx <= -940 then
            enemyFlag = false
            randEnemy = math.random(1, 3)
            width = 0
            enemies[1] = enemy(1, 600, 407)
            enemies[2] = enemy(2, 600, 427)
            enemies[3] = enemy(3, 600, 427)
          end
        end
        if enemy_type == 2 then
          rx = rx - 100 * dt
          if rx <= -490 then
            enemyFlag = false
            randEnemy = math.random(1, 3)
            width = 0
            enemies[1] = enemy(1, 600, 407)
            enemies[2] = enemy(2, 600, 427)
            enemies[3] = enemy(3, 600, 427)
          end
        end
        if enemy_type == 3 then
          rx = rx - 100 * dt
          if rx <= -610 then
            enemyFlag = false
            randEnemy = math.random(1, 3)
            width = 0
            enemies[1] = enemy(1, 600, 407)
            enemies[2] = enemy(2, 600, 427)
            enemies[3] = enemy(3, 600, 427)
          end
          ry = ry + (100 * dt * dir)
          if ry <= 300 then
            dir = 1
          elseif ry >= 426 then
            dir = -1
          end
        end
      end
  }
end

function love.load()
  gamestate = "menu"
  love.window.setTitle("NIAB")
  w = 600
  h = 600
  love.window.setMode(w, h)
  player_x = 100
  player_y = 100
  animation = 0
  oscilation = 60
  player = player(player_x, player_y, 25, 25)
  platform = platform(600, 427, 1200, 40)
  enemies = {}
  enemies[1] = enemy(1, 600, 407)
  enemies[2] = enemy(2, 600, 427)
  enemies[3] = enemy(3, 600, 427)
  r = 192
  g = 210
  b = 255
  timeflow = -1
  dir = -1
  playerColour = "red"
  enemyFlag = false
  randEnemy = 0
  randFlag = false
  jump = -1
  fixFlag = true
  
  m = mqtt.client.create("test.mosquitto.org", 1883, mqttcb)
  m:connect("BernardoSnow")
  m:subscribe({"jump"})
  m:subscribe({"changeColour"})
end

function love.keypressed(key)
  if gamestate == "playing" then
    i = 0
  elseif gamestate == "menu" then
    if key == 'return' then
      gamestate = "preplaying"
    end
  else
    if key == 'return' then
      love.event.quit()
    end
  end
end

function love.update(dt)
  m:handler()
  math.randomseed(dt)
  if randFlag == false then
    randEnemy = math.random(1, 3)
    randFlag = true
  end
  player.update(dt)
  platform.update(dt)
  if gamestate == "preplaying" or gamestate == "playing" then
    r = r + (19.2 * dt * timeflow)
    g = g + (21.0 * dt * timeflow)
    b = b + (25.5 * dt * timeflow)
    if r <= 19.2 or g <= 21.0 or b <= 25.5 then
      timeflow = 1
    elseif r >= 192 or g >= 210 or b >= 255 then
      timeflow = -1
    end
    enemies[randEnemy].update(dt)
  end
end

function love.draw()
  if gamestate == "preplaying" or gamestate == "playing" then
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("fill", 0, 0, w, h)
    player.draw()
    platform.draw()
    if enemyFlag == false then
      randColour = {math.random(0, 1), math.random(0, 1), math.random(0, 1), math.random(0, 1), math.random(0, 1), math.random(0, 1), math.random(0, 1), math.random(0, 1), math.random(0, 1),          math.random(0, 1)}
      enemyFlag = true
    end
    
    enemies[randEnemy].draw(randColour)
  elseif gamestate == "menu" then
    love.graphics.setColor(192, 210, 255)
    love.graphics.rectangle("fill", 0, 0, w, h)
    love.graphics.setColor(204, 0, 0)
    love.graphics.setFont(love.graphics.newFont("CookieMonster.ttf", 70))
    love.graphics.print("Bem vindo a", w/10, h/8)
    love.graphics.setFont(love.graphics.newFont("the dark.ttf", 70))
    love.graphics.print("NIAB", w - 160, h/8)
  end
end
