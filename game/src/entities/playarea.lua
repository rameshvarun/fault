PlayArea = class('PlayArea', Entity)
PlayArea.static.SIZE = 200

function PlayArea:initialize()
  Entity.initialize(self, 'playarea', 0, vector(0, 0))
end

function PlayArea:draw()
  Entity.draw(self)

  -- Draw red team goal.
  love.graphics.setLineWidth(2)
  love.graphics.setLineStyle('rough')
  Color.WHITE:use()
  love.graphics.rectangle('line', -PlayArea.SIZE/2, -PlayArea.SIZE/2, PlayArea.SIZE, PlayArea.SIZE)
end
