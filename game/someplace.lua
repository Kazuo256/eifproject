
local array = require "lux.table"
require "iso.layer"
require "iso.space"
require "iso.struct"
local space = iso.space
local layer = iso.layer
local struct = iso.struct

local floor = love.graphics.newImage "tiles_plain_3.png"
local door = {
  love.graphics.newImage "door_0124_bottom.png",
  love.graphics.newImage "door_0124_top.png"
}

return space:new {
  layers = array:new {
    -- background layer
    layer:new {
      structs = {
        struct:new {
          type = "bottom",
          pos = {-3,0,0},
          size = {6,1},
          texture = floor
        },
        struct:new {
          type = "bottom",
          pos = {-3,-3,1},
          size = {6,3},
          texture = floor
        },
        struct:new {
          type = "left",
          pos = {-3,0,0},
          size = {6,1},
        },
        struct:new {
          type = "left",
          pos = {-3,-2,1},
          size = {6,2}
        }
      }
    },
    -- door layer
    layer:new {
      bound = {left=0,right=128,bottom=-128,top=128},
      structs = {
        struct:new {
          type = "right",
          pos = {0,0,0},
          size = {1,1},
          texture = door[1]
        },
        struct:new {
          type = "right",
          pos = {0,1,0},
          size = {1,1},
          texture = door[2]
        }
      }
    }
  }
}

