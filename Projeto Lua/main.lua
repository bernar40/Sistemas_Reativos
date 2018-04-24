function wait (sec, objeto)
  objeto.state = 0 --inativo
  objeto.wait_until = current_time+sec
  coroutine.yield()
end

function inimigo (x1,y1,x2,y2,x3,y3, vel, num)
      local state = 1
      local id = num
      local px1 = x1
      local py1 = y1
      local px2 = x2
      local py2 = y2
      local px3 = x3
      local py3 = y3
      local width = (px2-px1)
      local height = (py3-py1)/2 -- ou 1 para matar apenas no topo
      local hitbox_px = px1
      local hitbox_py = py1
      local is_hit = 0
  return {
    wait_until = 0,
    update = coroutine.wrap (function (self, dt, n)
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
        hitbox_px = px1 + vel*dt
        inimigo_x[n] = px3
        inimigo_y[n] = py1
        wait(1/1000000000000, self)
      end
    end),
    collisao = 
      function(i)
        for n, missil in ipairs(misseis) do
          if checar_colisao(missil.hitbox_px, missil.hitbox_py, missil.width, missil.height, hitbox_px, hitbox_py, width, height) then
            is_hit = 1
            qtd_missil = qtd_missil + 1
            table.remove(inimigo_x, i)
            table.remove(inimigo_x, i)
            table.remove(misseis, n)
            invaderkilled:play()
            qtd_inimigos = qtd_inimigos - 1
            break
          end
        end
      end,
    draw =
      function ()
        if is_hit == 0 then
          love.graphics.setColor (255,0,0)
          love.graphics.polygon("fill", px1, py1, px2, py2, px3, py3)
        else
          hitbox_px = 0
          hitbox_py = 0
          width = 0
          height = 0
        end
      end,
    missil_ini = 
      function(n)
          if is_hit == 0 then
            missil_inimigo_spawn(misseis_inimigos, inimigo_x, inimigo_y, n) --math.random(1,#inimigos))
            tempo_missil = math.random(0.5,2)
          else
            tempo_missil = 0
          end
      end,
    is_active = 
      function ()
        if state == 1 then
          return true
        else
          return false
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
          if qtd_missil > 0 then
            qtd_missil = qtd_missil - 1
            missil_spawn(misseis)
          end
        end
      end
  }
end

function missil_inimigo_spawn(misseis_ini, inimigo_x, inimigo_y, n)
  x = inimigo_x[n]
  y = inimigo_y[n]
  table.insert(misseis_ini, {
      px = x,
      py = y,
      hitbox_px = x-5,
      hitbox_py = y,
      width = 10,
      height = 3
    })
  shoot_enemy:play()
end

function missil_spawn(misseis)
  x = player_x + 12.5
  y = player_y + 12.5
  table.insert(misseis, {
      px = x,
      py = y,
      hitbox_px = x-5,
      hitbox_py = y,
      width = 10,
      height = 3
    })
  shoot_ship:play()
end

function missil_move(dt, tab)
  tab.py = tab.py - 300 * dt
  tab.hitbox_py = tab.py
end

function missil_inimigo_move(dt, tab)
  tab.py = tab.py + 150 * dt
  tab.hitbox_py = tab.py
end

function checar_colisao (x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function love.load()
  qtd_missil = 5
  gamestate = "menu"
  love.window.setTitle("Trinvaders")
  shoot_enemy = love.audio.newSource("shoot.wav", "static")
  shoot_ship = love.audio.newSource("blip.wav", "static")
  invaderkilled = love.audio.newSource("invaderkilled.wav", "static")
  explosion = love.audio.newSource("explosion.wav", "static")
  shoot_enemy:setVolume(0.5)
  shoot_ship:setVolume(0.5)
  love.graphics.setFont(love.graphics.newFont("8-BIT WONDER.ttf", 20))
  
  tempo_missil = math.random(0.5,2)
  player_x = 375
  player_y = 525
  inimigo_x = {}
  inimigo_y = {}
  misseis = {}
  misseis_inimigos = {}
  inimigos = {}
  qtd_inimigos = 15
  player = player(player_x, player_y, 25, 25)
  k = 1
  j = 1
  base_hits_x = {}
  life_bar_width = 100
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
    inimigos[i] = inimigo((j*100), 100*k, 25+(j*100), 100*k, 12.5+(j*100), (100*k)+25, 300*math.random(3, 6), i)
    j = j+1
  end
end
    
function love.keypressed(key)
  if gamestate == "playing" then
    player.keypressed(key)
  elseif gamestate == "menu" then
    if key == 'return' then
      gamestate = "playing"
    end
  else
    if key == 'return' then
      love.event.quit()
    end
  end
end

function love.update(dt)
  if gamestate == "playing" then
    
    current_time = love.timer.getTime()
    player.update(dt)
    tempo_missil = tempo_missil - dt
    if tempo_missil < 0 then
      x = math.random(1, #inimigos)
      inimigos[x].missil_ini(x)
    end
    for n, inimigo in ipairs(inimigos) do
      if inimigos[n].state == 1 then
       inimigos[n].update(inimigos[n], dt, n)
      else
        if current_time > inimigos[n].wait_until then
          inimigos[n].state = 1
        end
      end
      inimigos[n].collisao(n)
    end
    for i, missil in ipairs(misseis) do
      missil_move(dt, missil)
      if missil.py < 0 then
        qtd_missil = qtd_missil + 1
        table.remove(misseis, i)
      end
    end
    for i, missil in ipairs(misseis_inimigos) do
      missil_inimigo_move(dt, missil)
      if missil.py > 575 then
        table.remove(misseis_inimigos, i)
        table.insert(base_hits_x, missil.px)
        explosion:play()
        life_bar_width = life_bar_width - 10
      end
    end
    for i, missil_ini in ipairs(misseis_inimigos) do
      for k, missil in ipairs(misseis) do
        if checar_colisao(missil.hitbox_px, missil.hitbox_py, missil.width, missil.height, missil_ini.hitbox_px, missil_ini.hitbox_py, missil_ini.width, missil_ini.height) then
          qtd_missil = qtd_missil + 1
          table.remove(misseis_inimigos, i)
          table.remove(misseis, k)
          invaderkilled:play()
        end
      end
    end
    if life_bar_width == 0 or qtd_inimigos == 0 then
      gamestate = "gameover"
    end
    
  end
end

function love.draw()
  if gamestate == "playing" then
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("LIFE", 690, 45)
    love.graphics.print(life_bar_width, 690, 65)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", 0, 575, 800, 25)
    love.graphics.rectangle("fill", 690, 10, life_bar_width, 25)
    player.draw()
    for n, inimigo in ipairs(inimigos) do
      inimigos[n].draw()
    end
    for i, missil in ipairs(misseis) do
      love.graphics.setColor(1, 1, 0)
      love.graphics.circle("fill", missil.px, missil.py, 5)
    end
    for i, missil in ipairs(misseis_inimigos) do
      love.graphics.setColor(1, 0, 0)
      love.graphics.circle("fill", missil.px, missil.py, 5)
    end
    for i, base_hit_x in ipairs(base_hits_x) do
      love.graphics.setColor(0, 0, 0)
      love.graphics.circle("fill", base_hit_x, 575, 10)
    end
    
  elseif gamestate == "menu" then
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("PRESS ENTER", 180, 200, 0, 2, 2)
    love.graphics.print("TO BEGIN GAME", 150, 300, 0, 2, 2)
    
  else
    
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.print("LIFE", 690, 45)
    love.graphics.print(life_bar_width, 690, 65)
    love.graphics.setColor(0, 0.3, 0)
    love.graphics.rectangle("fill", 0, 575, 800, 25)
    love.graphics.rectangle("fill", 690, 10, life_bar_width, 25)
    
    for i, base_hit_x in ipairs(base_hits_x) do
      love.graphics.setColor(0, 0, 0)
      love.graphics.circle("fill", base_hit_x, 575, 10)
    end
    
    if life_bar_width == 0 then
      love.graphics.setColor(1, 1, 1)
      love.graphics.print("GAME OVER", 210, 200, 0, 2, 2)
      love.graphics.print("PRESS ENTER TO", 130, 300, 0, 2, 2)
      love.graphics.print("QUIT GAME", 230, 400, 0, 2, 2)
    else
      love.graphics.setColor(1, 1, 1)
      love.graphics.print("YOU WON", 250, 200, 0, 2, 2)
      love.graphics.print("PRESS ENTER TO", 150, 300, 0, 2, 2)
      love.graphics.print("QUIT GAME", 230, 400, 0, 2, 2)
    end
    
  end
end
