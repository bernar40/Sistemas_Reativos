local mqtt = require("mqtt_library")

function mqttcb (topic, message)
  print("Received from topic: " .. topic .. " - message:" .. message)
  if message == "pula" then
    pula = true
  elseif message == "mudaCor" then
    mudaCor = true
  end
end

function checar_colisao2 (x1, y1, w1, x2, w2)
  return x1 < x2+w2 and x2 < x1+w1 and y1>=400
end

function checar_colisao3 (x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function player (x,y,w,h)
  local rx, ry, rw, rh = x, y, w, h
  local jy = y
  return {
    draw =
      function ()
        if playerColour == 0 then
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
          player_y = ry
          if ry <= 350-(5*velocidade) then
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
      end,
    keypressed = 
      function (key)
        if key == "left" then
          mudaCor = true
          if mudaCor == true then
            if playerColour == 0 then
              playerColour = 1
            else
              playerColour = 0
            end
            mudaCor = false
          end
        end
        if key == "right" then
          pula = true
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
  local ry_t = {0, 0, 0}
  local dir = {1, 1, 1}
  return {
    draw =
      function (rand)
        if enemy_type == 1 then
          for i = 1, 10, 1 do
            if rand [i] == 0 then
              love.graphics.setColor(204, 0, 0)
            else
              love.graphics.setColor(0, 204, 102)
            end
              love.graphics.rectangle("fill", rx + ((i-1)*130) , ry-100, 80, 200)
              table.insert(enemy1_x1, rx + ((i-1)*130))
              table.insert(enemy1_y1, ry-100)
              table.insert(enemy1_w, 80)
              table.insert(enemy1_h, 200)
          end
        end
        if enemy_type == 2 then
          for i = 1,4,1 do
            love.graphics.setColor(r, g, b)
            love.graphics.rectangle("fill", rx + (i * 120), ry, 60, 40)
            table.insert(enemy2_x1, rx + (i * 120))
            table.insert(enemy2_y1, ry)
            table.insert(enemy2_w, 60)
            table.insert(enemy2_h, 40)
          end
        end
        if enemy_type == 3 then
          for i = 1,3,1 do
            love.graphics.setColor(100, 100, 100)
            love.graphics.polygon("fill", rx + (i * 200), ry2, (rx+15)+(i*200), ry2-30, (rx+30)+(i*200), ry2)
            love.graphics.setColor(0, 0, 0)
            love.graphics.polygon("line", rx + (i * 200), ry2, (rx+15)+(i*200), ry2-30, (rx+30)+(i*200), ry2)
            table.insert(enemy4_x1, rx + (i * 200))
            table.insert(enemy4_y1, ry2+30)
            table.insert(enemy4_w, 30)
            table.insert(enemy4_h, 30)
            if rand[i] == 0 then
              love.graphics.setColor(204, 0, 0)
            else
            love.graphics.setColor(0, 204, 102)
            end          
            love.graphics.rectangle("fill", rx + (i * 200), ry_t[i]-100, 30, 100)
            table.insert(enemy3_x1, rx + (i * 200))
            table.insert(enemy3_y1, ry_t[i]-100)
            table.insert(enemy3_w, 30)
            table.insert(enemy3_h, 100)
          end
        end
      end,
    update =
      function (dt)
        if enemy_type == 1 then
          rx = rx - 100 * dt
          for i = 1, 10, 1 do
            if enemy1_x1[i] ~= nil then
              enemy1_x1[i] = enemy1_x1[i] - 100 * dt
            end
          end
          if rx <= -1310 then
            enemyFlag = false
            randEnemy = math.random(1, 3)
            width = 0
            enemies[1] = enemy(1, 600, 407)
            enemies[2] = enemy(2, 600, 427)
            enemies[3] = enemy(3, 600, 427)
            enemy1_x1 = {}
            enemy1_y1 = {}
            enemy1_w = {}
            enemy1_h = {}
            score=score+1

          end
        end
        if enemy_type == 2 then
          rx = rx - 100 * dt
          for i = 1, 4, 1 do
            if enemy2_x1[i] ~= nil then
              enemy2_x1[i] = enemy2_x1[i] - 100 * dt
            end
          end
          if rx <= -490 then
            enemyFlag = false
            randEnemy = math.random(1, 3)
            width = 0
            enemies[1] = enemy(1, 600, 407)
            enemies[2] = enemy(2, 600, 427)
            enemies[3] = enemy(3, 600, 427)
            enemy2_x1 = {}
            enemy2_y1 = {}
            enemy2_w = {}
            enemy2_h = {}
            score=score+1

          end
        end
        if enemy_type == 3 then
          rx = rx - 100 * dt
          if enemy3_x1[1] ~= nil then
            enemy3_x1[1] = enemy3_x1[1] - 100 * dt
          end
          if enemy3_x1[2] ~= nil then
            enemy3_x1[2] = enemy3_x1[2] - 100 * dt
          end
          if enemy3_x1[1] ~= nil then
            enemy3_x1[3] = enemy3_x1[3] - 100 * dt
          end
          if enemy4_x1[1] ~= nil then
            enemy4_x1[1] = enemy4_x1[1] - 100 * dt
          end
          if enemy4_x1[2] ~= nil then
            enemy4_x1[2] = enemy4_x1[2] - 100 * dt
          end
          if enemy4_x1[3] ~= nil then
            enemy4_x1[3] = enemy4_x1[3] - 100 * dt
          end
          if rx <= -610 then
            enemyFlag = false
            randEnemy = math.random(1, 3)
            width = 0
            enemies[1] = enemy(1, 600, 407)
            enemies[2] = enemy(2, 600, 427)
            enemies[3] = enemy(3, 600, 427)
            enemy3_x1 = {}
            enemy3_y1 = {}
            enemy3_w = {}
            enemy3_h = {}
            enemy4_x1 = {}
            enemy4_y1 = {}
            enemy4_w = {}
            enemy4_h = {} 
            score=score+1
          end
          for i = 1, 3, 1 do
            ry_t[i] = ry_t[i] + (100 * dt * dir[i] *randMove[i])
            if ry_t[i] <= 300 then
              dir[i] = 1
            elseif ry_t[i] >= 426 then
              dir[i] = -1
            end
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
  player_w = 25
  player_h = 25
  animation = 0
  oscilation = 60
  randMove = {1, 1, 1}
  player = player(player_x, player_y, 25, 25)
  player_y = 401
  platform = platform(600, 427, 1200, 40)
  enemies = {}
  enemies[1] = enemy(1, 600, 401)
  enemies[2] = enemy(2, 600, 427)
  enemies[3] = enemy(3, 600, 427)
  r = 192
  g = 210
  b = 255
  timeflow = -1
  score = 0
  dir = -1
  playerColour = 1
  enemyFlag = false
  velocidade = 1
  randEnemy = 0
  randFlag = false
  jump = -1
  fixFlag = true
  enemy1_x1 = {}
  enemy1_y1 = {}
  enemy1_w = {}
  enemy1_h = {}
  enemy2_x1 = {}
  enemy2_y1 = {}
  enemy2_w = {}
  enemy2_h = {} 
  enemy3_x1 = {}
  enemy3_y1 = {}
  enemy3_w = {}
  enemy3_h = {}
  enemy4_x1 = {}
  enemy4_y1 = {}
  enemy4_w = {}
  enemy4_h = {}

  
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
  player.keypressed(key)

end

function love.update(dt)
  m:handler()
  math.randomseed(dt*velocidade)
  if randFlag == false then
    randEnemy = math.random(1, 3)
    randFlag = true
  end
  player.update(dt*velocidade)
  platform.update(dt*velocidade)
  if gamestate == "preplaying" or gamestate == "playing" then
    r = r + (19.2 * dt * timeflow)
    g = g + (21.0 * dt * timeflow)
    b = b + (25.5 * dt * timeflow)
    if r <= 19.2 or g <= 21.0 or b <= 25.5 then
      timeflow = 1
    elseif r >= 192 or g >= 210 or b >= 255 then
      timeflow = -1
    end
    enemies[randEnemy].update(dt*velocidade)
    for i = 1, 10, 1 do
      if enemy1_w[i] ~= nil then
        if checar_colisao2(player_x, player_y, player_w, enemy1_x1[i], enemy1_w[i]) then
          if (playerColour ~= randColour[i]) then
            --gamestate = 'gameover'
          end
        end
      end
    end
    for i = 1, 4, 1 do
      if enemy2_w[i] ~= nil then
        if checar_colisao2(player_x, player_y, 0, enemy2_x1[i], enemy2_w[i]) then
          --gamestate = 'gameover'
          end
      end
    end
    for i = 1, 3, 1 do
      if enemy3_w[i] ~= nil then
        if checar_colisao3(player_x, player_y, player_w, player_h, enemy3_x1[i], enemy3_y1[i], enemy3_w[i], enemy3_h[i]) then
          if (playerColour ~= randColour[i]) then
          --gamestate = 'gameover'
          end
        end
      end
      if enemy4_w[i] ~= nil then
        if checar_colisao2(player_x, player_y, player_w, enemy4_x1[i], enemy4_w[i]) then
          --gamestate = 'gameover'
          end
      end
    end
  end

end

function love.draw()
  if gamestate == "preplaying" or gamestate == "playing" then
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("fill", 0, 0, w, h)
    player.draw()
    platform.draw()
    if enemyFlag == false then
        if score > 0 and score%2 == 0 then
          velocidade = velocidade + 0.2
        end
      randColour = {math.random(0, 1), math.random(0, 1), math.random(0, 1), math.random(0, 1), math.random(0, 1), math.random(0, 1), math.random(0, 1), math.random(0, 1), math.random(0, 1), math.random(0, 1)}
      randMove = {math.random(1, 3), math.random(1, 3), math.random(1, 3)}
      enemyFlag = true
    end
    
    enemies[randEnemy].draw(randColour)
  elseif gamestate == "menu" then
    love.graphics.setColor(192, 210, 250)
    love.graphics.rectangle("fill", 0, 0, w, h)
    love.graphics.setColor(204, 0, 0)
    love.graphics.setFont(love.graphics.newFont("PXFXshadow-3.ttf", 70))
    love.graphics.print("Bem vindo a", w/10-20, h/8)
    love.graphics.print("NIAB", w - 180, h/8)
    love.graphics.rectangle("line", w-180, h/8+60, 150, 5)

  elseif gamestate == "gameover" then
    love.graphics.setColor(192, 210, 255)
    love.graphics.rectangle("fill", 0, 0, w, h)
    love.graphics.setColor(204, 0, 0)
    love.graphics.print("GAME", w/8, h/8)
    love.graphics.print("OVER", w - 350, h/8)
    love.graphics.print("score: ",  w - 350, h/2)
    love.graphics.print(score,  w - 130, h/2)
  end
end
