Hallway = class('Hallway', Entity)
Hallway.static.SQUARE_PERIOD = 4.0
Hallway.static.NUM_SQUARES = 20

function Hallway:initialize()
    Entity.initialize(self, 'background', -5, vector(0, 0))
    self.squares = {}

    for i=1,Hallway.NUM_SQUARES do
      table.insert(self.squares, (i / Hallway.NUM_SQUARES) * Hallway.SQUARE_PERIOD)
    end
end

function Hallway:draw()
  love.graphics.setColor(255, 255, 255, 255*0.5)
  for _, t in ipairs(self.squares) do
    local pos = vector(
      0, - (1 - 2*(t / Hallway.SQUARE_PERIOD))*80 + 50
    )
    local s = lume.lerp(0, 900, (t / Hallway.SQUARE_PERIOD))
    local r = lume.lerp(0.5, 0, (t / Hallway.SQUARE_PERIOD))

    love.graphics.setLineWidth(2 / s)

    love.graphics.push()
    love.graphics.translate(pos:unpack())
    love.graphics.scale(s)
    love.graphics.rotate(r)
    love.graphics.rectangle('line', -0.5, -0.5, 1.0, 1.0)
    love.graphics.pop()
  end
end

function Hallway:update(dt)
    for i, t in ipairs(self.squares) do
      self.squares[i] = self.squares[i] + dt
      if self.squares[i]  > Hallway.SQUARE_PERIOD then
        self.squares[i] = 0
      end
    end
end
