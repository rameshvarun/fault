PlayState = class('PlayState', GameState)

function PlayState:initialize()
  GameState.initialize(self)
  self.arena = self:addEntity(PlayArea())
  self.player = self:addEntity(Player())

  self.cam:lookAt(0, 0)

  local hmargin = 40
  local hscale = love.graphics.getWidth() / (PlayArea.SIZE + 2 * hmargin)

  local vmargin = 100
  local vscale = love.graphics.getHeight() / (PlayArea.SIZE + 2 * vmargin)

  self.scale = math.min(hscale, vscale)
  self.cam:zoom(self.scale)
end

function PlayState:touchmoved(id, x, y, dx, dy, pressure)
  GameState.touchmoved(self, id, x, y, dx, dy, pressure)
  self.player:move(dx / self.scale, dy / self.scale)
end

function PlayState:mousemoved(x, y, dx, dy, istouch )
  GameState.touchmoved(self, id, x, y, dx, dy, pressure)
  if istouch or not love.mouse.isDown(1) then return end
  self.player:move(dx / self.scale, dy / self.scale)
end

function PlayState:overlay()
  local trap_width = 60 * self.scale
  local trap_bottom_width = 40 * self.scale
  local trap_height = 30 * self.scale

  Color.WHITE:use()
  love.graphics.polygon('fill', love.graphics.getWidth()/2 - trap_width/2, 0,
    love.graphics.getWidth()/2 + trap_width/2, 0, love.graphics.getWidth()/2 + trap_bottom_width / 2, trap_height,
    love.graphics.getWidth()/2 - trap_bottom_width/2, trap_height)
end
