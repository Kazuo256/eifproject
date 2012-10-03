
local object = require "lux.object"

module "iso" do

  plane = object.new {
    iso_tform = nil,  -- used to trace pixel to point
    vec_base = nil,   -- used to trace point to texel
  }

  function plane:normal ()
    return self.vec_base[3]:clone()
  end

  function plane:to_global_coord (x, y)
    return x*self.vec_base[1] + y*self.vec_base[2]
  end

  function plane:adjust_normal_offset (x, y, z)
    return 32*vec:new{z,z,z} - 32*x*self.vec_base[1] - 32*y*self.vec_base[2]
  end

end
