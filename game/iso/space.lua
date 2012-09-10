
local ipairs  = ipairs
local object  = require "lux.object"
local array   = require "lux.table"

module "iso" do

  space = object.new {}

  space.__init = {
    light_pos = {0,0,0},
    layers = array:new {}
  }

  function space:add_layer (bound, new_layer)
    self.layers:insert {
      bound = object.clone(bound),
      layer = new_layer
    }
  end

  function space:set_light_pos (pos)
    self.light_pos = object.clone(pos)
    for _,layer in ipairs(self.layers) do
      layer.layer:set_light_pos(pos)
    end
  end

  local function inside (pos, bound)
    return  pos[1] >= bound.left and
            pos[1] <= bound.right and
            pos[2] >= bound.bottom and
            pos[2] <= bound.top
  end

  function space:draw ()
    for _,layer in ipairs(self.layers) do
      if inside(self.light_pos, layer.bound) then
        layer.layer:draw()
      end
    end
  end

end

