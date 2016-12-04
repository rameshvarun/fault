MenuButton = class('MenuButton')
MenuButton.static.RADIUS = 15
MenuButton.static.INNER_RADIUS = 13
MenuButton.static.LENGTH = 40

MenuButton.static.LEADERBOARD = love.graphics.newImage("assets/graphics/leaderboard.png")

function MenuButton:initialize(pos)
  self.pos = pos
  self.hidden = false
  self.x = 0
end

function MenuButton:overlay(scale)
  self.image = MenuButton.LEADERBOARD

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
    self.pos.y, 0, MenuButton.RADIUS*scale/self.image:getWidth(), MenuButton.RADIUS*scale/self.image:getHeight(),
    self.image:getWidth()/2, self.image:getHeight()/2)
end

function MenuButton:update(dt)
  if self.hidden and self.x < MenuButton.RADIUS + MenuButton.LENGTH then
    self.x = self.x + dt*200
  end

  if not self.hidden and self.x > 0 then
    self.x = self.x - dt*200
  end
end
