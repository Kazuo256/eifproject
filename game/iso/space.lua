
local ipairs  = ipairs
local object  = require "lux.object"
local array   = require "lux.table"

module "iso" do

  space = object.new {}

  space.__init = {
    light_pos = {0,0,0},
    layers = array:new {}
  }

  function space:add_layer (new_layer)
    self.layers:insert(new_layer)
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

