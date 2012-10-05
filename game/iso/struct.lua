
local object    = require "lux.object"
local rawstruct = require "struct"
require "geom.vec"
require "iso.plane"

local error     = error
local print     = print
local unpack    = unpack
local vec       = geom.vec
local plane     = iso.plane

module "iso" do

  struct = object.new {
    type = "bottom",
    plane = nil,
    pos = {0,0,0},
    size = {1,1},
    texture = nil
  }

  function struct:__init ()
    self.plane = plane[self.type]()
    local offset = self.pos[3]*self.plane:normal()
    local pos = self.plane:to_global_coord(self.pos[1], self.pos[2])
    self.shader = rawstruct["new_"..self.type](self.texture)
    self.pos = {
      offset[1] + pos[1],
      offset[2] + pos[2],
      offset[3] + pos[3]
    }
    self.size = object.clone(self.size)
    self.shader:send(
      "offset",
      { unpack(self.plane:adjust_normal_offset(offset)) }
    )
  end

  function struct:draw ()
    rawstruct["draw_"..self.type](self.shader, self.pos, self.size)
  end

end


