
local ipairs  = ipairs
local object  = require "lux.object"
local array   = require "lux.table"

module "iso" do

  space = object.new {}

  space.__init = {
    layers = array:new {}
  }

  function space:add_layer (new_layer)
    self.layers:insert(new_layer)
  end

  function space:set_light_pos (pos)
    for _,layer in ipairs(self.layers) do
      layer:set_light_pos(pos)
    end
  end

  function space:draw ()
    for _,layer in ipairs(self.layers) do
      layer:draw()
    end
  end

end

