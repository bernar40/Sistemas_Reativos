function player (x,y,w,h)
  local originalx, originaly, rx, ry, rw, rh = x, y, x, y, w, h
  return {
    draw =
      function ()
        love.graphics.setColor(255, 0, 0)
        love.graphics.rectangle("fill", rx, ry, rw, rh)
      end,
    update =
      function (dt)
        
      end
  }
end

function love.load()
  gamestate = "menu"
  love.window.setTitle("NIAB")
  w = 600
  h = 600
  love.window.setMode(w, h)
  player = player(0, 0, 25, 25)
end

function love.update(dt)
  
end

function love.draw()
  if gamestate == "menu" then
    love.graphics.setColor(192, 210, 255)
    love.graphics.rectangle("fill", 0, 0, w, h)
    love.graphics.setColor(255, 0, 0)
    love.graphics.setFont(love.graphics.newFont("CookieMonster.ttf", 70))
    love.graphics.print("Bem vindo a", w/10, h/8)
    love.graphics.setFont(love.graphics.newFont("the dark.ttf", 70))
    love.graphics.print("NIAB", w - 160, h/8)
  end
end
