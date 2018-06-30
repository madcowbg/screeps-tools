log = require 'log'

# Memory.statistics: {[key: number]: StatisticsData};
# StatisticsData - values: {[key: string]: number | undefined}
MAX_TICKS_STATS = 10;

Memory.statistics = {} unless Memory.statistics?

setStat = (statistic, value) ->
  (Memory.statistics[Game.time] ?= {values: {}}).values[statistic] = value

clean = (beforeTick) ->
  return unless Memory.statistics?
  delete Memory.statistics[time] for time, statistics of Memory.statistics when parseInt(time, 10) <= beforeTick

cleanup = () ->
  statisticTimes = (parseInt(time, 10) for time, s of Memory.statistics)
  #    console.log statisticTimes.length
  if statisticTimes.length > MAX_TICKS_STATS
    statisticTimes = statisticTimes.sort()
    #      console.log "cleaning #{statisticTimes[statisticTimes.length - MAX_TICKS_STATS]}!"
    clean statisticTimes[statisticTimes.length - MAX_TICKS_STATS + 1]

module.exports.endTick = () ->
  setStat "cpu.getUsed",  Game.cpu.getUsed()
  setStat "done", 1

module.exports.setStat = setStat
#module.exports.forRoom = (room) ->
#  setStat: (statistic, value) ->
#    setStat "room.#{room.name}.#{statistic}", value

module.exports.beginTick = () ->
  now = Date.now()
  do cleanup
  setStat "cpu.bucket",  Game.cpu.bucket
  setStat "cpu.limit",  Game.cpu.limit

  setStat "time", (now - now % 1000)
  setStat "tick", Game.time

  setStat "gcl.progress",  Game.gcl.progress
  setStat "gcl.progressTotal",  Game.gcl.progressTotal
  setStat "gcl.level",  Game.gcl.level

  # TODO move this to colony logic...
  (runBasicStatsRoom room) for rn, room of Game.rooms
  setStat "ai.numCreeps", (_.keys Game.creeps).length

runBasicStatsRoom = (room) ->
  isMyRoom = if room.controller then room.controller.my else 0

  setStat "room.#{room.name}.myRoom", isMyRoom
  if isMyRoom
    setStat "room.#{room.name}.energyAvailable",  room.energyAvailable
    setStat "room.#{room.name}.energyCapacityAvailable",  room.energyCapacityAvailable

    if room.controller?
      setStat "room.#{room.name}.controller.level", room.controller.level
      setStat "room.#{room.name}.controller.progress", room.controller.progress
      setStat "room.#{room.name}.controller.progressTotal", room.controller.progressTotal

    stored = if room.storage then room.storage.store[RESOURCE_ENERGY] else 0
    setStat "room.#{room.name}.storedEnergy", stored

  for source in room.find(FIND_SOURCES)
    setStat "room.#{room.name}.source.#{source.id}.energy", source.energy
    setStat "room.#{room.name}.source.#{source.id}.energyCapacity", source.energyCapacity
