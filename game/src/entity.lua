Entity = class('Entity')

-- Utility to generate a randomized id for an entity.
Entity.static.ID_LENGTH = 5
Entity.static.ID_VALUES = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_'
Entity.static.generateID = function()
  local id = ""
  while id:len() < Entity.ID_LENGTH do
    id = id .. Entity.ID_VALUES:byte(love.math.random(1, Entity.ID_VALUES:len()))
  end
  return id
end

function Entity:initialize(tag, layer, pos)
  -- Argument type checking.
  assert(type(tag) == "string", "'tag' must be a string.")
  assert(type(layer) == "number", "'layer' must be a number.")
  assert(vector.isvector(pos), "'pos' must be a vector. ")

  self.id = Entity.generateID() -- Generate a random ID.

  self.tag = tag -- Some sort of descriptive category for this entity. eg: 'player'
  self.layer = layer -- The layer that this entity is on. Determines draw order.
  self.pos = pos -- The position of this entity (vector). All entities need a
  -- position, though it may not have any semantic meaning. Determines draw order.

  self.time = 0

  self.dead = false -- Whether or not the entity is dead (starts out as false).
  -- Call self:destroy() to mark as dead.
  self.visible = true -- Whether not this entity should be drawn.
  self.enabled = true -- Whether or not this entity should be updated or drawn.

  self.gameState = nil -- Reference to the owning gamestate. Starts out as nil.
end

-- Invoked after an entity has been added to a GameState. By default, it simply invokes start
-- on all of the components that have been added to this object.
function Entity:start() end

-- Getters for values that shouldn't be changed after an entity's contruction.
function Entity:getTag() return self.tag end
function Entity:getID() return self.id end

-- Getters and setters for mutable properties.
function Entity:getLayer() return self.layer end
function Entity:getPos() return self.pos end
function Entity:setLayer(layer) self.layer = layer end
function Entity:setPos(pos) self.pos = pos end

-- Show and hide this entity.
function Entity:hide() self.visible = false end
function Entity:show() self.visible = true end
function Entity:isVisible() return self.visible end

-- Disable and enable this entity.
function Entity:disable() self.enabled = false end
function Entity:enable() self.enabled = true end
function Entity:isEnabled() return self.enabled end

-- Set / get the owning GameState of this entity.
function Entity:setGameState(gameState) self.gameState = gameState end
function Entity:getGameState() return self.gameState end

function Entity:draw() end
function Entity:debugDraw()
  -- Draw a dot at the location of this entity.
  love.graphics.setPointSize(10)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.points(self.pos:unpack())
end

-- Draw and update simply call out to the components.
function Entity:overlay() end
-- Draw and update simply call out to the components.
function Entity:debugOverlay() end

function Entity:update(dt) self.time = self.time + dt end

-- Mark this entity for removal, and destroy all components.
function Entity:destroy() self.dead = true end
function Entity:isDead() return self.dead end -- Check if this entity has been marked for removal.

require_dir "src/entities"
