local constants = {}

-- Android achievement and Leaderboard IDs
if ANDROID then
  constants.ACH_REACH_THE_SHIPS = 'CgkIv5Hr68sZEAIQAQ'
  constants.ACH_REACH_THE_TUNNEL = 'CgkIv5Hr68sZEAIQAg'
  constants.ACH_REACH_ENDLESS_MODE = 'CgkIv5Hr68sZEAIQAw'
  constants.ACH_PLAY_A_GAME = 'CgkIv5Hr68sZEAIQBA'
  constants.ACH_BEAT_YOUR_PERSONAL_BEST = 'CgkIv5Hr68sZEAIQBQ'

  constants.LEAD_SURVIVAL_TIME = 'CgkIv5Hr68sZEAIQAA'
end

-- iOS Achievement and Leaderboard IDs
if IOS then
  constants.ACH_REACH_THE_SHIPS = 'faultreachtheships'
  constants.ACH_REACH_THE_TUNNEL = 'faultreachthetunnel'
  constants.ACH_REACH_ENDLESS_MODE = 'faultreachendlessmode'
  constants.ACH_PLAY_A_GAME = 'faultplayagame'
  constants.ACH_BEAT_YOUR_PERSONAL_BEST = 'faultbeatyourpersonalbest'

  constants.LEAD_SURVIVAL_TIME = 'iosfaultsurvivaltime'
end

return constants
