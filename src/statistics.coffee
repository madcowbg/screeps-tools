log = require 'log'

MAX_TICKS_STORED_STATISTIC = 10

Memory.stats ?= {}

clean = (beforeTick) ->

module.exports.gc = () ->
  return unless Memory.stats?

  statisticTimes = (parseInt(time, 10) for time, s of Memory.stats)
  #    console.log statisticTimes.length
  return if statisticTimes.length < MAX_TICKS_STORED_STATISTIC

  statisticTimes = statisticTimes.sort()
    #      console.log "cleaning #{statisticTimes[statisticTimes.length - MAX_TICKS_STORED_STATISTIC]}!"
  for time of Memory.stats when parseInt(time, 10) <= statisticTimes[statisticTimes.length - MAX_TICKS_STORED_STATISTIC + 1]
    delete Memory.stats[time]

module.exports.endTick = () ->
  (runBasicStatsRoom room) for rn, room of Game.rooms

  new Writer("cpu")
    .write "getUsed", Game.cpu.getUsed()
  new Writer("ai")
    .write "done", 1

class Writer
  constructor: (thisName, parentObject=null) ->
    @statisticsValuesObject =
      if parentObject?
        parentObject[thisName] ?= {}
      else
        (Memory.stats[Game.time] ?= {})[thisName] ?= {}

  write: (statName, value) ->
    @statisticsValuesObject[statName] = value
    # log.info? "#{@totalPath}.#{statName}", value
    return @

  sub: (childName) -> new Writer(childName, @statisticsValuesObject)

module.exports.root = (rootName) -> new Writer rootName

module.exports.beginTick = () ->
  now = Date.now()
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

  new Writer("ai")
    .write "numCreeps", (_.keys Game.creeps).length

runBasicStatsRoom = (room) ->
  isMyRoom = if room.controller then room.controller.my else 0
  roomStats = new Writer("room").sub(room.name)
  roomStats.write "myRoom", isMyRoom
  if isMyRoom
    stored = if room.storage then room.storage.store[RESOURCE_ENERGY] else 0

    roomStats
      .write "storedEnergy", stored
      .write "energyAvailable",  room.energyAvailable
      .write "energyCapacityAvailable",  room.energyCapacityAvailable

    if room.controller?
      roomStats.sub "controller"
        .write "level", room.controller.level
        .write "progress", room.controller.progress
        .write "progressTotal", room.controller.progressTotal

  for source in room.find(FIND_SOURCES)
    roomStats.sub("source").sub(source.id)
      .write "energy", source.energy
      .write "energyCapacity", source.energyCapacity

  if room.resourceNetwork?
    roomStats.sub("resources")
      .write "consumers", room.resourceNetwork.data.consumers.length
      .write "suppliers", room.resourceNetwork.data.suppliers.length
      .write "courierTransferPickups", room.resourceNetwork.data.courierTransferPickups.length
      .write "courierDelivery", room.resourceNetwork.data.courierDelivery.length
      .write "dumps", room.resourceNetwork.data.dumps.length
