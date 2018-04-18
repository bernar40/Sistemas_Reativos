missil_state = 0

function wait (sec, objeto)
  objeto.state = 0
  objeto.wait_until = current_time+sec
  coroutine.yield()
end



function inimigo (x1,y1,x2,y2,x3,y3, vel)
  local rx1, ry1, rx2, ry2, rx3, ry3 = x1,y1,x2,y2,x3,y3
  local state = 1
  return {
    update = coroutine.wrap (function (self)
      while true do
        local width, height =                         love.graphics.getDimensions()
        rx1 = rx1 + vel
        rx2 = rx2 + vel
        rx3 = rx3 + vel
        if rx1 > width then 
          rx1 = x1
          rx2 = x2
          rx3 = x3
        end
        wait(vel/100, self)
      end
    end),
    draw =
      function ()
        love.graphics.setColor (255,0,0)
        love.graphics.polygon("fill", rx1, ry1, rx2, ry2, rx3, ry3)
      end
  }
end
function missil (x, y, r, vel)
  local rx, ry, rr = x, y, r
  local width, height = love.graphics.getDimensions()
  return {
    draw =
      function (retx, rety)
        love.graphics.setColor (255,255,0)
        love.graphics.circle("fill", rx, ry, rr)
      end,
    update = 
      function(dt)
        while ry > 0 do
          ry = ry - vel
        end
      end
  }
end

function player (x,y,w,h)
  local originalx, originaly, rx, ry, rw, rh = x, y, x, y, w, h
  missil = missil(rx, ry+10, 5, 10)
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
          rx = rx + 100*dt
          playerx = rx
        elseif love.keyboard.isDown("left") then
          rx = rx - 100*dt
        end
      end,
    keypressed = 
      function(key)
        if key == "up" then
          missil_state = 1
        end
      end
  }
end


function love.load()
  player = player(375, 525, 25, 25)
  inimigo= inimigo(100, 100, 125, 100, 112.5, 125, 5)
end

    
function love.keypressed(key)
  player.keypressed(key)
end

function love.update(dt)
  current_time = love.timer.getTime()
  player.update(dt)
  inimigo.update(inimigo)
  if missil_state then
    io.write(missil_state)
    missil.update(dt)
  end
end

function love.draw()
  love.graphics.setColor (0,255,0)
  love.graphics.rectangle("fill", 0, 575, 800, 25)
  player.draw()
  inimigo.draw()
  if missil_state then
    missil.draw()
  end


end