function player (x,y,w,h)
  local rx, ry, rw, rh = x, y, w, h
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
        if oscilation <= 0 and gamestate == "preplaying" then
          oscilation = 0
          gamestate = "playing"
        end
        if gamestate == "preplaying" and animation == 0 then
          if ry <= 400 then
            ry = ry + 200 * dt
          else
            animation = 1
            seq = 1
            oscilation = oscilation - 20
          end
        end
        if animation == 1 then
          if seq == 1 then
            for i = 0, oscilation, 1 do
              ry = ry - 20 * dt
            end
            animation = 0
          end
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

function enemies (enemy_type, x, y)
  local rx, ry = x, y
  return {
    draw =
      function (rand)
        
        if enemy_type == 1 then
          if rand[1] == 0 then
            love.graphics.setColor(204, 0, 0)
          else
            love.graphics.setColor(0, 204, 102)
          end          
          love.graphics.rectangle("fill", rx, ry, 40, 20)
          if rand[2] == 0 then
            love.graphics.setColor(204, 0, 0)
          else
            love.graphics.setColor(0, 204, 102)
          end          
          love.graphics.rectangle("fill", rx + 60, ry - 40, 40, 20)
          if rand[3] == 0 then
            love.graphics.setColor(204, 0, 0)
          else
            love.graphics.setColor(0, 204, 102)
          end
          love.graphics.rectangle("fill", rx + 120, ry - 80, 40, 20)
          if rand[4] == 0 then
            love.graphics.setColor(204, 0, 0)
          else
            love.graphics.setColor(0, 204, 102)
          end          
          love.graphics.rectangle("fill", rx + 180, ry - 40, 40, 20)
          if rand[5] == 0 then
            love.graphics.setColor(204, 0, 0)
          else
            love.graphics.setColor(0, 204, 102)
          end          
          love.graphics.rectangle("fill", rx + 240, ry, 40, 20)
          for i = 0,8,1 do
            love.graphics.setColor(100, 100, 100)
            love.graphics.polygon("fill", rx+i*30, ry+60, (rx+15)+i*30, ry+30, (rx+30)+i*30, ry+60)
            love.graphics.setColor(255, 255, 255)
            love.graphics.polygon("line", rx+i*30, ry+60, (rx+15)+i*30, ry+30, (rx+30)+i*30, ry+60)
          end
        end
      
      end,
    update =
      function (dt)
        if enemy_type == 1 then
          rx = rx - 100 * dt
          if rx <= -280 then
            enemyFlag = false
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
  player_y = 0
  animation = 0
  oscilation = 60
  player = player(player_x, player_y, 25, 25)
  platform = platform(600, 428, 1200, 40)
  enemies = enemies(1, 600, 368)
  r = 192
  g = 210
  b = 255
  timeflow = -1
  playerColour = "red"
  enemyFlag = false
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
  math.randomseed(dt)
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
    enemies.update(dt)
  end
end

function love.draw()
  if gamestate == "preplaying" or gamestate == "playing" then
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("fill", 0, 0, w, h)
    player.draw()
    platform.draw()
    if enemyFlag == false then
      randColour = {math.random(0, 1), math.random(0, 1), math.random(0, 1), math.random(0, 1), math.random(0, 1)}
      enemyFlag = true
    end
    
    enemies.draw(randColour)
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
