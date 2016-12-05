TunnelEntity = class('TunnelEntity', Entity)

local function widthsharpness(t)
  if t < 0.5 then return 0.3, 0.15 end
  return 0.15, 0.10
end

local NUM_SEGMENTS = 40
local SEGMENT_SPACING = 40
local TUNNEL_SPEED = 150

local center = {0.5}
local width = {1, 0.8, 0.5}

local function det(x1,y1, x2,y2)
	return x1*y2 - y1*x2
end

-- returns true if three vertices lie on a line
local function areCollinear(px, py, qx, qy, rx, ry, eps)
	return math.abs(det(qx-px, qy-py,  rx-px,ry-py)) <= (eps or 1e-32)
end

function TunnelEntity:initialize()
    Entity.initialize(self, 'obstacle', -1, vector(0, -PlayArea.SIZE/2))

    for i=1, NUM_SEGMENTS do
      local t = i / NUM_SEGMENTS
      local last_center = center[#center]
      local last_width = width[#width]

      new_width, sharpness = widthsharpness(t)
      new_center = last_center + lume.randomchoice({-sharpness, sharpness})
      new_center = lume.clamp(new_center, new_width / 2 + 0.1, 0.9 - new_width / 2)

      if new_center == last_center then
        if new_center < 0.5 then new_center = new_center + sharpness else
        new_center = new_center - sharpness end
      end

      table.insert(center, new_center)
      table.insert(width, new_width)
    end

    local left_edge, right_edge = {}, {}
    for i=1, #center do
      table.insert(left_edge, center[i] - width[i] / 2)
      table.insert(right_edge, center[i] + width[i] / 2)
    end

    local ypos = 0

    local left_shape, right_shape = {}, {}
    for i=1, NUM_SEGMENTS do
      table.insert(left_shape, (left_edge[i] - 0.5)*PlayArea.SIZE)
      table.insert(left_shape, ypos)

      table.insert(right_shape, (right_edge[i] - 0.5)*PlayArea.SIZE)
      table.insert(right_shape, ypos)

      ypos = ypos - SEGMENT_SPACING
    end

    table.insert(left_shape, -500 - PlayArea.SIZE/2)
    table.insert(left_shape, ypos)

    table.insert(left_shape, -500 - PlayArea.SIZE/2)
    table.insert(left_shape, 0)

    table.insert(right_shape, 500 + PlayArea.SIZE/2)
    table.insert(right_shape, ypos)

    table.insert(right_shape, 500 + PlayArea.SIZE/2)
    table.insert(right_shape, 0)

    self.left_triangles = love.math.triangulate(left_shape)
    self.right_triangles = love.math.triangulate(right_shape)

    self.collision_shapes = {}
    for _, triangle in ipairs(self.left_triangles) do
      if not areCollinear(unpack(triangle)) then
        table.insert(self.collision_shapes,
          collision.newPolygonShape(unpack(triangle)))
      end
    end
    for _, triangle in ipairs(self.right_triangles) do
      if not areCollinear(unpack(triangle)) then
        table.insert(self.collision_shapes,
          collision.newPolygonShape(unpack(triangle)))
      end
    end

    for _, shape in ipairs(self.collision_shapes) do
      shape:move(self.pos:unpack())
    end
end

function TunnelEntity:updateCollisionShape()
  self.left_collision_shape:moveTo((self.pos + self.left_collision_offset):unpack())
  self.right_collision_shape:moveTo((self.pos + self.right_collision_offset):unpack())
end

function TunnelEntity:draw()
  love.graphics.push()
  love.graphics.setColor(255, 0, 0, 0.8*255)
  love.graphics.translate(self.pos:unpack())
  for _, triangle in ipairs(self.left_triangles) do
    love.graphics.polygon('fill', triangle)
  end
  for _, triangle in ipairs(self.right_triangles) do
    love.graphics.polygon('fill', triangle)
  end
  love.graphics.pop()
end

function TunnelEntity:update(dt)
  self.pos.y = self.pos.y + TUNNEL_SPEED*dt

  for _, shape in ipairs(self.collision_shapes) do
    shape:move(0, TUNNEL_SPEED*dt)
  end
end


function TunnelEntity:collidesWith(player_shape)
  for _, shape in ipairs(self.collision_shapes) do
    local collision, dx, dy = shape:collidesWith(player_shape)
    if collision then return collision, dx, dy end
  end
  return false
end
