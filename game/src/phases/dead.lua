local Dead = PlayState:addState('Dead')

function Dead:enteredState()
  if self.newrecord then
    love.filesystem.write("bestscore", tostring(self.score))
    self.bestscore = self.score
  end
end

function Dead:touchpressed(id, x, y, dx, dy, pressure)
  PlayState.touchpressed(self, id, x, y, dx, dy, pressure)
  self:reset()
  self:gotoState('FallingBlocks')
end
function Dead:mousepressed(x, y, button, istouch)
  PlayState.touchpressed(self, id, x, y, dx, dy, pressure )
  self:reset()
  self:gotoState('FallingBlocks')
end
function Dead:mousemoved(x, y, dx, dy, istouch)
  GameState.touchmoved(self, id, x, y, dx, dy, pressure)
end
function Dead:touchmoved(id, x, y, dx, dy, pressure)
  GameState.touchmoved(self, id, x, y, dx, dy, pressure)
end
function Dead:update(dt)
  GameState.update(self, dt)
  self.newrecord_visible = (self.time % 1) < 0.5
end
