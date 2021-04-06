local Initial = PlayState:addState('Initial')

function DrawBestScore(self)
  Color.WHITE:use()
  love.graphics.setFont(self.best_font)
  love.graphics.printf(string.format("BEST: %.1f", self.bestscore),
    love.graphics.getWidth()/2 - love.graphics.getWidth()/2,
    (love.graphics.getHeight()/2 - self.scale*PlayArea.SIZE/2)/2,
    love.graphics.getWidth(), "center")
end

function Initial:enteredState()
  if PLAY_RECORDING then
    Timer.after(1, function() self:startGame() end)
  end
end

function Initial:overlay()
    PlayState.overlay(self)

    Color.WHITE:use()
    love.graphics.setFont(self.instruction_font)

    local prompt = "TOUCH AND DRAG"
    if not MOBILE then prompt = "CLICK AND DRAG" end
    love.graphics.printf(prompt,
      love.graphics.getWidth()/2 - 0.5*PlayArea.SIZE*self.scale,
      love.graphics.getHeight()/2 + 25*self.scale,
      PlayArea.SIZE*self.scale,
      "center")

    love.graphics.circle('fill', love.graphics.getWidth()/2,
      love.graphics.getHeight()/2 + self.scale*65,
      self.scale*10*(1 + 0.2*(math.sin(self.time))^2),
      32)

    if self.bestscore ~= nil then
      DrawBestScore(self)
    end
end

function Initial:update(dt)
  GameState.update(self, dt)
  self:updateButtons(dt)
end

function Initial:touchpressed(id, x, y, dx, dy, pressure)
  PlayState.touchpressed(self, id, x, y, dx, dy, pressure)
  if self.ignore_touch[id] then return end
  self:startGame()
end

function Initial:touchmoved(id, x, y, dx, dy, pressure)
  -- Ignore touch moves in Initial phase.
end


function Initial:keypressed(key, scancode, isrepeat)
  PlayState.keypressed(self, key, scancode, isrepeat)
  if key == "space" then
    self:startGame()
  end
end
