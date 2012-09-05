
require "lux.object"
require "lux.table"

require "struct"

room = lux.object.new {

}

room.__init = {
  floors = lux.table:new{},
  lwalls = lux.table:new{},
  rwalls = lux.table:new{},
  light_pos = {0,0,0}
}

local offsets = {}

local typenames = {
  floor = "floors",
  leftwall = "lwalls",
  rightwall = "rwalls"
}

function offsets.floor (x,y,z)
  return -32*x-32*z, -32*y-32*z, 32*z, 0
end

function offsets.leftwall (x,y,z)
  return -32*x+32*y, 32*y, -32*z-32*y, 0
end

function offsets.rightwall (x,y,z)
  return 32*x, -32*y+32*x, -32*z-32*x, 0
end

function room:add_struct (struct_type, origin, pos, size, img)
  local struct = {
    effect = struct["new_"..struct_type](img),
    pos = lux.object.clone(pos),
    size = lux.object.clone(size)
  }
  struct.effect:send("offset", {offsets[struct_type](unpack(origin))})
  self[typenames[struct_type]]:insert(struct)
end

function room:add_floor (pos, origin, size, img)
  self:add_struct("floor", pos, origin, size, img)
end

function room:add_leftwall (pos, origin, size, img)
  self:add_struct("leftwall", pos, origin, size, img)
end

function room:add_rightwall (pos, origin, size, img)
  self:add_struct("rightwall", pos, origin, size, img)
end

function room:set_light_pos(pos)
  for _,name in pairs (typenames) do
    for _,obj in pairs (self[name]) do
      obj.effect:send("light_pos", pos)
    end
  end
end

function room:draw (graphics)
  for struct_type,name in pairs (typenames) do
    for _,obj in pairs (self[name]) do
      struct["draw_"..struct_type](obj.effect, obj.pos, obj.size)
    end
  end
end

