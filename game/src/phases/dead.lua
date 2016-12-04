local Dead = PlayState:addState('Dead')

function Dead:enteredState()
  PlayState.MUSIC:stop()
  if self.newrecord then
    love.filesystem.write("bestscore", tostring(self.score))
    self.bestscore = self.score
  end
  for _, ui in ipairs(self.ui) do ui.hidden = false end
end

function Dead:touchpressed(id, x, y, dx, dy, pressure)
  PlayState.touchpressed(self, id, x, y, dx, dy, pressure)
  self:startGame()
end
function Dead:mousepressed(x, y, button, istouch)
  PlayState.touchpressed(self, id, x, y, dx, dy, pressure )
  self:startGame()
end
function Dead:mousemoved(x, y, dx, dy, istouch)
  GameState.touchmoved(self, id, x, y, dx, dy, pressure)
end
function Dead:touchmoved(id, x, y, dx, dy, pressure)
  GameState.touchmoved(self, id, x, y, dx, dy, pressure)
end
function Dead:update(dt)
  -- Update total time.
  self.time = self.time + dt

  self.newrecord_visible = (self.time % 1) < 0.5
  self.player:update(dt)

  self.white_fader.time = self.white_fader.time + dt
  for _, ui in ipairs(self.ui) do ui:update(dt) end
end

function Dead:overlay()
  PlayState.overlay(self)
  if not self.newrecord then
    DrawBestScore(self)
  end
end
