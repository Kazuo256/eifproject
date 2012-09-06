
local unpack  = unpack
local pairs   = pairs
local object  = require "lux.object"
local array   = require "lux.table"

require "struct"

local struct = struct

module "iso"

layer = object.new {

}

layer.__init = {
  floors = array:new{},
  lwalls = array:new{},
  rwalls = array:new{},
  light_pos = {0,0,0}
}

local offsets = {}

local typenames = {
  floor = "floors",
  leftwall = "lwalls",
  rightwall = "rwalls"
}

function offsets.floor (x,y,z)
  return -32*x+32*z, -32*y+32*z, 32*z, 0
end

function offsets.leftwall (x,y,z)
  return -32*x+32*y, 32*y, -32*z+32*y, 0
end

function offsets.rightwall (x,y,z)
  return 32*x, -32*y+32*x, -32*z+32*x, 0
end

function layer:add_struct (struct_type, origin, pos, size, img)
  local struct = {
    effect = struct["new_"..struct_type](img),
    pos = {origin[1]+pos[1], origin[2]+pos[2], origin[3]+pos[3]},
    size = object.clone(size)
  }
  struct.effect:send("offset", {offsets[struct_type](unpack(origin))})
  self[typenames[struct_type]]:insert(struct)
end

function layer:add_floor (origin, pos, size, img)
  self:add_struct("floor", {0,0,origin}, pos, size, img)
end

function layer:add_leftwall (origin, pos, size, img)
  self:add_struct("leftwall", {0,origin,0}, pos, size, img)
end

function layer:add_rightwall (origin, pos, size, img)
  self:add_struct("rightwall", {origin,0,0}, pos, size, img)
end

function layer:set_light_pos(pos)
  for _,name in pairs (typenames) do
    for _,obj in pairs (self[name]) do
      obj.effect:send("light_pos", pos)
    end
  end
end

function layer:draw (graphics)
  for struct_type,name in pairs (typenames) do
    for _,obj in pairs (self[name]) do
      struct["draw_"..struct_type](obj.effect, obj.pos, obj.size)
    end
  end
end

