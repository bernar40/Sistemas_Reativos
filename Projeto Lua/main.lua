function wait (sec, objeto)
--  objeto.state = 0
  objeto.wait_until = current_time+sec
  coroutine.yield()
end

function inimigo (x1,y1,x2,y2,x3,y3, vel, id)
      local px1 = x1
      local py1 = y1
      local px2 = x2
      local py2 = y2
      local px3 = x3
      local py3 = y3
      local hitbox_px = x1 - (x2-x1)/2
      local hitbox_py = y1 - (y3-y1)/2
      local width = (x2-x1)
      local height = (y3-y1)
      local is_hit = 0
  return {
    update = coroutine.wrap (function (self, dt)
      local width, height = love.graphics.getDimensions()
      while true do
 --       for n,enemy in ipairs(enemies) do
          px1 = px1 + vel*dt
          px2 = px2 + vel*dt
          px3 = px3 + vel*dt
          if px1 > width then 
            px1 = 0
            px2 = 25
            px3 = 12.5
          end
        hitbox_px = (px1- (px2-px1)/2) + vel*dt
        wait(vel/1000, self)
      end
    end),
    collisao = 
      function()
        for n, missil in ipairs(misseis) do
          if checar_colisao(missil.hitbox_px, missil.hitbox_py, missil.width, missil.height, hitbox_px, hitbox_py, width, height) then
            table.remove (inimigos, id)
            table.remove(misseis, n)
            break
          end
        end
      end,
    draw =
      function ()
        if is_hit == 0 then
          love.graphics.setColor (255,0,0)
          love.graphics.polygon("fill", px1, py1, px2, py2, px3, py3)
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
      hitbox_px = x,
      hitbox_py = y,
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
  k=1
  j = 1
  for i=1, 15 do
    if i<6 then
      k = 1
    elseif i>5 and i<11 then
      k = 2
    else
      k = 3
    end
    if j%5==0 then
      j=0
    end
    inimigos[i] = inimigo(0+(j*100), 100*k, 25+(j*100), 100*k, 12.5+(j*100), (100*k)+25, 25,i)
    j = j+1
  end
end
    
function love.keypressed(key)
  player.keypressed(key)
end

function love.update(dt)
  current_time = love.timer.getTime()
  player.update(dt)
  for n, inimigo in ipairs(inimigos) do
      inimigos[n].update(inimigos[n], dt)
      inimigos[n].collisao()
  end
  for i, missil in ipairs(misseis) do
    missil_move(dt, missil)
  end
  for i, missil in ipairs(misseis) do
    if missil.py < 0 then -- remocao de misseis--     
      table.remove(misseis, i)
    end
  end
end

function love.draw()
  love.graphics.setColor (0,255,0)
  love.graphics.rectangle("fill", 0, 575, 800, 25)
  player.draw()
  for n, inimigo in ipairs(inimigos) do
      inimigos[n].draw()
  end
  for i, missil in ipairs(misseis) do
    love.graphics.setColor (255,255,0)
    love.graphics.circle("fill", missil.px, missil.py, 5)
  end
end

--[[ Fazer um ID pros inimigos, para quando deletar na colisao eles serem deletados pelo id. 
     Por que o for eh do n do missil, entao nao pode por table.remove(inimigos, n). ]]--

