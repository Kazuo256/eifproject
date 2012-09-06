
local object  = require "lux.object"
local array   = require "lux.table"

local layer   = require "iso.layer"

module "iso" do

  space = object:new {}

  space.__init = {
    layers = array:new {}
  }

  function space:add_layer (new_layer)
    self.layers:insert(new_layer)
  end

end

