
function wait (sec, inimigo)
  inimigo.state = 0
  inimigo.wait_until = current_time+sec
  coroutine.yield()
end

function retangulo (x,y,w,h)
  local originalx, originaly, rx, ry, rw, rh = x, y, x, y, w, h
  local missil_existe = 0
  return {
    draw =
      function ()
        love.graphics.setColor (0,0,255)
        love.graphics.rectangle("fill", rx, ry, rw, rh)
        if missil_existe then
          missil.draw(rx, ry)
        end
      end,
    update =
      function (dt)
        local mx, my = love.mouse.getPosition()
        if love.keyboard.isDown("right") then
          rx = rx + 100*dt
        elseif love.keyboard.isDown("left") then
          rx = rx - 100*dt
        end
      end,
    keypressed = 
      function(key)
        if key == ' ' then
          missil_existe = 1
          missil = missil (rx, ry, 5, 10)
        end
      end
  }
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
  return {
    draw =
      function (retx, rety)
        love.graphics.setColor (255,255,0)
        love.graphics.circle("fill", retx, rety, rr)
      end,
    keypressed = 
      function(key)
        if key == ' ' then 
          ry = ry + vel
        end
      end
  }
end




function love.load()
  ret1 = retangulo(375, 525, 25, 25)
  inimigo1 = inimigo(100, 100, 125, 100, 112.5, 125, 5)
end

function love.keypressed(key)
  ret1.keypressed(key)
end
    
function love.update(dt)
  current_time = love.timer.getTime()
  ret1.update(dt)
  inimigo1.update(inimigo1)
end

function love.draw()
  love.graphics.setColor (0,255,0)
  love.graphics.rectangle("fill", 0, 575, 800, 25)
  ret1.draw()
  inimigo1.draw()


end