GameState = class('GameState')

-- Store the current, active GameState in a static variable.
GameState.static.currentState = nil
-- Static method to switch to a game state.
function GameState.static.switchTo(state)
  -- If we are moving away from an existing state, invoke the 'exit' function.
  if GameState.static.currentState ~= nil then
    GameState.static.currentState:exit()
  end

  -- Transition to the new state and invoke the 'enter' function.
  GameState.static.currentState = state
  GameState.static.currentState:enter()
end

-- Make callbacks redirect to the current GameState
local CALLBACKS = {'directorydropped', 'filedropped', 'focus', 'keypressed', 'keyreleased',
  'lowmemory', 'mousefocus', 'mousemoved', 'mousepressed', 'mousereleased', 'quit', 'resize', 'textedited',
  'textinput', 'threaderror', 'touchmoved', 'touchpressed', 'touchreleased', 'visible', 'wheelmoved',
  'joystickadded', 'joystickaxis', 'joystickhat', 'joystickpressed', 'joystickreleased', 'joystickremoved',
  'gamepadaxis', 'gamepadpressed', 'gamepadreleased'}

-- Input events.
for _, callback in ipairs(CALLBACKS) do
  GameState[callback] = function(self, ...) self.signals:emit(callback, ...) end
end

for _, callback in ipairs(CALLBACKS) do
  love[callback] = function(...)
    if GameState.currentState ~= nil then
      GameState.currentState[callback](GameState.currentState, ...)
    end
  end
end

-- Default draw order for entities.
function GameState.static.defaultDrawOrder(a, b)
  return a.layer < b.layer
end

function GameState:initialize()
  self.timer = Timer.new() -- Timer for handling tweening and delayed callbacks.
  self.cam = Camera.new() -- Camera for the scene.
  self.signals = Signal.new() -- A signal dispatcher.
  self.entities = {} -- A list of entities in the scene.
  self.time = 0 -- Global time measure.
end

function GameState:update(dt)
  -- Update total time.
  self.time = self.time + dt
  -- Step the timer / tweening system for this state forward.
  self.timer:update(dt)
  -- Update every entity one step.
  for _, entity in ipairs(self.entities) do entity:update(dt) end
  -- Prune dead entities.
  self.entities = lume.reject(self.entities, function(e) return e.dead end)
end

function GameState:draw()
  -- Sort entities - first by layer, then by y-position
  self.entities = lume.sort(self.entities, GameState.defaultDrawOrder)

  -- Perform regular draw and debug with the camera transformation.
  self.cam:attach()
  for _, entity in ipairs(self.entities) do
    if entity.visible then entity:draw() end
  end
  self.cam:detach()

  self:overlay()
end

function GameState:overlay()
end

function GameState:addEntity(entity)
  assert(entity:isInstanceOf(Entity)) -- Assert that the argument is an instance of Entity.
  entity:setGameState(self) -- Give the entity a reference to the current GameState.
  entity:start() -- 'Start' the entity.
  table.insert(self.entities, entity) -- Add the entity to the table of entities.
  return entity -- Return the entity (for compositional purposes).
end

-- Empty enter and exit functions.
function GameState:enter() end
function GameState:exit() end

-- Get the first entity that has a certain tag.
function GameState:getEntityByTag(tag)
  for _, entity in ipairs(self.entities) do
    if entity.tag == tag then return entity end
  end
end

-- Get a list of all entities with a certain tag.
function GameState:getEntitiesByTag(tag)
  local entities = {}
  for _, entity in ipairs(self.entities) do
    if entity.tag == tag then table.insert(entities, entity) end
  end
  return entities
end

-- Turn mouse clicks into a touch.
function GameState:mousepressed(x, y, button, istouch)
  if istouch or button ~= 1 then return end
  self:touchpressed('mouse', x, y, 0, 0, 0)
end
function GameState:mousereleased(x, y, button, istouch)
  if istouch or button ~= 1 then return end
  self:touchreleased('mouse', x, y, 0, 0, 0)
end
function GameState:mousemoved(x, y, dx, dy, istouch)
  if istouch or not love.mouse.isDown(1) then return end
  self:touchmoved('mouse', x, y, dx, dy, 0)
end


require_dir "src/states"
