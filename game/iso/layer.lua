
local unpack  = unpack
local pairs   = pairs
local object  = require "lux.object"
local array   = require "lux.table"

require "iso.struct"

module "iso" do

  layer = object.new {
    bound = nil
  }
  
  layer.__init = {
    structs = array:new {},
    bound = {
      left    = -128,
      right   =  128,
      bottom  = -128,
      top     =  128
    },
  }
  
  function layer:add_struct (struct_type, origin, pos, size, img)
    self.structs:insert(
      struct:new {
        type = struct_type,
        pos = { pos[1], pos[2], origin },
        size = size,
        texture = img
      }
    )
  end
  
  function layer:add_floor (origin, pos, size, img)
    self:add_struct("bottom", origin, pos, size, img)
  end
  
  function layer:add_leftwall (origin, pos, size, img)
    self:add_struct("left", origin, pos, size, img)
  end
  
  function layer:add_rightwall (origin, pos, size, img)
    self:add_struct("right", origin, pos, size, img)
  end
  
  function layer:set_light_pos(pos)
    for _,obj in pairs (self.structs) do
      obj.shader:send("light_pos", pos)
    end
  end
  
  local function inside (pos, bound)
    return  pos[1] >= bound.left and
            pos[1] <= bound.right and
            pos[2] >= bound.bottom and
            pos[2] <= bound.top
  end
  
  function layer:visible_at (pos)
    return inside(pos, self.bound)
  end
  
  function layer:draw (graphics)
    for _,obj in pairs (self.structs) do
      obj:draw()
    end
  end

end

