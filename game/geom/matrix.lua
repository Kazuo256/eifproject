
local rawset        = rawset
local rawget        = rawget
local getmetatable  = getmetatable
local type          = type
local object        = require "lux.object"

require "geom.vec"

module "geom" do

  matrix = object.new {
    __type = "matrix",
    -- Matrix columns.
    [1] = nil,
    [2] = nil,
    [3] = nil,
    [4] = nil
  }

  function matrix:__init ()
    for i = 1,4 do
      if self[i] then
        self[i] = vec:new(self[i])
      else
        self[i] = vec.axis(i)
      end
    end
  end

  local function mul_scalar (a, m)
    return matrix:new {
      a*m[1],
      a*m[2],
      a*m[3],
      a*m[4]
    }
  end
 
  function matrix.__mul (lhs, rhs)
    if type(lhs) == "number" then
      return mul_scalar(lhs,rhs)
    elseif type(rhs) == "number" then
      return mul_scalar(rhs, lhs)
    elseif rhs.__type == "vector" then
      return lhs[1]*rhs[1] + lhs[2]*rhs[2] + lhs[3]*rhs[3] + lhs[4]*rhs[4]
    else -- assume both are matrices
      return matrix:new {
        lhs*rhs[1],
        lhs*rhs[2],
        lhs*rhs[3],
        lhs*rhs[4]
      }
    end
  end
  
end

