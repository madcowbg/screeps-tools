_ = require 'lodash'

cacheKey = (args...) ->
  badParams = (_.filter args, (a) -> typeof a != 'number' and typeof a != 'string')
  throw new TypeError "bad parameters of memoized function: #{JSON.stringify badParams}" if badParams.length > 0

  return (_.map args, (a, i) -> "{#{i}:#{typeof a}:#{a}}").join ", "

module.exports.memoize = (descriptor, f) ->
  throw new Error "duplicate memoization requested: #{descriptor}" if global.cache.memoize.vals[descriptor]?
  throw new Error "invalid descriptor #{descriptor} or function #{f}" unless descriptor? and typeof f == 'function'

  memoizedCache = global.cache.memoize
  memoizedCache.vals[descriptor] = {}
  return (args...) ->
    throw new Error "memoized cache invalidated! cannot run function again..." unless memoizedCache.valid
    cache = memoizedCache.vals[descriptor]
    key = cacheKey(args...)
    cache[key] = f(args...) unless cache.hasOwnProperty key
    return cache[key]

module.exports.clearMemoizedResultsCache = () ->
  throw new Error "cannot clean invalid memoization cache!" unless (memoizedCache = global.cache?.memoize)?.valid == true
  global.cache.memoize.vals[k] = {} for k of global.cache.memoize.vals

module.exports.invalidateMemoized = invalidateMemoized = () ->
  global.cache?.memoize?.valid = false

  (global.cache ?= {}).memoize = {valid: true, vals: {}}

invalidateMemoized()
