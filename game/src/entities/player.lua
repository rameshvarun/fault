Player = class('Player', Entity)
Player:include(Stateful)

Player.static.WIDTH = 10;
Player.static.HEIGHT = 15
Player.static.DIP = 5
Player.static.NUM_TRAILS = 5
Player.static.DEATH_SOUND = love.audio.newSource( 'assets/sound/die.wav', 'static' )
Player.static.DEATH_SOUND:setVolume(0.2)

Player.static.SHAPE = {
  -Player.WIDTH / 2,  Player.HEIGHT/2,
  0, -Player.HEIGHT / 2,
  Player.WIDTH / 2,  Player.HEIGHT/2,
  0, Player.HEIGHT / 2 - Player.DIP
}

function Player:initialize()
  Entity.initialize(self, 'player', 0, vector(0, -30))
  self.angle = 0
  self.target_angle = 0
  self.last_pos = self.pos:clone()
  self.last_angle = 0

  self.trail_positions = {}
  self.trail_angles = {}
  self.trail_timer = 0

  self.collision_shape = collision.newPolygonShape(unpack(Player.SHAPE))
  local x, y = self.collision_shape:center()
  self.collision_offset = vector(x, y)
end

function Player:update(dt)
  Entity.update(self, dt)

  local xvel = (self.pos.x - self.last_pos.x) / dt
  self.target_angle = xvel * 0.002

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

  local INTERVALS = 5
  for i=1, INTERVALS do
    local angle = lume.lerp(self.last_angle, self.angle, i / INTERVALS)
    local pos = vector(
      lume.lerp(self.last_pos.x, self.pos.x, i / INTERVALS),
      lume.lerp(self.last_pos.y, self.pos.y, i / INTERVALS)
    )
    self.collision_shape:moveTo((pos + self.collision_offset):unpack())
    self.collision_shape:setRotation(angle)

    for _, obstacle in ipairs(self.gameState:getEntitiesByTag('obstacle')) do
      local collision, dx, dy = obstacle:collidesWith(self.collision_shape)
      if collision then
        self.pos = pos - vector(dx, dy)
        Player.DEATH_SOUND:play()
        self.gameState:gotoState('Dead')
        self:gotoState('Dead')
        break
      end
    end
  end

  self.last_pos = self.pos:clone()
  self.last_angle = self.angle
end

function Player:arrowShape()
  love.graphics.polygon('fill', -Player.WIDTH / 2,  Player.HEIGHT/2,
    0, -Player.HEIGHT / 2, 0, Player.HEIGHT / 2 - Player.DIP)
  love.graphics.polygon('fill', Player.WIDTH / 2,  Player.HEIGHT/2,
    0, -Player.HEIGHT / 2, 0, Player.HEIGHT / 2 - Player.DIP)
end

function Player:drawBody()
  Color.WHITE:use()
  love.graphics.setLineStyle('rough')

  love.graphics.push()
  love.graphics.translate(self.pos:unpack())
  love.graphics.rotate(self.angle)
  self:arrowShape()
  love.graphics.pop()
end

function Player:draw()
  Entity.draw(self)

  self:drawBody()

  local color = Color.WHITE:clone()
  for i=1, #self.trail_positions do
    color.a = color.a * 0.5
    color:use()
    love.graphics.push()
    love.graphics.translate(self.trail_positions[i]:unpack())
    love.graphics.rotate(self.trail_angles[i])
    self:arrowShape()
    love.graphics.pop()
  end
end

function Player:move(dx, dy)
  self.pos = self.pos + vector(dx, dy)
  self.pos.x = lume.clamp(self.pos.x, - PlayArea.SIZE / 2 + Player.WIDTH / 2, PlayArea.SIZE / 2 - Player.WIDTH / 2)
  self.pos.y = lume.clamp(self.pos.y, - PlayArea.SIZE / 2 + Player.HEIGHT / 2, PlayArea.SIZE / 2 - Player.HEIGHT / 2)
end

local Dead = Player:addState('Dead')

-- Can't move a dead player.
function Dead:move(dx, dy) end

function Dead:enteredState()
  self.outline_time = 0
end

function Dead:draw()
  Entity.draw(self)
  self:drawBody()

  Color.WHITE:use()
  love.graphics.setLineStyle('rough')


  love.graphics.push()
  love.graphics.translate(self.pos:unpack())
  love.graphics.rotate(self.angle)
  love.graphics.scale(1 + self.outline_time, 0.9 + self.outline_time)
  love.graphics.setColor(255, 255, 255, 255*(2.0 - self.outline_time)/2.0)
  love.graphics.setLineWidth(0.5)
  love.graphics.polygon('line', unpack(Player.SHAPE))
  love.graphics.pop()
end

function Dead:update(dt)
  Entity.update(self, dt)
  self.outline_time = self.outline_time + dt*2
  if self.outline_time > 2.0 then self.outline_time = 0 end
end
