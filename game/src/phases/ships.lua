local Ships = PlayState:addState('Ships')

local PHASE_DURATION = 23.5 - 11.75

function Ships:enteredState()
  local stars = self:addEntity(Stars())

  self:flashWhite(1.0)

  self:addEntity(Ship('top', PHASE_DURATION))

  self.timer:after(2, function()
    self:addEntity(Ship('right', PHASE_DURATION - 2))
  end)

  self.timer:after(4, function()
    self:addEntity(Ship('left', PHASE_DURATION - 4))
  end)

  self.timer:after(PHASE_DURATION, function()
    for _, ship in ipairs(self:getEntitiesByTag('ship')) do
      ship:destroy()
    end

    for _, bullet in ipairs(self:getEntitiesByTag('obstacle')) do
      bullet:destroy()
    end

    stars:destroy()
    self:gotoState('Tunnel')
  end)
end
