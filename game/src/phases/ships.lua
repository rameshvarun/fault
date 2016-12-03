local Ships = PlayState:addState('Ships')

local PHASE_DURATION = 10

function Ships:enteredState()
  self:addEntity(Stars())

  self:addEntity(Ship('top', PHASE_DURATION))

  self.timer:after(2, function()
    self:addEntity(Ship('right', PHASE_DURATION - 2))
  end)

  self.timer:after(4, function()
    self:addEntity(Ship('left', PHASE_DURATION - 4))
  end)
end
