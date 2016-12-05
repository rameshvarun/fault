PlayAreaShadow = class('PlayAreaShadow', Entity)

function PlayAreaShadow:initialize()
  Entity.initialize(self, 'playarea', -2, vector(0, 0))
end

function PlayAreaShadow:draw()
  Entity.draw(self)

  -- Draw red team goal.
  love.graphics.setColor(0, 0, 0, 0.25*255)
  love.graphics.rectangle('fill', -PlayArea.SIZE/2, -PlayArea.SIZE/2, PlayArea.SIZE, PlayArea.SIZE)
end
