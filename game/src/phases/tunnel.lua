local Tunnel = PlayState:addState('Tunnel')

local DURATION = 35.2 - 23.5

function Tunnel:enteredState()
  local hallway = self:addEntity(Hallway())
  self:flashWhite(1.0)

  local tunnel = self:addEntity(TunnelEntity())

  self.timer:after(DURATION, function()
    hallway:destroy()
    tunnel:destroy()
    self:gotoState('Endless')
  end)
end
