require 'utils' -- Load in utilities.

inspect = require 'external.inspect'
class = require 'external.middleclass' -- Middleclass, for following OOP patterns.
Stateful = require 'external.stateful' -- Stateful.lua, for state-based classes.

vector = require 'external.vector' -- HUMP.vector, for the vector primitive.
collision = require 'external.hc.shapes' -- HardonCollider, for collision detection.
lume = require 'external.lume' -- Game-related helpers

Timer = require 'external.timer' -- HUMP.timer
Camera  = require 'external.camera' -- HUMP.camera for a camera abstraction.
Signal = require 'external.signal' -- HUMP.signal

Color = require 'src.color' -- Load in the color library.

require "src.gamestate" -- Load in game states.
require "src.entity" -- Load in entities.

function love.load(arg)
  GameState.switchTo(PlayState()) -- Switch to controller select menu.
end

function love.update(dt)
  Timer.update(dt) -- Update global timer events.

  -- If there is a current GameState, update it.
  if GameState.currentState ~= nil then
    GameState.currentState:update(dt)
  end
end

function love.draw()
  -- If there is a current gamestate, draw it.
  if GameState.currentState ~= nil then
    GameState.currentState:draw()
  end
end
