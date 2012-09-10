
local ipairs  = ipairs
local object  = require "lux.object"
local array   = require "lux.table"

require "iso.layer"

module "iso" do

  space = object.new {
    num_layers = 1
  }

  function space:__init ()
    self.light_pos = self.light_pos or {0,0,0}
    self.layers = array:new {}
    for i = 1, self.num_layers do
      self.layers:insert(layer:new {})
    end
  end

  function space:set_bound (layer_idx, bound)
    self.layers[layer_idx].bound = object.clone(bound)
  end

  function space:add_floor (layer_idx, origin, pos, size, img)
    self.layers[layer_idx]:add_floor(origin, pos, size, img)
  end

  function space:add_leftwall (layer_idx, origin, pos, size, img)
    self.layers[layer_idx]:add_leftwall(origin, pos, size, img)
  end

  function space:add_rightwall (layer_idx, origin, pos, size, img)
    self.layers[layer_idx]:add_rightwall(origin, pos, size, img)
  end

  function space:set_light_pos (pos)
    self.light_pos = object.clone(pos)
    for _,layer in ipairs(self.layers) do
      layer:set_light_pos(pos)
    end
  end

  function space:draw ()
    for _,layer in ipairs(self.layers) do
      if layer:visible_at(self.light_pos) then
        layer:draw()
      end
    end
  end

end

