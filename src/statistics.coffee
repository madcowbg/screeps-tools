
# Memory.statistics: {[key: number]: StatisticsData};
# StatisticsData - values: {[key: string]: number | undefined}
MAX_TICKS_STATS = 10;

Memory.statistics = {} unless Memory.statistics?

init = () =>  Memory.statistics[Game.time] = {values: {}} unless Memory.statistics[Game.time]?

setStat = (statistic, value) ->
  do init
  Memory.statistics[Game.time].values[statistic] = value

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

module.exports.setStat = setStat

module.exports.runCpuStats = () ->
  setStat "cpu.bucket",  Game.cpu.bucket
  setStat "cpu.limit",  Game.cpu.limit
#// setStat("cpu.stats",  Game.cpu.getUsed() - lastTick
  setStat "cpu.getUsed",  Game.cpu.getUsed()


module.exports.initStats = () ->
  now = Date.now()
  setStat "time", (now - now % 1000)

module.exports.runBasicStats = () ->
  runBasicStatsRoom room for i, room of Game.rooms

  setStat "gcl.progress",  Game.gcl.progress
  setStat "gcl.progressTotal",  Game.gcl.progressTotal
  setStat "gcl.level",  Game.gcl.level

  #// for (const spawnKey in spawns) {
  #//   const spawn = Game.spawns[spawnKey];
  #//   setStat("spawn." + spawn.name + ".defenderIndex",  spawn.memory.defenderIndex;
  #// }

  setStat "ai.build", Memory.buildN if Memory.buildN?
  setStat "ai.creeps.count", (i for i of Game.creeps).length
  setStat "ai.creeps.costPerTick", (_.sum (creep.costPerTick() for i, creep of Game.creeps))

runBasicStatsRoom = (room) ->
  isMyRoom = if room.controller then room.controller.my else 0

  if isMyRoom
    setStat "room." + room.name + ".myRoom", 1
    setStat "room." + room.name + ".energyAvailable",  room.energyAvailable
    setStat "room." + room.name + ".energyCapacityAvailable",  room.energyCapacityAvailable

    if room.controller?
      setStat "room." + room.name + ".controllerProgress", room.controller.progress
      setStat "room." + room.name + ".controllerProgressTotal", room.controller.progressTotal

    stored = if room.storage then room.storage.store[RESOURCE_ENERGY] else 0
    setStat "room." + room.name + ".storedEnergy", stored
  else
    setStat "room." + room.name + ".myRoom",  0

  setStat "room.#{room.name}.source.#{source.id}.energy", source.energy for source in room.find(FIND_SOURCES)

  setStat "room.#{room.name}.creeps.count", (i for i, creep of Game.creeps when creep.room.name == room.name).length
  setStat "room.#{room.name}.creeps.costPerTick", (_.sum (creep.costPerTick() for i, creep of Game.creeps when creep.room.name == room.name))

  do cleanup
