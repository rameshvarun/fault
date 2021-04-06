local Dead = PlayState:addState('Dead')

function Dead:enteredState()
  if ANDROID or IOS then
    love.system.unlockAchievement(IDS.ACH_PLAY_A_GAME)
    love.system.submitScore(IDS.LEAD_SURVIVAL_TIME, self.score * 100)
  end

  PlayState.MUSIC:stop()
  if self.newrecord then
    love.filesystem.write("bestscore", tostring(self.score))
    self.bestscore = self.score
  end

  if PLAY_RECORDING then
    Timer.after(3, function() love.event.quit(0) end)
  end

  love.mouse.setVisible(true)
  love.mouse.setGrabbed(false)
  self:showButtons()
end

function Dead:update(dt)
  -- Update total time.
  self.time = self.time + dt

  self.newrecord_visible = (self.time % 1) < 0.5
  self.player:update(dt)

  self.white_fader.time = self.white_fader.time + dt
  self:updateButtons(dt)
end

function Dead:overlay()
  PlayState.overlay(self)
  if not self.newrecord then
    DrawBestScore(self)
  end
end

function Dead:touchpressed(id, x, y, dx, dy, pressure)
  PlayState.touchpressed(self, id, x, y, dx, dy, pressure)
  if self.ignore_touch[id] then return end
  self:startGame()
end

function Dead:keypressed(key, scancode, isrepeat)
  PlayState.keypressed(self, key, scancode, isrepeat)
  if key == "space" then
    self:startGame()
  end
end
