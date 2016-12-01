PlayState = class('PlayState', GameState)
PlayState:include(Stateful)

function PlayState:initialize()
  GameState.initialize(self)
  self:reset()

  self.cam:lookAt(0, 0)


  self:calculateScale()

  self:gotoState('Initial')
end

function PlayState:reset()
  self.entities = {}
  self.arena = self:addEntity(PlayArea())
  self.player = self:addEntity(Player())
  self.score = 0.0
end

function PlayState:calculateScale()
  local hmargin = 40
  local hscale = love.graphics.getWidth() / (PlayArea.SIZE + 2 * hmargin)

  local vmargin = 100
  local vscale = love.graphics.getHeight() / (PlayArea.SIZE + 2 * vmargin)

  self.scale = math.min(hscale, vscale)
  self.cam:zoomTo(self.scale)

  self.time_font = love.graphics.newFont("assets/roboto.ttf", 20*self.scale)
  self.time_font:setFilter('nearest', 'nearest', 0)

  self.instruction_font = love.graphics.newFont("assets/roboto.ttf", 15*self.scale)
  self.instruction_font:setFilter('nearest', 'nearest', 0)

  self.endless_font = love.graphics.newFont("assets/roboto.ttf", 20*self.scale)
  self.endless_font:setFilter('nearest', 'nearest', 0)
end

function PlayState:resize(w, h) self:calculateScale() end

function PlayState:touchmoved(id, x, y, dx, dy, pressure)
  GameState.touchmoved(self, id, x, y, dx, dy, pressure)
  self.player:move(dx / self.scale, dy / self.scale)
end

function PlayState:mousemoved(x, y, dx, dy, istouch )
  GameState.touchmoved(self, id, x, y, dx, dy, pressure)
  if istouch or not love.mouse.isDown(1) then return end
  self.player:move(dx / self.scale, dy / self.scale)
end

function PlayState:update(dt)
  GameState.update(self, dt)
  self.score = self.score + dt
end

function PlayState:overlay()
  local trap_width = 60 * self.scale
  local trap_bottom_width = 40 * self.scale
  local trap_height = 30 * self.scale

  Color.WHITE:use()
  love.graphics.polygon('fill', love.graphics.getWidth()/2 - trap_width/2, 0,
    love.graphics.getWidth()/2 + trap_width/2, 0, love.graphics.getWidth()/2 + trap_bottom_width / 2, trap_height,
    love.graphics.getWidth()/2 - trap_bottom_width/2, trap_height)

  Color.BLACK:use()
  love.graphics.setFont(self.time_font)
  love.graphics.printf(string.format("%.1f", self.score), love.graphics.getWidth()/2 - trap_width/2, self.scale*3.5, trap_width, "center")
end

require_dir "src/phases"
