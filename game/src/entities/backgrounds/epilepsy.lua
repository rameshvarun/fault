Epilepsy = class('Epilepsy', Entity)

Epilepsy.static.COLORS = {Color(0, 1, 1), Color(1, 0, 1),
      Color(0, 1, 1), Color(1, 1, 0)}

function Epilepsy:initialize()
    Entity.initialize(self, 'background', -5, vector(0, 0))
    self.colors = lume.shuffle(Epilepsy.COLORS)
    self.color = 0
    self.transition = 0
end

function Epilepsy:draw()
  self.left, self.top = self.gameState.cam:worldCoords(0, 0)
  self.right, self.bottom = self.gameState.cam:worldCoords(love.graphics.getWidth(), love.graphics.getHeight())

  local current = self.colors[(self.color % #Epilepsy.COLORS) + 1]
  local target = self.colors[((self.color + 1) % #Epilepsy.COLORS) + 1]

  love.graphics.setColor(lume.lerp(current.r, target.r, self.transition),
    lume.lerp(current.g, target.g, self.transition),
    lume.lerp(current.b, target.b, self.transition),
    255)
  love.graphics.rectangle('fill', self.left, self.top, self.right - self.left, self.bottom - self.top)
end

function Epilepsy:update(dt)
  self.transition = self.transition + dt / 5.0
  if self.transition > 1 then
    self.transition = 0
    self.color = self.color + 1
  end
end
