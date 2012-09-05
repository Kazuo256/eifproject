
require "room"
local struct  = require "struct"

local floor, door
local effects = {}
local someplace = room:new{}

function love.load ()
  floor = love.graphics.newImage "tiles_plain_3.png"
  door = {
    love.graphics.newImage "door_0124_bottom.png",
    love.graphics.newImage "door_0124_top.png"
  }
  effects[1] = struct.new_floor(floor)
  --someplace:add_floor({0,0,0}, {-3,-1,0}, {6,1}, floor)
  effects[2] = struct.new_leftwall()
  effects[3] = struct.new_floor(floor)
  effects[4] = struct.new_leftwall()
  effects[3]:send("offset", {-32,-32, 32, 0})
  effects[4]:send("offset", {-32,-32, 32,  0})
  someplace:add_rightwall({0,0,0}, {0,-1,0}, {1,1}, door[1])
  someplace:add_rightwall({0,0,0}, {0,-1,1}, {1,1}, door[2])
  --effects[5] = struct.new_rightwall(door[1])
  --effects[6] = struct.new_rightwall(door[2])
end

local t = 0
function love.update (dt)
  local x,y = love.mouse.getPosition()
  y = love.graphics.getHeight()-y
  local pos = struct.mul4(struct.tform, {x,y,0,1})
  pos[3] = 32--+10*math.sin(5*t)
  for _,v in pairs(effects) do
    v:send("light_pos", pos)
  end
  someplace:set_light_pos(pos)
  t = t+dt
end

function love.draw ()
  love.graphics.setColor(150, 150, 150, 255)
  --love.graphics.setPixelEffect(effects[5])
  --love.graphics.rectangle("fill", 0, 0, 800, 600)
  struct.draw_floor(effects[1], {-3,-1,0}, {6,1})
  struct.draw_leftwall(effects[2], {-3,0,0}, {6,1})
  struct.draw_floor(effects[3], {-3,0,1}, {6,3})
  struct.draw_leftwall(effects[4], {-3,-1,-2}, {6,2})
  --struct.draw_rightwall(effects[5], {0,-1,0}, {1,1})
  --struct.draw_rightwall(effects[6], {0,-1,1}, {1,1})
  someplace:draw(love.graphics)
  love.graphics.setPixelEffect()
  love.graphics.setColor(50,  50,  200, 255)
  love.graphics.line(400,0,400,600)
  love.graphics.line(0,300,800,300)
end

