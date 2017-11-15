PlayState = class('PlayState', GameState)
PlayState:include(Stateful)
PlayState.static.NEWRECORD_SOUND = love.audio.newSource( 'assets/sound/newrecord.wav', 'static' )
PlayState.static.NEWRECORD_SOUND:setVolume(0.2)

PlayState.static.MUSIC = love.audio.newSource('assets/sound/music.mp3', 'stream')
PlayState.MUSIC:setLooping(true)
PlayState.MUSIC:setVolume(0.3)
PlayState.static.MUSIC_STARTS = {0, 52.18}


PlayState.static.VMARGIN = 20

function PlayState:initialize()
  self.buttons = {}

  self.signin_button = MenuButton(MenuButton.CONTROLLER, 1.5, function()
    love.system.googlePlayConnect()
  end, false)

  self.leaderboard_button = MenuButton(MenuButton.LEADERBOARDS, 1.5, function()
    love.system.showLeaderboard(IDS.LEAD_SURVIVAL_TIME)
  end, false)

  self.practice_mode_button = MenuButton(MenuButton.MORE, 1.5, function()
    GameState.switchTo(ModeMenu())
  end, false)

  self.achievements_button = MenuButton(MenuButton.ACHIEVEMENTS, 1.5, function()
    love.system.showAchievements()
  end, false)

  if ANDROID then
    table.insert(self.buttons, self.signin_button)
    table.insert(self.buttons, self.leaderboard_button)
    table.insert(self.buttons, self.achievements_button)
  end

  if IOS then
    table.insert(self.buttons, self.leaderboard_button)
    self.leaderboard_button.enabled = true
    table.insert(self.buttons, self.achievements_button)
    self.achievements_button.enabled = true
  end

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

  self.attempts = 0

  -- A table of touches that should be ignored.
  self.ignore_touch = {}
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

  for i, button in ipairs(self.buttons) do
    button.pos.x = love.graphics.getWidth()
    button.pos.y = 40 * self.scale * i
  end
end

function PlayState:resize(w, h) self:calculateScale() end

function PlayState:startGame()
  self:reset()
  self:gotoState('FallingBlocks')
  PlayState.MUSIC:play()

  PlayState.MUSIC:seek(PlayState.MUSIC_STARTS[math.floor(self.attempts / 5) % #PlayState.MUSIC_STARTS + 1])
  self.attempts = self.attempts + 1

  self:hideButtons()
end

function PlayState:hideButtons()
  for _, button in ipairs(self.buttons) do
    button.hidden = true
  end
end

function PlayState:updateButtons(dt)
  for _, button in ipairs(self.buttons) do
    button:update(dt)
  end

  if ANDROID then
    local connected = love.system.isGooglePlayConnected()
    self.signin_button.enabled = not connected
    self.leaderboard_button.enabled = connected
    self.achievements_button.enabled = connected
  end
end

function PlayState:showButtons()
  for _, button in ipairs(self.buttons) do
    button.hidden = false
  end
end


function PlayState:update(dt)
  GameState.update(self, dt)
  self.score = self.score + dt

  if self.newrecord == false and (self.bestscore == nil or self.score > self.bestscore) then
    self.newrecord = true
    self.newrecord_visible = true

    if self.bestscore ~= nil then
      PlayState.NEWRECORD_SOUND:play()

      if ANDROID then
        love.system.unlockAchievement(IDS.ACH_BEAT_YOUR_PERSONAL_BEST)
      end
    end
  end

  self:updateButtons(dt)
  self.white_fader.time = self.white_fader.time + dt
end

function PlayState:overlay()
  local trap_width = 60 * self.scale
  local trap_bottom_width = 40 * self.scale
  local trap_height = 30 * self.scale

  local score_top = 0
  if IOS then
    local left, top, right, bottom = love.window.getSafeAreaInsets()
    score_top = 0.65 * top * love.window.getPixelScale()
  end

  Color.WHITE:use()
  love.graphics.polygon('fill',
    love.graphics.getWidth()/2 - trap_width/2, score_top,
    love.graphics.getWidth()/2 + trap_width/2, score_top,
    love.graphics.getWidth()/2 + trap_bottom_width / 2, score_top + trap_height,
    love.graphics.getWidth()/2 - trap_bottom_width/2, score_top + trap_height)

  Color.BLACK:use()
  love.graphics.setFont(self.time_font)
  love.graphics.printf(string.format("%.1f", self.score),
    love.graphics.getWidth()/2 - trap_width/2, score_top + self.scale*3.5, trap_width, "center")

  if self.bestscore ~= nil and self.newrecord and self.newrecord_visible then
    Color.WHITE:use()
    love.graphics.setFont(self.new_record_font)
    love.graphics.printf("NEW RECORD",
      love.graphics.getWidth()/2 - love.graphics.getWidth()/2,
      (love.graphics.getHeight()/2 - self.scale*PlayArea.SIZE/2)/2,
      love.graphics.getWidth(), "center")
  end

  for _, button in ipairs(self.buttons) do
    button:overlay(self.scale)
  end

  if self.white_fader.time < self.white_fader.duration then
    love.graphics.setColor(255, 255, 255,
      255 * (1 - (self.white_fader.time / self.white_fader.duration)))
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  end
end

function PlayState:touchpressed(id, x, y, dx, dy, pressure)
  GameState.touchpressed(self, id, x, y, dx, dy, pressure)

  for _, button in ipairs(self.buttons) do
    if button:containsPoint(x, y) then
      self.ignore_touch[id] = true
      button.action()
      break
    end
  end

  if y < PlayState.VMARGIN or y > love.graphics.getHeight() - PlayState.VMARGIN then
    self.ignore_touch[id] = true
  end
end

function PlayState:touchreleased(id, x, y, dx, dy, pressure)
  self.ignore_touch[id] = false
end

function PlayState:touchmoved(id, x, y, dx, dy, pressure)
  GameState.touchmoved(self, id, x, y, dx, dy, pressure)
  if self.ignore_touch[id] then return end
  self.player:move(dx / self.scale, dy / self.scale)
end

require_dir "src/phases"
