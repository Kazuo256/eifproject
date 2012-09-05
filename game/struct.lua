
local love    = love
local unpack  = unpack
local print   = print
local gsub    = string.gsub

module "struct" do
  
  tform = {
    { 0.25,  -0.25,   0.0, 0.0},
    { 0.5,    0.5,    0.0, 0.0},
    { 0.0,    0.0,    0.5, 0.0},
    {-250.0, -50.0,   0.0, 1.0}
  }
  
  left_tform = {
    { 0.5,    0.0, -0.25,   0.0},
    { 0.0,    0.0,  0.5,    0.0},
    { 0.0,    1.0,  0.0,    0.0},
    {-200.0,  0.0, -50.0,   1.0}
  }
  
  right_tform = {
    { 0.0, -0.5,    0.25,   0.0},
    { 0.0,  0.0,    0.5,    0.0},
    { 1.0,  0.0,    0.0,    0.0},
    { 0.0,  200.0, -250.0,  1.0}
  }
  
  local function mul3 (mat, vec)
    return {
      mat[1][1]*vec[1] + mat[2][1]*vec[2] + mat[3][1]*vec[3],
      mat[1][2]*vec[1] + mat[2][2]*vec[2] + mat[3][2]*vec[3],
      mat[1][3]*vec[1] + mat[2][3]*vec[2] + mat[3][3]*vec[3],
    }
  end
  
  function mul4 (mat, vec)
    return {
      mat[1][1]*vec[1] + mat[2][1]*vec[2] + mat[3][1]*vec[3] + mat[4][1]*vec[4],
      mat[1][2]*vec[1] + mat[2][2]*vec[2] + mat[3][2]*vec[3] + mat[4][2]*vec[4],
      mat[1][3]*vec[1] + mat[2][3]*vec[2] + mat[3][3]*vec[3] + mat[4][3]*vec[4],
      mat[1][4]*vec[1] + mat[2][4]*vec[2] + mat[3][3]*vec[3] + mat[4][4]*vec[4]
    }
  end
  
  local color_shader = [[
    // Light info
    extern vec4   light_pos;
    extern number a;
    extern number b;
    // General transformation
    extern mat4   isomatrix;
    // World settings
    extern vec4   offset;
    vec4 effect (vec4 color, Image texture, vec2 tex_coords, vec2 pix_coords) {
      vec4 pix = vec4(pix_coords.x, pix_coords.y, 0, 1);
      vec4 iso_pos = offset+isomatrix*pix;
      number d = distance(light_pos, iso_pos);
      number decay = clamp(exp(-a*(d-b)), 0, 1);
      return vec4(
        color.r*decay,
        color.g*decay,
        color.b*decay,
        color.a
      );
    }
  ]]
  local texture_shader = [[
    // Light info
    extern vec4   light_pos;
    extern number a;
    extern number b;
    // General transformation
    extern mat4   isomatrix;
    extern mat4   dirmatrix;
    // World settings
    extern vec4   offset;
    extern Image  img%n;
    vec4 effect (vec4 color, Image texture, vec2 tex_coords, vec2 pix_coords) {
      vec4 pix = vec4(pix_coords.x, pix_coords.y, 0, 1);
      vec4 iso_pos = offset+isomatrix*pix;
      vec4 tex = Texel(img%n, vec2(mod(dirmatrix*iso_pos,32.0))/32.0);
      number d = distance(light_pos, iso_pos);
      number decay = clamp(exp(-a*(d-b)), 0, 1);
      return vec4(
        color.r*tex.r*decay,
        color.g*tex.g*decay,
        color.b*tex.b*decay,
        color.a*tex.a
      );
    }
  ]]
  
  --local effect1, effect2
  
  --local floor

  local id = 0
  local function new_struct (transform, img, dir)
    local struct_effect = img
      and love.graphics.newPixelEffect(gsub(texture_shader,"%%n",id))
      or  love.graphics.newPixelEffect(color_shader)
    struct_effect:send("a", 0.05)
    struct_effect:send("b", 50)
    struct_effect:send("isomatrix", transform)
    if img then
      struct_effect:send("dirmatrix", dir)
      struct_effect:send("img"..id, img)
      id = id + 1
    end
    struct_effect:send("light_pos", {0,0,10,1})
    struct_effect:send("offset", {0,0,0,0})
    return struct_effect
  end

  function new_floor (img)
    return new_struct(
      tform,
      img,
      {{1,0,0,0},
       {0,1,0,0},
       {0,0,1,0},
       {0,0,0,1}}
    )
  end

  function new_leftwall (img)
    return new_struct(
      left_tform,
      img,
      {{1,0,0,0},
       {0,0,1,0},
       {0,1,0,0},
       {0,0,0,1}} 
    )
  end

  function new_rightwall (img)
    return new_struct(
      right_tform,
      img,
      {{0,0,1,0},
       {1,0,0,0},
       {0,1,0,0},
       {0,0,0,1}} 
    )
  end

  local function to_screen(x,y,z)
    return 400+64*x-64*y, 300-32*x-32*y-64*z
  end
  
  function draw_floor (effect, pos, size)
    local args = {}
    args[1], args[2] = to_screen(pos[1],          pos[2],         pos[3])
    args[3], args[4] = to_screen(pos[1],          pos[2]+size[2], pos[3])
    args[5], args[6] = to_screen(pos[1]+size[1],  pos[2]+size[2], pos[3])
    args[7], args[8] = to_screen(pos[1]+size[1],  pos[2],         pos[3])
    love.graphics.setPixelEffect(effect)
    love.graphics.quad("fill",unpack(args))
  end
  
  function draw_leftwall (effect, pos, size)
    local args = {}
    args[1], args[2] = to_screen(pos[1],          pos[2], pos[3]+size[2])
    args[3], args[4] = to_screen(pos[1]+size[1],  pos[2], pos[3]+size[2])
    args[5], args[6] = to_screen(pos[1]+size[1],  pos[2], pos[3])
    args[7], args[8] = to_screen(pos[1],          pos[2], pos[3])
    love.graphics.setPixelEffect(effect)
    love.graphics.quad("fill",unpack(args))
  end
  
  function draw_rightwall (effect, pos, size)
    local args = {}
    args[1], args[2] = to_screen(pos[1],  pos[2]+size[1], pos[3]+size[2])
    args[3], args[4] = to_screen(pos[1],  pos[2],         pos[3]+size[2])
    args[5], args[6] = to_screen(pos[1],  pos[2],         pos[3])
    args[7], args[8] = to_screen(pos[1],  pos[2]+size[1], pos[3])
    love.graphics.setPixelEffect(effect)
    love.graphics.quad("fill",unpack(args))
  end

end

