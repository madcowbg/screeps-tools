
# import global constants to be accessible to tests
for k, v of require '@screeps/common/lib/constants'
  global[k] = v

global._ = require 'lodash'

objs = {}
addID = (id, obj) ->
  throw new Error "invalid argument" unless id? and obj?
  throw new Error "duplicate objects: #{id} already exists" if objs[id]?
  objs[id] = obj

global.Game =
  time: 2
  cpu:
    limit: 100
    tickLimit: 500
    bucket: 9000
    shardLimits: undefined
    getUsed: () -> global.manipulation.Game._getUsed

  creeps: {}
  getObjectById: (id) -> objs[id]

global.Memory = {}

# initializing game manipulation
global.manipulation =
  Game:
    _getUsed: 0

    nextTick: () ->
      global.Memory = JSON.parse JSON.stringify global.Memory
      Game.time += 1  # advance time ...
      global.manipulation.Game._getUsed = 0

    addCPUTime: (time) ->
      unless time > 0 then throw new Error "invalid time to add: #{time}."
      global.manipulation.Game._getUsed += time
