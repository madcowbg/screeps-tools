_ = require 'lodash'

keyFromVal = (a, i) -> "{#{i}:#{typeof a}:#{a}}"
isCorrectKey = (a) -> typeof a != 'number' and typeof a != 'string'

cacheKey = (args) ->
  return "{}" if args.length == 0
  return keyFromVal(args[0], 0) if args.length == 1 and (typeof args[0] == 'string' or typeof args[0] == 'number')
  throw new TypeError "bad parameters of memoized function: #{JSON.stringify args}" if (_.filter args, isCorrectKey).length > 0
  return (_.map args, keyFromVal).join ", "


memoizeGlobal =
  init: () ->
    (global.cache ?= {}).memoize =
      valid: true
      vals: {}
  obtain: () -> global.cache.memoize

memoizeForTick =
  init: () ->
    (global.cache ?= {}).memoizeForTick =
      time: Game.time
      vals: {}

  obtain: () ->
    cache = global.cache.memoizeForTick
    unless cache.time == Game.time
      for descriptor, v of cache.vals
        cache.vals[descriptor] = {}
      cache.time = Game.time
    return cache

memoizeByCache = (memoize) -> (descriptor, argn, f) ->
  throw new Error "duplicate memoization requested: #{descriptor}" if memoize.obtain().vals[descriptor]?
  throw new Error "invalid descriptor #{descriptor} or function #{f}" unless descriptor? and typeof f == 'function'

  memoize.obtain().vals[descriptor] = {}
  return (args...) ->
    throw new Error "Invalid number of arguments: #{args.length}, expected #{argn}" unless args.length == argn
    cache = memoize.obtain().vals[descriptor]
    throw new Error "cache invalidated!" unless cache?
    for a in args
      cache = (cache[a] ?= {})

    throw cache.error if cache.hasOwnProperty "error"
    unless cache.hasOwnProperty "val"
      try
        cache.val = f(args...)
      catch e
        cache.error = new Error(e)
        throw cache.error
    return cache.val

resetMemoized = () ->
  memoizeGlobal.init()
  memoizeForTick.init()

resetMemoized()

module.exports.memoize = memoizeByCache(memoizeGlobal)
module.exports.memoizeForTick = memoizeByCache(memoizeForTick)

module.exports.invalidateMemoized = resetMemoized
