local Endless = PlayState:addState('Endless')

function Endless:enteredState()
  self:flashWhite(1.0)

  self.epilepsy = self:addEntity(Epilepsy())
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
