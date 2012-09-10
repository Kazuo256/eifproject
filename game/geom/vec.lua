
local rawset        = rawset
local rawget        = rawget
local getmetatable  = getmetatable
local type          = type
local object        = require "lux.object"

module "geom" do

  vec = object.new {
    -- Vector coordinates.
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0
  }

  point = vec:new {
    [4] = 1
  }
  
  function vec:__index (k)
    if k == "x" then return self[1] end
    if k == "y" then return self[2] end
    if k == "z" then return self[3] end
    if k == "w" then return self[4] end
    return getmetatable(self)[k]
  end

  point.__index = vec.__index
  
  function vec:__newindex (k, v)
    if k == "x" then rawset(self, 1, v)
    elseif k == "y" then rawset(self, 2, v)
    elseif k == "z" then rawset(self, 3, v)
    elseif k == "w" then rawset(self, 4, v)
    else rawset(self, k, v) end
  end

  point.__newindex = vec.__newindex
  
  function vec.__add (lhs, rhs)
    return vec:new {
      lhs[1] + rhs[1],
      lhs[2] + rhs[2],
      lhs[3] + rhs[3],
      lhs[4] + rhs[4]
    }
  end
  
  function vec.__sub (lhs, rhs)
    return vec:new {
      lhs[1] - rhs[1],
      lhs[2] - rhs[2],
      lhs[3] - rhs[3],
      lhs[4] - rhs[4]
    }
  end

  point.__sub = vec.__sub

  local function mul_scalar (a, v)
    return vec:new {
      a*v[1],
      a*v[2],
      a*v[3],
      a*v[4]
    }
  end
 
  function vec.__mul (lhs, rhs)
    if type(lhs) == "number" then
      return mul_scalar(lhs,rhs)
    elseif type(rhs) == "number" then
      return mul_scalar(rhs, lhs)
    else -- assume both are vec2
      return lhs[1]*rhs[1] + lhs[2]*rhs[2] + lhs[3]*rhs[3] + lhs[4]*rhs[4]
    end
  end
 
  function vec:set (x, y, z, w)
    self[1] = x or 0
    self[2] = y or 0
    self[3] = z or 0
    self[4] = w or 0
  end
 
  function vec:add (v)
    self[1] = self[1] + v[1]
    self[2] = self[2] + v[2]
    self[3] = self[3] + v[3]
    self[4] = self[4] + v[4]
  end

  function vec:sub (v)
    self[1] = self[1] - v[1]
    self[2] = self[2] - v[2]
    self[3] = self[3] - v[3]
    self[4] = self[4] - v[4]
  end
  
end

