function wait (sec, blip)
  blip.state = 0 --inativo
  blip.wait_until = current_time + sec
  coroutine.yield()
end

function newblip (sec)
  local x, y = 0, 0 
  local state = 1 -- 1 para ativo, 0 para inativo
  return {
    update = coroutine.wrap(function (self)
      while true do
        local width, height = love.graphics.getDimensions( )
        x = x+sec
        if x > width then
          -- volta para a esquerda da janela
          x = 0
        end
        wait(sec/100,self)
      end
    end),
    affected = function (pos)
      if pos>x and pos<x+10 then
      -- "pegou" o blip
        return true
      else
        return false
      end
    end,
    draw = function ()
      love.graphics.rectangle("line", x, y, 10, 10)
    end,
    is_active = function ()
      if state == 1 then
        return true
      else
        return false
      end
    wait_until = 0
  }
end

function newplayer ()
  local x, y = 0, 200
  local width, height = love.graphics.getDimensions( )
  return {
  try = function ()
    return x
  end,
  update = function (dt)
    x = x + 0.5
    if x > width then
      x = 0
    end
  end,
  draw = function ()
    love.graphics.rectangle("line", x, y, 30, 10)
  end
  }
end

function love.keypressed(key)
  if key == 'a' then
    pos = player.try()
    for i in ipairs(listabls) do
      local hit = listabls[i].affected(pos)
      if hit then
        table.remove(listabls, i) -- esse blip "morre" 
        return -- assumo que apenas um blip morre
      end
    end
  end
end

function love.load()
  player =  newplayer()
  listabls = {}
  for i = 1, 5 do
    listabls[i] = newblip(math.random(1,10))
  end
end

function love.draw()
  player.draw()
  for i = 1,#listabls do
    listabls[i].draw()
  end
end

function love.update(dt)
  current_time = love.timer.getTime()
  player.update(dt)
  for i = 1,#listabls do
    if listabls[i].state == 1 then
      listabls[i].update(listabls[i])
    else
      if current_time > listabls[i].wait_until then
        listabls[i].state = 1
      end
    end
  end
end
  
