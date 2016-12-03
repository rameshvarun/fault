Ship = class('Ship', Entity)
Ship:include(Stateful)

Ship.static.SHAPE = {
  0.2 - 0.5, 0 - 0.5,
  0.8 - 0.5, 0 - 0.5,
  1 - 0.5, 0.5 - 0.5,
  0.8 - 0.5, 0.7 - 0.5,
  0.85 - 0.5, 0.5 - 0.5,
  0.7 - 0.5, 0.3 - 0.5,
  0.3 - 0.5, 0.3 - 0.5,
  0.15 - 0.5, 0.5 - 0.5,
  0.2 - 0.5, 0.7 - 0.5,
  0 - 0.5, 0.5 - 0.5
}
Ship.static.TRIANGLES = love.math.triangulate(Ship.SHAPE)
Ship.static.INTRO_TIME = 1.0
Ship.static.LEAVE_TIME = 1.0

Ship.static.LEFT = -PlayArea.SIZE/2 + 3
Ship.static.RIGHT = PlayArea.SIZE/2 - 3
Ship.static.DISTANCE = 480
Ship.static.SPEED = 70
Ship.static.FIRE_FREQ = 0.4
Ship.static.BULLET_SPEED = 2.5*60

function Ship:initialize(side, duration)
  Entity.initialize(self, 'ship', 0, vector(0, 0))

  self.side = side
  self.vpos = vector(love.math.random(Ship.LEFT, Ship.RIGHT), PlayArea.SIZE/2 + Ship.DISTANCE)
  self.duration = duration

  if side == "top" then
    self.angle = 0
  elseif side == "right" then
    self.angle = math.pi / 2
  elseif side == "bottom" then
    self.angle = math.pi
  elseif side == "left" then
    self.angle =  - math.pi / 2
  end

  self:gotoState('Entering')
end

function Ship:update(dt)
  Entity.update(self, dt)
  if self.time > self.duration then
    self:destroy()
  end
end

function Ship:draw()
  Entity.draw(self)

  if self.side == "top" then
    self.pos = vector(self.vpos.x, -self.vpos.y)
  elseif self.side == "right" then
    self.pos = vector(self.vpos.y, self.vpos.x)
  elseif self.side == "bottom" then
    self.pos = vector(self.vpos.x, self.vpos.y)
  elseif self.side == "left" then
    self.pos = vector(-self.vpos.y, self.vpos.x)
  end

  Color.GREEN:use()
  love.graphics.push()
  love.graphics.translate(self.pos:unpack())
  love.graphics.rotate(self.angle)
  love.graphics.scale(30, 30)
  for _, triangle in ipairs(Ship.TRIANGLES) do
    love.graphics.polygon('fill', triangle)
  end
  love.graphics.pop()
end

local easeOutCubic = Timer.tween.out(Timer.tween.cubic)
local easeInCubic = Timer.tween.cubic

local Entering = Ship:addState('Entering')
function Entering:update(dt)
  Ship.update(self, dt)
  local t = self.time / Ship.INTRO_TIME
  self.vpos.y = lume.lerp(PlayArea.SIZE/2 + Ship.DISTANCE, PlayArea.SIZE/2 + 30,
    easeOutCubic(t))

  if self.time > Ship.INTRO_TIME then
    self:gotoState('Shooting')
  end
end


local Shooting = Ship:addState('Shooting')
function Shooting:enteredState()
  self.direction = 'right'
  self.fire_timer = 0
end

function Shooting:update(dt)
  Ship.update(self, dt)

  if self.direction == "right" then
    self.vpos.x = self.vpos.x + Ship.SPEED*dt
    if self.vpos.x > Ship.RIGHT then self.direction = "left" end
  elseif self.direction == "left" then
    self.vpos.x = self.vpos.x - Ship.SPEED*dt
    if self.vpos.x < Ship.LEFT then self.direction = "right" end
  end

  self.fire_timer = self.fire_timer + dt
  if self.fire_timer > Ship.FIRE_FREQ then
    self.fire_timer = 0

    local direction = vector(0, 0)
    if self.side == "top" then
      direction = vector(0, 1)
    elseif self.side == "right" then
      direction = vector(-1, 0)
    elseif self.side == "left" then
      direction = vector(1, 0)
    elseif self.side == "bottom" then
      direction = vector(0, -1)
    end

    self.gameState:addEntity(Block(
      self.pos:clone(), self.angle, vector(5, 15), Ship.BULLET_SPEED*direction, Color.GREEN))
  end

  if self.time > self.duration - Ship.LEAVE_TIME then
    self:gotoState('Leaving')
  end
end

local Leaving = Ship:addState('Leaving')
function Leaving:update(dt)
  Ship.update(self, dt)
  local t = (self.time - self.duration + Ship.INTRO_TIME) / Ship.INTRO_TIME
  self.vpos.y = lume.lerp(PlayArea.SIZE/2 + 30, PlayArea.SIZE/2 + Ship.DISTANCE,
    easeInCubic(t))
end
