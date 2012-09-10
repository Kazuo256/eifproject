
require "iso.layer"
require "iso.space"
local struct  = require "struct"
local space = iso.space
local layer = iso.layer

local floor, door
local someplace = space:new { num_layers = 2 }

function love.load ()
  floor = love.graphics.newImage "tiles_plain_3.png"
  door = {
    love.graphics.newImage "door_0124_bottom.png",
    love.graphics.newImage "door_0124_top.png"
  }
  someplace:set_bound(2, {left=0,right=128,bottom=-128,top=128})
  someplace:add_floor(1, 0, {-3,0}, {6,1}, floor)
  someplace:add_leftwall(1, 0, {-3,0}, {6,1})
  someplace:add_floor(1, 1, {-3,-3}, {6,3}, floor)
  someplace:add_leftwall(1, 1, {-3,-2}, {6,2})
  someplace:add_rightwall(2, 0, {0,0}, {1,1}, door[1])
  someplace:add_rightwall(2, 0, {0,1}, {1,1}, door[2])
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

