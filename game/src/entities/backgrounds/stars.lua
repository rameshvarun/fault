Stars = class('Stars', Entity)
Stars.static.COUNT = 100
Stars.static.LAYER_SPEEDS = {1.0, 0.5, 0.2}

function Stars:initialize()
    Entity.initialize(self, 'background', -5, vector(0, 0))
    self.starlayers = {}

    for i=1, #Stars.LAYER_SPEEDS do table.insert(self.starlayers, {}) end
end

function Stars:start()
  self.left, self.top = self.gameState.cam:worldCoords(0, 0)
  self.right, self.bottom = self.gameState.cam:worldCoords(love.graphics.getWidth(), love.graphics.getHeight())

  for i=1, Stars.COUNT do
    local layer = lume.randomchoice(self.starlayers)
    table.insert(layer, vector(lume.random(self.left, self.right), lume.random(self.top, self.bottom)))
  end
end

function Stars:draw()
  for i, layer in ipairs(self.starlayers) do
    love.graphics.setColor(255, 255, 255, 255*Stars.LAYER_SPEEDS[i])
    for j, point in ipairs(layer) do
      love.graphics.line(point.x, point.y, point.x, point.y + 4)
    end
  end
end

function Stars:update(dt)
  for i, layer in ipairs(self.starlayers) do
    for j, point in ipairs(layer) do
      point.y = point.y + 40*dt*Stars.LAYER_SPEEDS[i]
      if point.y > self.bottom then point.y = self.top - 4 end
    end
  end
end
