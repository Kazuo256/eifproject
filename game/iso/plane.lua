
local object = require "lux.object"
require "geom.matrix"

local matrix = geom.matrix

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

  function plane.bottom ()
    return plane:new {
      iso_tform = matrix:new {
        {-0.25,   0.25,   0.0, 0.0},
        {-0.5,   -0.5,    0.0, 0.0},
        { 0.0,    0.0,    1.0, 0.0},
        { 250.0,  50.0,   0.0, 1.0}
      },
      vec_base = matrix:new {
        {1,0,0,0},
        {0,1,0,0},
        {0,0,1,0},
        {0,0,0,1}
      }
    }
  end

  function plane.left ()
    return plane:new {
      iso_tform = matrix:new {
        {-0.5,    0.0, -0.25,   0.0},
        { 0.0,    0.0,  0.5,    0.0},
        { 0.0,    1.0,  0.0,    0.0},
        { 200.0,  0.0, -50.0,   1.0}
      },
      vec_base = matrix:new {
        {1,0,0,0},
        {0,0,1,0},
        {0,1,0,0},
        {0,0,0,1}
      }
    }
  end

  function plane.right ()
    return plane:new {
      iso_tform = matrix:new {
        { 0.0,  0.5,    0.25,   0.0},
        { 0.0,  0.0,    0.5,    0.0},
        { 1.0,  0.0,    0.0,    0.0},
        { 0.0, -200.0, -250.0,  1.0}
      },
      vec_base = matrix:new {
        {0,1,0,0},
        {0,0,1,0},
        {1,0,0,0},
        {0,0,0,1}
      }
    }
  end

end
