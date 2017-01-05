ModeMenu = class('ModeMenu', GameState)

function ModeMenu:initialize()
  GameState.initialize(self)

  self.white_fader = { time = 0.0, duration = 1.0 }
  self.buttons = {
    {text = "Maze"},
    {text = "Ships"},
    {text = "Tunnel"},
    {text = "Endless"},
    {text = "Maze + Ships"}
  }

  self:resize(love.graphics.getWidth(), love.graphics.getHeight())
end

function ModeMenu:resize(w, h)
  local scale = love.graphics.getHeight() / 100
  self.scale = scale
  local VMARGIN, HMARGIN = 3, 5

  self.button_font = love.graphics.newFont("assets/roboto.ttf", 5*scale)
  self.button_font:setFilter('nearest', 'nearest', 0)

  for i, button in ipairs(self.buttons) do
    button.x = HMARGIN * scale
    button.width = love.graphics.getWidth() - 2*HMARGIN*scale
    button.height = scale*10
    button.y = scale * VMARGIN * i + button.height * (i - 1)
  end
  self.back = {
    x = HMARGIN * scale,
    y = love.graphics.getHeight() - VMARGIN * scale - scale * 3,
    width = scale * 3,
    height = scale * 3
  }
end

function ModeMenu:update(dt)
  GameState.update(self, dt)
  self.white_fader.time = self.white_fader.time + dt
end

function ModeMenu:overlay()
  if self.white_fader.time < self.white_fader.duration then
    love.graphics.setColor(255, 255, 255,
      255 * (1 - (self.white_fader.time / self.white_fader.duration)))
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  end

  Color.WHITE:use()
  love.graphics.setFont(self.button_font)

  for i, button in ipairs(self.buttons) do
    love.graphics.setLineWidth(self.scale * 0.3)
    love.graphics.rectangle('line', button.x, button.y, button.width, button.height)
    love.graphics.printf(button.text, button.x, button.y + button.height/2 - self.scale*3, button.width, "center")
  end

  love.graphics.polygon('fill', self.back.x, self.back.y,
    self.back.x + self.back.height, self.back.y + self.back.width,
    self.back.x + self.back.height, self.back.y - self.back.width)
  love.graphics.rectangle('fill',
    self.back.x + self.back.width,
    self.back.y - 0.75*self.back.height / 2,
    1.2*self.back.width,
    0.75*self.back.height)
end

function ModeMenu:touchpressed(id, x, y, dx, dy, pressure)
  GameState.touchpressed(self, id, x, y, dx, dy, pressure)

  if x > self.back.x and x < self.back.x + self.back.width + 1.2*self.back.width and
   y > self.back.y - self.back.width and y < self.back.y + self.back.width then
     GameState.switchTo(PlayState())
  end
end
