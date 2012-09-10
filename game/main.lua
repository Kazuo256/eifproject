
local struct  = require "struct"

local function dofile (path)
  return love.filesystem.load(path) ()
end

local someplace

function love.load ()
  someplace = dofile "someplace.lua"
end

local t = 0
function love.update (dt)
  local x,y = love.mouse.getPosition()
  y = love.graphics.getHeight()-y
  local pos = struct.mul4(struct.tform, {x,y,0,1})
  pos[3] = 32
  someplace:set_light_pos(pos)
  t = t+dt
end

function love.draw ()
  love.graphics.setColor(150, 150, 150, 255)
  --love.graphics.setPixelEffect(someplace.floors[1].effect)
  --love.graphics.setPixelEffect(someplace.lwalls[1].effect)
  --love.graphics.setPixelEffect(someplace.rwalls[1].effect)
  --love.graphics.rectangle("fill", 0, 0, 800, 600)
  someplace:draw(love.graphics)
  love.graphics.setPixelEffect()
  love.graphics.setColor(50,  50,  200, 255)
  love.graphics.line(400,0,400,600)
  love.graphics.line(0,300,800,300)
end

