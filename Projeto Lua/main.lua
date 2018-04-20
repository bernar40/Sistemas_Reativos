function wait (sec, objeto)
--  objeto.state = 0
  objeto.wait_until = current_time+sec
  coroutine.yield()
end

function inimigo (x1,y1,x2,y2,x3,y3, vel, enemies)
  table.insert(enemies, {
      px1 = x1,
      py1 = y1,
      px2 = x2,
      py2 = y2,
      px3 = x3,
      py3 = y3,
      hitbox_px = x1 - (x2-x1)/2,
      hitbox_py = y1 - (y3-y1)/2,
      width = (x2-x1),
      height = (y3-y1),
      is_hit = 0
    })
  return {
    update = coroutine.wrap (function (self, dt, enemy)
      local width, height = love.graphics.getDimensions()
      while true do
 --       for n,enemy in ipairs(enemies) do
          enemy.px1 = enemy.px1 + vel*dt
          enemy.px2 = enemy.px2 + vel*dt
          enemy.px3 = enemy.px3 + vel*dt
          if enemy.px1 > width then 
            enemy.px1 = x1
            enemy.px2 = x2
            enemy.px3 = x3
          end
        enemy.hitbox_px = (enemy.px1- (enemy.px2-enemy.px1)/2) + vel*dt
        wait(vel/1000, self)
 --       end
      end
    end),
    draw =
      function ()
        for i, enemy in ipairs(enemies) do
          if enemy.is_hit == 0 then
            love.graphics.setColor (255,0,0)
            love.graphics.polygon("fill", enemy.px1, enemy.py1, enemy.px2, enemy.py2, enemy.px3, enemy.py3)
          end
        end
      end
  }
end

function player (x,y,w,h)
  local originalx, originaly, rx, ry, rw, rh = x, y, x, y, w, h
  return {
    draw =
      function ()
        love.graphics.setColor (0,0,255)
        love.graphics.rectangle("fill", rx, ry, rw, rh)
      end,
    update =
      function (dt)
        local mx, my = love.mouse.getPosition()
        if love.keyboard.isDown("right") then
          rx = rx + 200*dt
        elseif love.keyboard.isDown("left") then
          rx = rx - 200*dt
        end
        player_x = rx
        player_y = ry
      end,
    keypressed = 
      function(key)
        if key == "up" then
          missil_spawn(misseis)
        end
      end
  }
end

function missil_spawn(misseis)
  x = player_x + (25)/2
  y = player_y + (25)/2
  table.insert(misseis, {
      px = x,
      py = y,
      hitbox_px = x - 5/2,
      hitbox_py = y - 5/2,
      width = 10,
      height = 10
    })
end

function missil_move(dt, tab)
  tab.py = tab.py - 300 * dt
  tab.hitbox_py = tab.py
end

function checar_colisao (x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function love.load()
  player_x = 375
  player_y = 525
  misseis = {}
  enemies = {}
  inimigos = {}
  is_hit = {}
  player = player(player_x, player_y, 25, 25)
  for i=1, 5 do
    inimigos[i] = inimigo(100+(i*100), 100, 125+(i*100), 100, 112.5+(i*100), 125, 500, enemies)
    is_hit[i] = 0
  end
end
    
function love.keypressed(key)
  player.keypressed(key)
end

function love.update(dt)
  current_time = love.timer.getTime()
  player.update(dt)
  for n, enemy in ipairs(enemies) do
    if enemy.is_hit == 0 then
      inimigos[n].update(inimigos[n], dt, enemy)
    end
  end
  for i, missil in ipairs(misseis) do
    missil_move(dt, missil)
  end
  for i, missil in ipairs(misseis) do
    if missil.py < 0 then -- remocao de misseis--     
      table.remove(misseis, i)
    else
      for n, enemy in ipairs(enemies) do
        if checar_colisao(missil.hitbox_px, missil.hitbox_py, missil.width, missil.height, enemy.hitbox_px, enemy.hitbox_py, enemy.width, enemy.height) then
--          table.remove(inimigos, n)
--          is_hit[n] = 1
          enemy.is_hit = 1
          table.remove(enemies, n)
          table.remove(misseis, i)
          break
        end
      end
    end
  end
end

function love.draw()
  love.graphics.setColor (0,255,0)
  love.graphics.rectangle("fill", 0, 575, 800, 25)
  player.draw()
  for n, enemy in ipairs(enemies) do
    if enemy.is_hit == 0 then
      inimigos[n].draw()
    end
  end
  for i, missil in ipairs(misseis) do
    love.graphics.setColor (255,255,0)
    love.graphics.circle("fill", missil.px, missil.py, 5)
  end

end
