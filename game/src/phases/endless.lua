local Endless = PlayState:addState('Endless')

function Endless:enteredState()
  if ANDROID then
    love.system.unlockAchievement(IDS.ACH_REACH_ENDLESS_MODE)
  end

  self:flashWhite(1.0)

  self.epilepsy = self:addEntity(Epilepsy())
  self.speed = 3*60
  self.scaling = 2
  self.block_timer = 0
end

function Endless:update(dt)
  PlayState.update(self, dt)

  self.scaling = self.scaling + dt * 0.025
  self.block_timer = self.block_timer + dt*self.scaling
  if self.block_timer > 0.5 then
    self.block_timer = 0
    local width = PlayArea.SIZE * lume.random(0.2, 0.8)
    local center = lume.random(-0.4, 0.4) * PlayArea.SIZE
    local block = Block(vector(center, -PlayArea.SIZE - 200), 0, vector(width, 10),
      vector(0, self.scaling*self.speed), Color.RED)
      self:addEntity(block)
  end
end

function Endless:overlay()
  PlayState.overlay(self)

  Color.WHITE:use()
  love.graphics.setFont(self.endless_font)
  love.graphics.printf("ENDLESS MODE",
    love.graphics.getWidth()/2 - 0.5*PlayArea.SIZE*self.scale,
    (love.graphics.getHeight()/2 + self.scale*PlayArea.SIZE/2 + love.graphics.getHeight())/2 - 10*self.scale,
    PlayArea.SIZE*self.scale,
    "center")
end
