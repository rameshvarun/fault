local FallingBlocks = PlayState:addState('FallingBlocks')

local ONE_FRAME_ADJUST = 1/60

local function EasyPeasy()
  local pattern = {}
  local width = 0.3
  while #pattern < 5 do
    local center = lume.random(0.2, 0.8)
    table.insert(pattern, {
      t = lume.random(0.3, 0.5) + ONE_FRAME_ADJUST,
      x = center - width / 2,
      width = width
    })
  end
  pattern[1].t = 0
  return pattern
end

local function TickTockLeft()
  return {
    {t = 0.4 + ONE_FRAME_ADJUST, x = -0.1, width = 0.7},
    {t = 0.4 + ONE_FRAME_ADJUST, x = 0.4, width = 0.7},
    {t = 0.4 + ONE_FRAME_ADJUST, x = -0.1, width = 0.7},
    {t = 0.4 + ONE_FRAME_ADJUST, x = 0.4, width = 0.7}}
end

function TickTockRight()
   return {
     {t = 0.4 + ONE_FRAME_ADJUST, x = 0.4, width = 0.7},
     {t = 0.4 + ONE_FRAME_ADJUST, x = -0.1, width = 0.7},
     {t = 0.4 + ONE_FRAME_ADJUST, x = 0.4, width = 0.7},
     {t = 0.4 + ONE_FRAME_ADJUST, x = -0.1, width = 0.7}}
end

function GoRight()
  return {
    {t = 0.4 + ONE_FRAME_ADJUST, x = -0.1, width = 0.3}, {t = 0, x = 0.4, width = 0.2}, {t = 0, x = 0.8, width = 0.3},
    {t = 0.3 + ONE_FRAME_ADJUST, x = -0.1, width = 0.9}, {t = 0.0, x = 0.475, width = 0.05, height = 60 }
  }
end

function GoLeft()
  return {
    {t = 0.4 + ONE_FRAME_ADJUST, x = -0.1, width = 0.3}, {t = 0, x = 0.4, width = 0.2}, {t = 0, x = 0.8, width = 0.3},
    {t = 0.3 + ONE_FRAME_ADJUST, x = 0.2, width = 0.9}, {t = 0.0, x = 0.475, width = 0.05, height = 60 }
  }
end

function BackAndForthLeftRight()
  return {
    {t = 0.4 + ONE_FRAME_ADJUST, x = -0.1, width = 0.2}, {t = 0, x = 0.3, width = 0.8},
    {t = 0.21 + ONE_FRAME_ADJUST, x = 0.3, width = 0.05, height = 50},
    {t = 0.5 + ONE_FRAME_ADJUST, x = -0.1, width = 0.8}, {t = 0, x = 0.9, width = 0.2},
    {t = 0, x = 0.7 - 0.05, width = 0.05, height = 50}}
end

function BackAndForthRightLeft()
  return {
    {t = 0.5 + ONE_FRAME_ADJUST, x = -0.1, width = 0.8}, {t = 0, x = 0.9, width = 0.2},
    {t = 0.21 + ONE_FRAME_ADJUST, x = 0.7 - 0.05, width = 0.05, height = 50},
    {t = 0.4 + ONE_FRAME_ADJUST, x = -0.1, width = 0.2}, {t = 0, x = 0.3, width = 0.8},
    {t = 0, x = 0.3, width = 0.05, height = 50}}
end

function Squeeze()
  local expected = lume.random(0.2, 0.8)
  local width = 0.2
  return {
    {t = 0.4 + ONE_FRAME_ADJUST, x = -0.1, width = expected - (width / 2) + 0.1},
    {t = 0, x = expected + width / 2, width = 1.1 - expected - width / 2}
  }
end

function Squeeze3()
  local blocks = {}
  for i=1,3 do
    for _, block in ipairs(Squeeze()) do
      table.insert(blocks, block)
    end
  end
  return blocks
end


local PATTERNS = {TickTockRight, TickTockLeft, GoLeft, GoRight,
  BackAndForthLeftRight, BackAndForthRightLeft, Squeeze, Squeeze3}

local BLOCK_SPEED = 3*60

function FallingBlocks:enteredState()
  self:flashWhite(1.0)

  self.blocks = EasyPeasy()
  for _, pattern in ipairs(lume.shuffle(PATTERNS)) do
    for _, block in ipairs(pattern()) do
      table.insert(self.blocks, block)
    end
  end

  self.timer:after(11.75, function()
    self:destroyBlocks()
    self:gotoState('Ships')
  end)

  self.block_entities = {}
  local t = 0
  for _, block in ipairs(self.blocks) do
    local size = vector(block.width*PlayArea.SIZE, block.height or 10)
    local pos = vector((block.x - 0.5)*PlayArea.SIZE + size.x / 2,
      - PlayArea.SIZE/2 - 200 + size.y / 2)
    local velocity = vector(0, BLOCK_SPEED)

    t = t + block.t
    pos.y = pos.y - BLOCK_SPEED*t

    local blockEntity = Block(pos, 0, size, velocity, Color.RED)
    self:addEntity(blockEntity)
    table.insert(self.block_entities, blockEntity)
  end
end

function FallingBlocks:destroyBlocks()
  print("Destroying blocks...")
  for _, entity in ipairs(self.block_entities) do
    entity:destroy()
  end
end

function FallingBlocks:update(dt)
  PlayState.update(self, dt)
end
