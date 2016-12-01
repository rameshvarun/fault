Block = class('Block', Entity)

function Block:initialize(center, angle, size, velocity, color)
    Entity.initialize(self, 'obstacle', -1, center)
    self.angle = angle
    self.size = size
    self.velocity = velocity
    self.color = color
    self.collision_shape = collision.newPolygonShape(-size.x/2, -size.y/2,
      -size.x/2, size.y/2, size.x/2, size.y/2, size.x/2, -size.y/2)
end

function Block:draw()
  self.color:use()
  love.graphics.push()
  love.graphics.translate(self.pos:unpack())
  love.graphics.rotate(self.angle)
  love.graphics.rectangle('fill', -self.size.x/2, -self.size.y/2, self.size:unpack())
  love.graphics.pop()
end

function Block:update(dt)
  self.pos = self.pos + self.velocity*dt
  self.collision_shape:moveTo(self.pos:unpack())
  self.collision_shape:setRotation(self.angle)
end

function Block:collidesWith(player_shape)
  return self.collision_shape:collidesWith(player_shape)
end
