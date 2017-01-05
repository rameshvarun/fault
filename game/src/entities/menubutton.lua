MenuButton = class('MenuButton')
MenuButton.static.RADIUS = 15
MenuButton.static.INNER_RADIUS = 13
MenuButton.static.LENGTH = 40

MenuButton.static.CONTROLLER = love.graphics.newImage("assets/graphics/controller.png")
--MenuButton.CONTROLLER:setFilter('nearest', 'nearest')

MenuButton.static.LEADERBOARDS = love.graphics.newImage("assets/graphics/leaderboards.png")
--MenuButton.LEADERBOARDS:setFilter('nearest', 'nearest')

MenuButton.static.ACHIEVEMENTS = love.graphics.newImage("assets/graphics/achievements.png")

MenuButton.static.MORE = love.graphics.newImage("assets/graphics/more.png")
MenuButton.MORE:setFilter('nearest', 'nearest')

function MenuButton:initialize(image, image_scale, action, enabled)
  self.pos = vector(0, 0)
  self.hidden = false
  self.x = MenuButton.RADIUS + MenuButton.LENGTH
  self.image = image
  self.image_scale = image_scale
  self.action = action
  self.enabled = enabled
end

function MenuButton:overlay(scale)
  Color.WHITE:use()
  love.graphics.circle('fill', self.pos.x - MenuButton.LENGTH*scale + self.x*scale,
    self.pos.y, scale * MenuButton.RADIUS, 32)

  love.graphics.rectangle('fill', self.pos.x - MenuButton.LENGTH*scale + self.x*scale,
    self.pos.y - MenuButton.RADIUS*scale*0.99,
    MenuButton.LENGTH*scale, 2*MenuButton.RADIUS*scale*0.99)

    Color.BLACK:use()
    love.graphics.circle('fill', self.pos.x - MenuButton.LENGTH*scale + self.x*scale,
      self.pos.y, scale * MenuButton.INNER_RADIUS, 32)

  Color.WHITE:use()
  love.graphics.draw(self.image, self.pos.x - MenuButton.LENGTH*scale + self.x*scale,
    self.pos.y, 0, self.image_scale*MenuButton.RADIUS*scale/self.image:getWidth(),
    self.image_scale*MenuButton.RADIUS*scale/self.image:getHeight(),
    self.image:getWidth()/2, self.image:getHeight()/2)

  self.click_target = {
    left = self.pos.x - MenuButton.LENGTH*scale + self.x*scale - scale * MenuButton.RADIUS / 2,
    right = self.pos.x - MenuButton.LENGTH*scale + self.x*scale + MenuButton.LENGTH*scale,
    top = self.pos.y - scale * MenuButton.RADIUS / 2,
    bottom = self.pos.y - MenuButton.RADIUS*scale*0.99 + 2*MenuButton.RADIUS*scale*0.99
  }
end

function MenuButton:containsPoint(x, y)
  if x > self.click_target.left and x < self.click_target.right
    and y > self.click_target.top and y < self.click_target.bottom then
      return true
  end
  return false
end

function MenuButton:update(dt)
  local show = not self.hidden and self.enabled
  if not show and self.x < MenuButton.RADIUS + MenuButton.LENGTH then
    self.x = self.x + dt*200
  end

  if show and self.x > 0 then
    self.x = math.max(self.x - dt*200, 0)
  end
end
