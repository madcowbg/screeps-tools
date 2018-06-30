log = require 'log'

# Memory.statistics: {[key: number]: StatisticsData};
# StatisticsData - values: {[key: string]: number | undefined}
MAX_TICKS_STATS = 10;

Memory.statistics ?= {} # fixme deprecated
Memory.stats ?= {}

clean = (beforeTick) ->
  if Memory.statistics?
    delete Memory.statistics[time] for time of Memory.statistics when parseInt(time, 10) <= beforeTick
  if Memory.stats?
    delete Memory.stats[time] for time of Memory.stats when parseInt(time, 10) <= beforeTick

cleanup = () ->
  statisticTimes = (parseInt(time, 10) for time, s of Memory.statistics)
  #    console.log statisticTimes.length
  if statisticTimes.length > MAX_TICKS_STATS
    statisticTimes = statisticTimes.sort()
    #      console.log "cleaning #{statisticTimes[statisticTimes.length - MAX_TICKS_STATS]}!"
    clean statisticTimes[statisticTimes.length - MAX_TICKS_STATS + 1]

module.exports.endTick = () ->
  new Writer("cpu")
    .write "getUsed", Game.cpu.getUsed()
  new Writer("ai")
    .write "done", 1

class Writer
  constructor: (thisName, parentWriter) ->
    Memory.stats = {}
    @obj = if parentWriter? then (parentWriter.obj[thisName] ?= {}) else ((Memory.stats[Game.time] ?= {})[thisName] ?= {})

    @statisticsMemoryForTick = (Memory.statistics[Game.time] ?= {values: {}}).values # fixme deprecated
    @totalPath = if parentWriter? then "#{parentWriter.totalPath}.#{thisName}" else thisName # fixme don't use that... deprecated

  write: (statName, value) ->
    # log.info? "#{@totalPath}.#{statName}", value
    @statisticsMemoryForTick["#{@totalPath}.#{statName}"] = value # fixme use objects instead
    return @

  sub: (childName) -> new Writer(childName, @)

module.exports.root = (rootName) -> new Writer rootName

module.exports.beginTick = () ->
  now = Date.now()
  do cleanup
  new Writer("cpu")
    .write "bucket", Game.cpu.bucket
    .write "limit", Game.cpu.limit
  new Writer("ai") # FIXME bad style to log directly ...
    .write "time", (now - now % 1000)
    .write "tick", Game.time
  new Writer("gcl")
    .write "progress",  Game.gcl.progress
    .write "progressTotal",  Game.gcl.progressTotal
    .write "level",  Game.gcl.level

  # TODO move this to colony logic...
  (runBasicStatsRoom room) for rn, room of Game.rooms
  new Writer("ai")
    .write "numCreeps", (_.keys Game.creeps).length

runBasicStatsRoom = (room) ->
  isMyRoom = if room.controller then room.controller.my else 0
  stats = new Writer("room").sub(room.name)
  stats.write "myRoom", isMyRoom
  if isMyRoom
    stored = if room.storage then room.storage.store[RESOURCE_ENERGY] else 0

    stats
      .write "storedEnergy", stored
      .write "energyAvailable",  room.energyAvailable
      .write "energyCapacityAvailable",  room.energyCapacityAvailable

    if room.controller?
      stats.sub "controller"
        .write "level", room.controller.level
        .write "progress", room.controller.progress
        .write "progressTotal", room.controller.progressTotal

  for source in room.find(FIND_SOURCES)
    stats.sub("source").sub(source.id)
      .write "energy", source.energy
      .write "energyCapacity", source.energyCapacity
