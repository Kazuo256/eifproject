
local object    = require "lux.object"
local rawstruct = require "struct"
require "geom.vec"

local error     = error
local print     = print
local unpack    = unpack
local vec       = geom.vec

module "iso" do

  struct = object.new {
    type = "bottom",
    pos = {0,0,0},
    size = {1,1},
    texture = nil
  }

  local offset_direction = {
    bottom  = function (d) return vec:new{0,0,d} end,
    left    = function (d) return vec:new{0,d,0} end,
    right   = function (d) return vec:new{d,0,0} end
  }

  local from_plane_coord = {
    bottom  = function (x,y) return vec:new{x,y,0} end,
    left    = function (x,y) return vec:new{x,0,y} end,
    right   = function (x,y) return vec:new{0,x,y} end
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
    local offset = offset_direction[self.type] (self.pos[3])
    local pos = from_plane_coord[self.type] (self.pos[1], self.pos[2])
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


