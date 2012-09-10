
local object    = require "lux.object"
local rawstruct = require "struct"

local error     = error
local print     = print
local unpack    = unpack

module "iso" do

  struct = object.new {
    type = "bottom",
    pos = {0,0,0},
    size = {1,1},
    texture = nil
  }

  local offset_dir = {
    bottom  = function (d) return {0,0,d} end,
    left    = function (d) return {0,d,0} end,
    right   = function (d) return {d,0,0} end
  }

  local pos_dir = {
    bottom  = function (x,y) return {x,y,0} end,
    left    = function (x,y) return {x,0,y} end,
    right   = function (x,y) return {0,x,y} end
  }

  local offset_adjust = {}

  function offset_adjust.bottom (x,y,z)
    return -32*x+32*z, -32*y+32*z, 32*z, 0
  end
  
  function offset_adjust.left (x,y,z)
    return -32*x+32*y, 32*y, -32*z+32*y, 0
  end
  
  function offset_adjust.right (x,y,z)
    return 32*x, -32*y+32*x, -32*z+32*x, 0
  end

  function struct:__init ()
    local offset = offset_dir[self.type] (self.pos[3])
    local pos = pos_dir[self.type] (self.pos[1], self.pos[2])
    self.shader = rawstruct["new_"..self.type](self.texture)
    self.pos = {
      offset[1] + pos[1],
      offset[2] + pos[2],
      offset[3] + pos[3]
    }
    self.size = object.clone(self.size)
    self.shader:send(
      "offset",
      { offset_adjust[self.type](unpack(offset)) }
    )
  end

  function struct:draw ()
    rawstruct["draw_"..self.type](self.shader, self.pos, self.size)
  end

end


