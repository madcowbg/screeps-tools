
class TransientCached
  constructor: (@initFun) ->
    @_t = undefined

  get: () ->
    unless @_t == Game.time
      @_v = @initFun()
      @_t = Game.time
      # console.log "initialized cached with value #{@_v}!"
    return @_v

  reset: () -> delete @_t


class TransientCachedMap extends TransientCached
  constructor: (@newEl, initFun = (() -> {})) ->
    super(initFun)
    throw new Error("undefined init fun!") unless initFun
    throw new Error("undefined new el fun!") unless @newEl?

  get: (id) -> (super.get()[id] ?= @newEl(id))

  set: (id, v) -> (super.get()[id] = v)

  containsKey: (id) -> @get(id)?

module.exports.TransientCached = TransientCached
module.exports.TransientCachedMap = TransientCachedMap

