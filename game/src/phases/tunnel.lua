local Tunnel = PlayState:addState('Tunnel')

function Tunnel:enteredState()
  local hallway = self:addEntity(Hallway())
  self:flashWhite(1.0)
end
