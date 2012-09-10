
local unpack  = unpack
local pairs   = pairs
local object  = require "lux.object"
local array   = require "lux.table"

require "iso.struct"

module "iso"

layer = object.new {

}

layer.__init = {
  floors = array:new{},
  lwalls = array:new{},
  rwalls = array:new{},
  light_pos = {0,0,0}
}

local typenames = {
  floor = "floors",
  leftwall = "lwalls",
  rightwall = "rwalls"
}

local change = {
  floor = "bottom",
  leftwall = "left",
  rightwall = "right"
}

function layer:add_struct (struct_type, origin, pos, size, img)
  self[typenames[struct_type]]:insert(
    struct:new {
      type = change[struct_type],
      pos = { pos[1], pos[2], origin },
      size = size,
      texture = img
    }
  )
end

function layer:add_floor (origin, pos, size, img)
  self:add_struct("floor", origin, pos, size, img)
end

function layer:add_leftwall (origin, pos, size, img)
  self:add_struct("leftwall", origin, pos, size, img)
end

function layer:add_rightwall (origin, pos, size, img)
  self:add_struct("rightwall", origin, pos, size, img)
end

function layer:set_light_pos(pos)
  for _,name in pairs (typenames) do
    for _,obj in pairs (self[name]) do
      obj.shader:send("light_pos", pos)
    end
  end
end

function layer:draw (graphics)
  for struct_type,name in pairs (typenames) do
    for _,obj in pairs (self[name]) do
      obj:draw()
    end
  end
end

