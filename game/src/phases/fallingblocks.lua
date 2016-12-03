local FallingBlocks = PlayState:addState('FallingBlocks')

local function EasyPeasy()
  local pattern = {}
  local width = 0.3
  while #pattern < 5 do
    -- var center = random.uniform(0.2, 0.8);
    -- pattern.push({t: random.uniform(0.3, 0.5), x: center - width / 2, width: width });
  end
  pattern[0].t = 0
  return pattern
end

function FallingBlocks:enteredState()
  -- self:addEntity(Block(vector(0, 0), 0, vector(100, 10), vector(0, 0), Color.RED))

  self:addEntity(Ship('top',10))
  self:addEntity(Ship('right',10))
  self:addEntity(Ship('left',10))
end
