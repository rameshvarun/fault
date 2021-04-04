require 'utils' -- Load in utilities.

-- Platform info.
ANDROID = love.system.getOS() == "Android"
IOS = love.system.getOS() == "iOS"
MOBILE = ANDROID or IOS

IDS = require 'src.ids' -- IDs for achievements and leaderboards.

inspect = require 'external.inspect' -- Pretty printing Lua objects.
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

-- Arguments
CREATE_RECORDING = lume.any(arg, function(x) return x == "--create-recording" end)
PLAY_RECORDING = lume.any(arg, function(x) return x == "--play-recording" end)

-- Android should launch in immersive mode.
if ANDROID or IOS then love.window.setFullscreen(true) end

-- iOS should immediately start to authenticate local player
if IOS then love.system.authenticateLocalPlayer() end

function love.load(arg)
  if arg[2] == 'debug' then DEBUG = true end
  GameState.switchTo(PlayState()) -- Switch to the initial game state.
end

MAX_DELTA_TIME = 1 / 30
function love.update(dt)
  -- Prevent the delta time from getting out of control.
  if dt > MAX_DELTA_TIME then dt = MAX_DELTA_TIME end

  -- Slow down time in debug mode.
  if arg[2] == 'debug' and love.keyboard.isDown('space') then dt = dt*0.5 end

  Timer.update(dt) -- Update global timer events.

  -- If there is a current GameState, update it.
  if GameState.currentState ~= nil then GameState.currentState:update(dt) end

  -- Use lurker for live reload in debug mode.
  if DEBUG then require("external.lurker").update() end
end

function love.draw()
  -- If there is a current gamestate, draw it.
  if GameState.currentState ~= nil then GameState.currentState:draw() end
end
