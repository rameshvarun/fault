PlayState = class('PlayState', GameState)
PlayState:include(Stateful)
PlayState.static.NEWRECORD_SOUND = love.audio.newSource( 'assets/sound/newrecord.wav', 'static' )
PlayState.static.NEWRECORD_SOUND:setVolume(0.2)

PlayState.static.MUSIC = love.audio.newSource('assets/sound/music.mp3', 'stream')
PlayState.MUSIC:setVolume(0.3)

function PlayState:initialize()
  self.ui = {}
  self.practice_mode_button = MenuButton(vector(0, 0))
  -- table.insert(self.ui, self.practice_mode_button)

  GameState.initialize(self)
  self:reset()
  self.cam:lookAt(0, 0)
  self:calculateScale()
  self:gotoState('Initial')

  if love.filesystem.isFile("bestscore") then
    local contents, size = love.filesystem.read("bestscore")
    self.bestscore = tonumber(contents)
  else
    self.bestscore = nil
  end

  self.white_fader = { time = 1.0, duration = 1.0 }


end

function PlayState:flashWhite(duration)
    self.white_fader = { time = 0, duration = duration }
end

function PlayState:reset()
  self.timer:clear()
  self.entities = {}
  self.arena = self:addEntity(PlayArea())
  self.arenashadow = self:addEntity(PlayAreaShadow())
  self.player = self:addEntity(Player())
  self.score = 0.0
  self.newrecord = false
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

  self.best_font = love.graphics.newFont("assets/roboto.ttf", 20*self.scale)
  self.best_font:setFilter('nearest', 'nearest', 0)

  self.new_record_font = love.graphics.newFont("assets/roboto.ttf", 20*self.scale)
  self.new_record_font:setFilter('nearest', 'nearest', 0)

  self.instruction_font = love.graphics.newFont("assets/roboto.ttf", 15*self.scale)
  self.instruction_font:setFilter('nearest', 'nearest', 0)

  self.endless_font = love.graphics.newFont("assets/roboto.ttf", 20*self.scale)
  self.endless_font:setFilter('nearest', 'nearest', 0)

  self.practice_mode_button.pos.x = love.graphics.getWidth()
  self.practice_mode_button.pos.y = love.graphics.getHeight()/4
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

function PlayState:startGame()
  self:reset()
  self:gotoState('FallingBlocks')
  PlayState.MUSIC:play()

  for _, ui in ipairs(self.ui) do ui.hidden = true end
end

function PlayState:update(dt)
  GameState.update(self, dt)
  self.score = self.score + dt

  if self.newrecord == false and (self.bestscore == nil or self.score > self.bestscore) then
    self.newrecord = true
    self.newrecord_visible = true

    if self.bestscore ~= nil then
      PlayState.NEWRECORD_SOUND:play()
    end
  end

  for _, ui in ipairs(self.ui) do ui:update(dt) end

  self.white_fader.time = self.white_fader.time + dt
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

  if self.bestscore ~= nil and self.newrecord and self.newrecord_visible then
    Color.WHITE:use()
    love.graphics.setFont(self.new_record_font)
    love.graphics.printf("NEW RECORD",
      love.graphics.getWidth()/2 - love.graphics.getWidth()/2,
      (love.graphics.getHeight()/2 - self.scale*PlayArea.SIZE/2)/2,
      love.graphics.getWidth(), "center")
  end

  for _, ui in ipairs(self.ui) do
    ui:overlay(self.scale)
  end

  if self.white_fader.time < self.white_fader.duration then
    love.graphics.setColor(255, 255, 255,
      255 * (1 - (self.white_fader.time / self.white_fader.duration)))
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  end
end

require_dir "src/phases"
