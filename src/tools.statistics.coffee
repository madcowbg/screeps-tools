log = require 'tools.log'

MAX_TICKS_STORED_STATISTIC = 10

Memory.stats ?= {}

module.exports.gc = () ->
  return unless Memory.stats?

  statisticTimes = (parseInt(time, 10) for time, s of Memory.stats)
  # console.log statisticTimes.length
  return if statisticTimes.length < MAX_TICKS_STORED_STATISTIC

  statisticTimes = statisticTimes.sort()
  # console.log "cleaning #{statisticTimes[statisticTimes.length - MAX_TICKS_STORED_STATISTIC]}!"
  for time of Memory.stats when parseInt(time, 10) <= statisticTimes[statisticTimes.length - MAX_TICKS_STORED_STATISTIC + 1]
    delete Memory.stats[time]

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
