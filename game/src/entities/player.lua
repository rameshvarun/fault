Player = class('Player', Entity)

Player.static.WIDTH = 10;
Player.static.HEIGHT = 15
Player.static.DIP = 5
Player.static.NUM_TRAILS = 5

function Player:initialize()
  Entity.initialize(self, 'player', 0, vector(0, 0))
  self.angle = 0
  self.target_angle = 0
  self.last_pos = self.pos:clone()

  self.trail_positions = {}
  self.trail_angles = {}
  self.trail_timer = 0
end

function Player:update(dt)
  Player.draw(self, dt)

  self.xvel = (self.pos.x - self.last_pos.x) / dt
  self.target_angle = self.xvel * 0.002
  self.last_pos = self.pos:clone()

  self.angle = lume.lerp(self.angle, self.target_angle, 4.0*dt)

  if self.trail_timer <= 0 then
    self.trail_timer = 0.001
    table.insert(self.trail_positions, 1, self.pos:clone())
    table.insert(self.trail_angles, 1, self.angle)

    if #self.trail_positions > Player.NUM_TRAILS then
      table.remove(self.trail_positions, #self.trail_positions)
      table.remove(self.trail_angles, #self.trail_angles)
    end
  else
    self.trail_timer = self.trail_timer - dt
  end
end

local function shape()
  love.graphics.polygon('fill', -Player.WIDTH / 2,  Player.HEIGHT/2,
    0, -Player.HEIGHT / 2, 0, Player.HEIGHT / 2 - Player.DIP)
  love.graphics.polygon('fill', Player.WIDTH / 2,  Player.HEIGHT/2,
    0, -Player.HEIGHT / 2, 0, Player.HEIGHT / 2 - Player.DIP)
end

function Player:draw()
  Entity.draw(self)

  Color.WHITE:use()
  love.graphics.setLineStyle('rough')

  love.graphics.push()
  love.graphics.translate(self.pos:unpack())
  love.graphics.rotate(self.angle)
  shape()
  love.graphics.pop()

  local color = Color.WHITE:clone()
  for i=1, #self.trail_positions do
    color.a = color.a * 0.5
    color:use()
    love.graphics.push()
    love.graphics.translate(self.trail_positions[i]:unpack())
    love.graphics.rotate(self.trail_angles[i])
    shape()
    love.graphics.pop()
  end
end

function Player:move(dx, dy)
  self.pos = self.pos + vector(dx, dy)
  self.pos.x = lume.clamp(self.pos.x, - PlayArea.SIZE / 2 + Player.WIDTH / 2, PlayArea.SIZE / 2 - Player.WIDTH / 2)
  self.pos.y = lume.clamp(self.pos.y, - PlayArea.SIZE / 2 + Player.HEIGHT / 2, PlayArea.SIZE / 2 - Player.HEIGHT / 2)
end
