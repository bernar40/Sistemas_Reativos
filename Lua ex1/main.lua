function naimagem (mx, my, x, y) 
  return (mx>x) and (mx<x+w) and (my>y) and (my<y+h)
end

function retangulo (x,y,w,h)
  local originalx, originaly, rx, ry, rw, rh = x, y, x, y, w, h
  
  return {
    draw =
      function ()
        love.graphics.rectangle("line", rx, ry, rw, rh)
      end,
    keypressed =
      function (key)
        local mx, my = love.mouse.getPosition()
        
        if key == 'b' and naimagem (mx,my, x, y) then
          ry = 200
        elseif key == "down" then
          ry = ry + 10
        elseif key == "right" then
          rx = rx + 10
        end
      end    
  }
end

function love.load()
  ret_array = {}
  for i=1,10,1 do
    ret_array[i] = retangulo(math.random(200), math.random(200), 10*i, 10*i)
  end
  ret1 = retangulo(50, 200, 200, 150)
  ret2 = retangulo(10, 10 ,80, 100)
end

function love.keypressed(key)
  ret1.keypressed(key)
  ret2.keypressed(key)
  for i=1,10,1 do
    ret_array[i].keypressed(key)
  end
end

function love.update (dt)
end

function love.draw ()
  ret1.draw()
  ret2.draw()
  for i=1,10,1 do
    ret_array[i].draw(key)
  end
end
